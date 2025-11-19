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
        var email = ""
        var password = ""
        var shouldShowAlert = false
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
                owner.coordinator?.login()
//                owner.coordinator?.push(.shoppingDetail)
//                Task {
//                    await owner.signIn(body: owner.signInBody)
//                }
            }
            .store(in: &cancellables)
    }
}

extension SignInViewModel {

    // 로그인 요청 body
    private var signInBody: [String: String] {
        return [
            "email": output.email,
            "password": output.password
        ]
    }

    // 로그인 API 호출
//    private func signIn(body: [String: String]) async {
//        do {
//            let loginResponse = try await signInAPI.signIn(body: body)
//            let accessToken = loginResponse.accessToken
//            let refreshToken = loginResponse.refreshToken
//            
//            // Keychain에 토큰 저장
//            do {
//                try KeychainManager.shared.saveAllTokens(accessToken: accessToken, refreshToken: refreshToken)
//            } catch {
//                // Keychain 저장 실패 시 에러 처리
//                print("Keychain 저장 실패: \(error.localizedDescription)")
//                output.shouldShowAlert = true
//                output.alertMessage = "로그인 정보 저장에 실패했습니다.\n앱을 재시작하면 다시 로그인해야 할 수 있습니다."
//                return
//            }
//            
//            // MainTabView로 화면 전환
//            appState.signIn()
////            coordinator?.push(AppCoordinator.Route)
//        } catch let error as NetworkError {
//            switch error {
//            case .badRequest:
//                output.shouldShowAlert = true
//                output.alertMessage = "필수 값을 채워주세요"
//                
//            case .unauthorized:
//                output.shouldShowAlert = true
//                output.alertMessage = "이메일 또는 비밀번호가 일치하지 않습니다"
//                
//            case .networkFailure(let underlyingError):
//                output.shouldShowAlert = true
//                output.alertMessage = "네트워크 연결을 확인해주세요"
//
//            case .timeout:
//                output.shouldShowAlert = true
//                output.alertMessage = "네트워크 연결을 확인해주세요"
//
//            case .serverError:
//                output.shouldShowAlert = true
//                output.alertMessage = "서버에 일시적인 문제가 발생했습니다. 잠시 후 다시 시도해주세요"
//
//            case .invalidURL:
//                print("잘못된 URL 형식 에러: \(error.localizedDescription)")
//            case .invalidResponse:
//                print("응답이 HTTPURLResponse가 아닌 경우 에러: \(error.localizedDescription)")
//            case .forbidden:
//                print("403 에러: \(error.localizedDescription)")
//            case .notFound:
//                print("404 에러: \(error.localizedDescription)")
//            case .decodingFailed:
//                print("디코딩 에러: \(error.localizedDescription)")
//            case .unknownError:
//                print("알 수 없는 에러: \(error.localizedDescription)")
//            }
//
//        } catch {
//            // 기타 에러
//            output.shouldShowAlert = true
//            output.alertMessage = "알 수 없는 오류가 발생했습니다"
//        }
//    }
}
