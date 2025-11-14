//
//  AppState.swift
//  Contem
//
//  Created by HyoTaek on 11/14/25.
//

import SwiftUI
import Combine

/// 앱의 전역 상태를 관리하는 클래스
@MainActor
final class AppState: ObservableObject {

    // MARK: - Properties
    
    /// 로그인 여부
    @Published var isAuthenticated = false
    
    // MARK: - Init
    
    init() {
        // 앱 시작 시 토큰 보유 여부 확인
        self.isAuthenticated = KeychainManager.shared.hasToken
    }
    
    // MARK: - Methods

    /// 로그인 처리 (UIKit push 애니메이션 효과)
    func signIn() {
        withAnimation(.defaultTransition) {
            isAuthenticated = true
        }
    }
    
    /// 로그아웃 처리 (UIKit pop 애니메이션 효과)
    func signOut() {
        withAnimation(.defaultTransition) {
            isAuthenticated = false
        }
    }
}
