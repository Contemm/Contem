//
//  ProfileViewModel.swift
//  Contem
//
//  Created by 이상민 on 11/26/25.
//

import Foundation
import Combine

final class ProfileViewModel: ViewModelType{
    
    //MARK: - Properties
    var cancellables = Set<AnyCancellable>()
    
    var input = Input()
    @Published var output: Output = Output()
    
    struct Input{
        let appear = PassthroughSubject<Void, Never>()
        let followButtonTapped = PassthroughSubject<Void, Never>()
    }
    
    struct Output{
        var profile: ProfileEntity?
        var isLoading: Bool = false
        var isFollowing: Bool = false
        var errorMessage: String?
    }
    
    private let userId: String
    private var currentUserId: String?
    private let networkFollowTrigger = PassthroughSubject<Void, Never>() //디바운싱용 Subject
    
    init(userId: String){
        self.userId = userId
        
        Task{
            self.currentUserId = await TokenStorage.shared.getUserId()
        }
        transform()
    }
    
    func transform() {
        input.appear
            .sink { [weak self] _ in
                Task{
                    await self?.fetchProfile()
                }
            }
            .store(in: &cancellables)
        
        input.followButtonTapped
            .sink { [weak self] _ in
                guard let self else { return }
                self.handleOptimisticFollow() //UI 먼저 업데이트
                self.networkFollowTrigger.send(()) //서버 요청 트리거
            }
            .store(in: &cancellables)
        
        networkFollowTrigger
            .debounce(for: .seconds(0.3), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                guard let self else { return }
                Task{
                    let isFollowing = self.output.isFollowing
                    await self.postFollowToServer(isFollowing: isFollowing)
                }
            }
            .store(in: &cancellables)
    }
    
    private func handleOptimisticFollow(){
        guard let _ = self.currentUserId,
              var _ = output.profile else{
            output.errorMessage = "로그인 후 이용 가능합니다."
            return
        }
        
        let newFollowingState = !output.isFollowing

        output.isFollowing = newFollowingState
    }
    
    private func rollbackFollowState(){
        guard let _ = self.currentUserId,
              var _ = output.profile else { return }
        
        let rolledBackState = !output.isFollowing
        
        output.isFollowing = !output.isFollowing
        
        self.output.isFollowing = rolledBackState
    }
    
    private func postFollowToServer(isFollowing: Bool) async{
        do{
            let response = try await NetworkService.shared.callRequest(
                router: FollowRequest
                    .follow(userId: userId, isFollow: isFollowing),
                type: FollowDTO.self
            )
            
            self.output.isFollowing = response.followingStatus
            await fetchProfile()
        }catch let error as NetworkError{
            self.rollbackFollowState()
            
            if case .statusCodeError(let type) = error {
                if type == .refreshTokenExpired() || type == .forbidden() || type == .unauthorized(){
                    currentUserId = nil
                }
            }
            
            output.errorMessage = error.errorDescription
        }catch{
            self.rollbackFollowState()
            output.errorMessage = NetworkError.unknown(error).errorDescription
        }
    }
    
    func fetchProfile(isSlient: Bool = false) async{
        if !isSlient{
            output.isLoading = true
        }
        
        Task{
            do{
                let response = try await NetworkService.shared.callRequest(router: UserProfileRequest.getOtherProfile(userId: userId), type: OtherProfileDTO.self)
                
                let entity = response.toEntity()
                output.profile = entity
                output.isFollowing = entity.isFollowing(userId: currentUserId)
            }catch let error as NetworkError{
                output.errorMessage = error.errorDescription
            }
            
            output.isLoading = false
        }
    }
}
