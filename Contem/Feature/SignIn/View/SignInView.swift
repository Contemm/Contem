import SwiftUI
import Combine
import AuthenticationServices

struct SignInView: View {
    
    @StateObject private var viewModel: SignInViewModel
    
    init(coordinator: AppCoordinator) {
        _viewModel = StateObject(
            wrappedValue: SignInViewModel(coordinator: coordinator)
        )
    }
    
    
    var body: some View {
        VStack(spacing: .spacing16) {
            TextField("이메일을 입력해주세요", text: $viewModel.output.email)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .keyboardType(.emailAddress)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: .spacing16)
                        .stroke(.gray300, lineWidth: 1)
                )
            
            SecureField("비밀번호를 입력해주세요", text: $viewModel.output.password)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: .spacing16)
                        .stroke(.gray300, lineWidth: 1)
                )
            
            Button(action: {
                viewModel.input.loginButtonTapped.send()
            }) {
                Text("로그인")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(.spacing16)
            }
            
            // Apple 로그인 버튼
            SignInWithAppleButton(
                onRequest: { _ in },
                onCompletion: { _ in }
            )
            .frame(height: 50)
            .cornerRadius(10)
            .padding(.horizontal)
            .overlay {
                // 버튼의 기본 제스처를 막고 ViewModel의 Input을 트리거
                Color.black.opacity(0.001)
                    .onTapGesture {
                        viewModel.input.appleLoginButtonTapped.send(())
                    }
            }
        }
        .padding(.horizontal, .spacing16)
        .alert("알림", isPresented: $viewModel.output.showAlert) {
            Button("확인", role: .cancel) { }
        } message: {
            Text(viewModel.output.alertMessage)
        }
    }
    
}
