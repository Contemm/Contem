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
    
    // MARK: - Methods

    /// 로그인 처리
    func signIn() {
        isAuthenticated = true
    }
    
    /// 로그아웃 처리
    func signOut() {
        isAuthenticated = false
    }
}
