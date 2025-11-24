//
//  SignInView.swift
//  Contem
//
//  Created by HyoTaek on 11/13/25.
//

import SwiftUI
import Combine

struct SignInView: View {
    
    @ObservedObject private var viewModel: SignInViewModel
    
    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
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
        }
        .padding(.horizontal, .spacing16)
        .alert("알림", isPresented: $viewModel.output.showAlert) {
            Button("확인", role: .cancel) { }
        } message: {
            Text(viewModel.output.alertMessage)
        }
    }
}
