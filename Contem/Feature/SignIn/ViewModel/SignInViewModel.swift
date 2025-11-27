import SwiftUI
import Combine

final class SignInViewModel: ViewModelType {
  
    private weak var coordinator: AppCoordinator?
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Dependencies (DI)
    private let appleService: AppleAuthServiceType
    private let authRepository: AuthRepositoryType
    
    var input = Input()
    
    @Published
    var output = Output()

    struct Input {
        let loginButtonTapped = PassthroughSubject<Void, Never>()
        let appleLoginButtonTapped = PassthroughSubject<Void, Never>()
    }

    struct Output {
        var email: String = ""
        var password: String = ""
        var showAlert = false
        var alertMessage = ""
        var isLoading = false
    }
    
    init(
        coordinator: AppCoordinator,
        appleService: AppleAuthServiceType = AppleAuthService(),
        authRepository: AuthRepositoryType = AuthRepository()
    ) {
        self.appleService = appleService
        self.authRepository = authRepository
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
        
        input.appleLoginButtonTapped
            .throttle(for: .seconds(1), scheduler: RunLoop.main, latest: false) // 중복 탭 방지
            .sink { [weak self] _ in
                Task { await self?.processLogin() }
            }
            .store(in: &cancellables)
    }
    
    private func signin() async{
        do{
            let response = try await NetworkService.shared.callRequest(
                router: UserRequest.login(email: output.email, password: output.password),
                type: LoginDTO.self
            )
            
            try await TokenStorage.shared.storeTokens(access: response.accessToken, refresh: response.refreshToken, userId: response.userID)
            
            coordinator?.rootRoute = .tabView
        }catch{
            output.alertMessage = error.localizedDescription
            output.showAlert = true
        }
    }
}

// MARK: - 로그인
extension SignInViewModel {
    @MainActor
    private func processLogin() async {
        output.isLoading = true
        
        do {
            // 1. 애플 서버 통신 (Identity Token 획득)
            let idToken = try await appleService.signIn()
            print("✅ Apple Token: \(idToken.prefix(10))...")
            
            // 2. 백엔드 서버 통신 (NetworkService 사용)
            let result = try await authRepository.loginWithApple(idToken: idToken)
            print("✅ Server Login Success: \(result.accessToken)")
            
            try await TokenStorage.shared.storeTokens(access: result.accessToken, refresh: result.refreshToken, userId: result.userID)
            
            coordinator?.rootRoute = .tabView
            
            // 3. 토큰 저장 (TokenStorage 활용)
            // TokenStorage.shared.save(accessToken: result.accessToken, ...)
            
            // 4. 화면 전환 (Coordinator Delegate 호출 등)
            // coordinator?.didFinishLogin()
            
        } catch {
            print("❌ Login Failed: \(error)")
        }
        
        output.isLoading = false
    }
}
