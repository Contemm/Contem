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

    /// View 생성을 담당하는 Factory
    private var viewFactory: ViewFactory {
        ViewFactory(coordinator: coordinator)
    }

    // MARK: - Body

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            // 초기 화면은 tabView
            viewFactory.makeView(for: .tabView)
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
    AppCoordinatorView()
}
