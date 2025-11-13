//
//  SignInViewModel.swift
//  Contem
//
//  Created by HyoTaek on 11/13/25.
//

import SwiftUI
import Combine

final class SignInViewModel: ViewModelType {
    
    // MARK: - MVVM
    
    var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published var output = Output()
    
    // MARK: - Dependencies

//    private let coordinator: CoordinatorProtocol

    // MARK: - Input

    struct Input {
        let emailPublisher = PassthroughSubject<String, Never>()
        let passwordPublisher = PassthroughSubject<String, Never>()
        let loginButtonTapped = PassthroughSubject<Void, Never>()
    }

    // MARK: - Output

    struct Output {
        var email = ""
        var password = ""
    }

    // MARK: - Init

//    init(coordinator: CoordinatorProtocol) {
//        self.coordinator = coordinator
//        transform()
//    }
    
    init() {
        transform()
    }

    // MARK: - Transform

    func transform() {
        // 이메일 입력 처리
        input.emailPublisher
            .withUnretained(self)
            .sink { owner, email in
                owner.output.email = email
            }
            .store(in: &cancellables)

        // 비밀번호 입력 처리
        input.passwordPublisher
            .withUnretained(self)
            .sink { owner, password in
                owner.output.password = password
            }
            .store(in: &cancellables)

        // 로그인 버튼 탭 처리
        input.loginButtonTapped
            .withUnretained(self)
            .sink { owner, _ in
                print("=== 로그인 정보 ===")
                print("이메일: \(owner.output.email)")
                print("비밀번호: \(owner.output.password)")
                print("==================")
            }
            .store(in: &cancellables)
    }
}
