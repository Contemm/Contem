//
//  SignInViewModel.swift
//  Contem
//
//  Created by HyoTaek on 11/13/25.
//

import SwiftUI
import Combine

final class SignInViewModel: ViewModelType {
    
    private weak var coordinator: AppCoordinator?
    var cancellables = Set<AnyCancellable>()
    
    var input = Input()
    
    @Published
    var output = Output()

    struct Input {
        let loginButtonTapped = PassthroughSubject<Void, Never>()
    }

    struct Output {
        var email: String = ""
        var password: String = ""
        var showAlert = false
        var alertMessage = ""
    }
    
    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
        transform()
    }

    func transform() {
        // 로그인 버튼 탭 처리
        input.loginButtonTapped
            .withUnretained(self)
            .sink { owner, _ in
                Task{
                    await self.signin()
                }
            }
            .store(in: &cancellables)
    }
    
    private func signin() async{
        do{
            _ = try await NetworkService.shared.callRequest(
                router: UserRequest.login(email: output.email, password: output.password),
                type: LoginDTO.self
            )
            coordinator?.rootRoute = .tabView
        }catch{
            output.alertMessage = error.localizedDescription
            output.showAlert = true
        }
    }
}
