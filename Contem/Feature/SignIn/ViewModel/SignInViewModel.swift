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
