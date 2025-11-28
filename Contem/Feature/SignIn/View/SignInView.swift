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
            
            Image("contem_logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 80)
                .padding(.bottom, 20)
            
            Spacer().frame(height: 32)
            
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
            
            // 구분 선
            HStack {
                
                VStack { Divider() }
                
                Text("또는")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 8)
                
                VStack { Divider() }
            }
            
            Button(action: {
                // ViewModel의 Input 트리거
                viewModel.input.appleLoginButtonTapped.send(())
            }) {
                ZStack {
                    Circle()
                        .fill(Color.black)
                        .frame(width: 50, height: 50)
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                    
                    Image(systemName: "apple.logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22, height: 22)
                        .foregroundColor(.white)
                        .offset(y: -2)
                }
            }
        }
        .padding(.horizontal, .spacing16)
        .alert("알림", isPresented: $viewModel.output.showAlert) {
            Button("확인", role: .cancel) { }
        } message: {
            Text(viewModel.output.alertMessage)
        }
            
            
            // Apple 로그인 버튼
//            SignInWithAppleButton(
//                onRequest: { _ in },
//                onCompletion: { _ in }
//            )
//            .frame(height: 44)
//            .cornerRadius(10)
//            .overlay {
//                // 버튼의 기본 제스처를 막고 ViewModel의 Input을 트리거
//                Color.black.opacity(0.001)
//                    .onTapGesture {
//                        viewModel.input.appleLoginButtonTapped.send(())
//                    }
//            }
//        }
//        .padding(.horizontal, .spacing16)
//        .alert("알림", isPresented: $viewModel.output.showAlert) {
//            Button("확인", role: .cancel) { }
//        } message: {
//            Text(viewModel.output.alertMessage)
//        }
    }
    
}
