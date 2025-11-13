//
//  SignInView.swift
//  Contem
//
//  Created by HyoTaek on 11/13/25.
//

import SwiftUI

struct SignInView: View {
    
    // MARK: - Property
    
    @State private var email = ""
    @State private var password = ""
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: .spacing16) {
            TextField("이메일을 입력해주세요", text: $email)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: .spacing16)
                        .stroke(.gray300, lineWidth: 1)
                )
            
            SecureField("비밀번호를 입력해주세요", text: $password)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: .spacing16)
                        .stroke(.gray300, lineWidth: 1)
                )

            Button(action: {
                // TODO: 로그인 로직 구현
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
    }
}
