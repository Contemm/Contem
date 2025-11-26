//
//  StyleDetailViewModel.swift
//  Contem
//
//  Created by 이상민 on 11/17/25.
//

import Foundation
import Combine

final class StyleDetailViewModel: ViewModelType{
    
    //MARK: - Properties
    var cancellables = Set<AnyCancellable>()
    
    var input = Input()
    @Published var output: Output = Output()
    
    struct Input{
        let appear = PassthroughSubject<Void, Never>()
        let profileTapped = PassthroughSubject<Void,Never>()
        let likebuttonTapped = PassthroughSubject<Void,Never>()
        let commentButtonTapped = PassthroughSubject<String, Never>()
    }
    
    struct Output{
        var style: StyleEntity?
        var isStyleLiked: Bool = false
        var isLoading: Bool = false
        var errorMessage: String?
        var tags: [Int: [StyleTag]] = [:]
    }
    
    private let postId: String
    private weak var coordinator: AppCoordinator?
    private var currentUserId: String? //캐싱된 UserID
    private let networkLikeTrigger = PassthroughSubject<Void, Never>() //디바운싱용 Subject

    init(postId: String = APIConfig.testPostId, coordinator: AppCoordinator) {
        self.postId = postId
        self.coordinator = coordinator
        Task{
            self.currentUserId = await TokenStorage.shared.getUserId()
        }

        transform()
    }

    func transform() {
        input.appear
            .sink { [weak self] _ in
                guard let self else { return }
                Task{
                    await self.fetchStyleDetail()
                }
            }
            .store(in: &cancellables)
        
        input.profileTapped
            .sink { [weak self] _ in
                guard let self,
                let userId = output.style?.creator.userId else { return }
                self.coordinator?.push(.profile(userId: userId))
            }
            .store(in: &cancellables)
        
        input.likebuttonTapped
            .sink { [weak self] _ in
                guard let self else { return }
                self.handleOptimisticLike() //UI 먼저 업데이트
                self.networkLikeTrigger.send(()) //서버 요청 트리거
            }
            .store(in: &cancellables)
        
        //디바운싱 체이 -> 서버 요청
        networkLikeTrigger
            .debounce(for: .seconds(0.3), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                guard let self,
                      let style = output.style,
                      let userId = self.currentUserId else { return }
                
                Task{
                    //서버에 보낼 현재 상태는 Model의 상태를 기준으로 함\
                    let isLiked = style.likes.contains(userId)
                    await self.postLikeToServer(postId: self.postId, isLiked: isLiked)
                }
            }
            .store(in: &cancellables)
        
        input.commentButtonTapped
            .withUnretained(self)
            .sink { owner, postId in
                print("댓글 화면 열기 >> \(postId)")
                owner.coordinator?.present(sheet: .comment(postId: postId))
            }.store(in: &cancellables)
    }
    
    //MARK: - Functions
    //좋아요 UI 즉시 업데이트(낙관적 업데이트)
    private func handleOptimisticLike(){
        guard let userId = currentUserId,
              var style = output.style else {
            output.errorMessage = "로그인 후 이용 가능합니다."
            return
        }
        
        style.toggleLike(userId: userId)
        
        output.style = style
        output.isStyleLiked.toggle()
    }
    
    //롤백 함수
    private func rollbackLikeState(){
        guard let userId = currentUserId,
              var style = output.style else { return }
        style.toggleLike(userId: userId) //상태 되돌리기
        output.style = style
        output.isStyleLiked.toggle()
    }
    
    //좋아요 서버 요청
    private func postLikeToServer(postId: String, isLiked: Bool) async{
        do{
            let response = try await NetworkService.shared.callRequest(router: PostRequest.like(postId: postId, isLiked: isLiked), type: PostLikeDTO.self)
            
            self.output.isStyleLiked = response.isLiked
        }catch let error as NetworkError{
            self.rollbackLikeState()
            
            if case .statusCodeError(let type) = error {
                if type == .refreshTokenExpired() || type == .forbidden() || type == .unauthorized(){
                    currentUserId = nil
                }
            }
            
            output.errorMessage = error.errorDescription
        }catch{
            self.rollbackLikeState()
            output.errorMessage = NetworkError.unknown(error).errorDescription
        }
    }

    private func preParseAllTags(entity: StyleEntity) {
        let values = [
            entity.value1,
            entity.value2,
            entity.value3,
            entity.value4,
            entity.value5
        ]

        var dict: [Int: [StyleTag]] = [:]

        for (idx, raw) in values.enumerated(){
            guard let raw else { return }
            dict[idx] = parseTagString(raw)
        }

        output.tags = dict
    }

    // Tag Parser
    func parseTagString(_ raw: String) -> [StyleTag] {
        let parts = raw.split(separator: ":")
        var result: [StyleTag] = []
        
        for part in parts {
            guard let xRange = part.range(of: "x"),
                  let yRange = part.range(of: "y") else { continue }
            
            let xStr = part[xRange.upperBound..<yRange.lowerBound]
            let yStr = part[yRange.upperBound...]
            
            guard let x = Double(xStr),
                  let y = Double(yStr) else { continue }
            
            result.append(StyleTag(relX: CGFloat(x), relY: CGFloat(y)))
        }
        
        return result
    }
    
    //MARK: - Network
    func fetchStyleDetail() async{
        output.isLoading = true

        Task{
            do{
                let response = try await NetworkService.shared.callRequest(
                    router: PostRequest.post(postId: postId), //실제로 넘겨 받은 id로 넣기
                    type: PostDTO.self
                )
                
                let entity = response.toEntity()
                output.style = entity
                preParseAllTags(entity: entity)
                
                let isLiked: Bool
                if let userId = currentUserId{
                    isLiked = entity.likes.contains(userId)
                }else{
                    isLiked = false
                }
                output.isStyleLiked = isLiked
            }catch{
                output.errorMessage = error.localizedDescription
            }
            
            output.isLoading = false
        }
    }
}
