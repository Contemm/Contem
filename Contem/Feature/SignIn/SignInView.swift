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
    
    // MARK: - Body
    
    var body: some View {
        TextField("이메일을 입력해주세요", text: $email)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: .spacing16)
                    .stroke(.gray300, lineWidth: 1)
            )
            .padding(.horizontal, .spacing16)
    }
}
