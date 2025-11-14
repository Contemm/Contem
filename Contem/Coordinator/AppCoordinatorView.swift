//
//  AppCoordinatorView.swift
//  Contem
//
//  Created by HyoTaek on 11/11/25.
//

import SwiftUI

/// 앱의 네비게이션을 관리하는 최상위 View
struct AppCoordinatorView: View {

    // MARK: - Properties

    /// Protocol을 채택한 Coordinator
    @StateObject private var coordinator = Coordinator()

    /// 앱의 전역 상태를 관리하는 AppState
    @ObservedObject var appState: AppState
    
    /// View 생성을 담당하는 Factory
    private var viewFactory: ViewFactory {
        ViewFactory(coordinator: coordinator, appState: appState)
    }

    // MARK: - Body

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            // 로그인 상태에 따라 초기 화면 분기
            Group {
                if appState.isAuthenticated {
                    viewFactory.makeView(for: .tabView)
                        .transition(.move(edge: .trailing))
                } else {
                    viewFactory.makeView(for: .signIn)
                        .transition(.move(edge: .leading))
                }
            }
            // push
            .navigationDestination(for: Page.self) { page in
                viewFactory.makeView(for: page)
            }
            // sheet
            .sheet(item: $coordinator.sheet) { page in
                viewFactory.makeView(for: page)
            }
            // fullScreen
            .fullScreenCover(item: $coordinator.fullScreenCover) { page in
                viewFactory.makeView(for: page)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    AppCoordinatorView(appState: AppState())
}
