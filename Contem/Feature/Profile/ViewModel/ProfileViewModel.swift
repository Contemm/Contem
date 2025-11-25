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
    }
    
    struct Output{
        var profile: ProfileEntity?
        var isLoading: Bool = false
        var errorMessage: String?
    }
    
    private let userId: String
    
    init(userId: String){
        self.userId = userId
        
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
    }
    
    func fetchProfile() async{
        output.isLoading = true
        
        Task{
            do{
                let response = try await NetworkService.shared.callRequest(router: UserProfileRequest.getOtherProfile(userId: userId), type: OtherProfileDTO.self)
                
                let entity = response.toEntity()
                output.profile = entity
            }catch let error as NetworkError{
                output.errorMessage = error.errorDescription
            }
            
            output.isLoading = false
        }
    }
}
