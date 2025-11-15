//
//  ViewFactory.swift
//  Contem
//
//  Created by HyoTaek on 11/11/25.
//

import SwiftUI

@MainActor
final class ViewFactory {
    
    // MARK: - Dependencies
    
    /// 네비게이션을 담당하는 Coordinator
    private let coordinator: CoordinatorProtocol
    
    /// API Container (모든 API 관리)
    private let apiContainer: APIContainerProtocol
    
    /// 앱의 전역 상태를 관리하는 AppState
    private let appState: AppState
    
    // MARK: - Init
    
    init(
        coordinator: CoordinatorProtocol,
        apiContainer: APIContainerProtocol = APIContainer.shared,
        appState: AppState
    ) {
        self.coordinator = coordinator
        self.apiContainer = apiContainer
        self.appState = appState
    }
    
    // MARK: - View Builder
    
    @ViewBuilder
    func makeView(for page: Page) -> some View {
        switch page {
        case .tabView:
            MainTabView(viewFactory: self)
        case .signIn:
            makeSignInView()
        case .feed:
            makeFeedView()
        case .shopping:
            makeShoppingView()
        }
    }

    // MARK: - Private View Builders
    
    /// SignInView 생성
    private func makeSignInView() -> SignInView {
        let viewModel = SignInViewModel(
            signInAPI: apiContainer.signInAPI,
            appState: appState
        )
        return SignInView(viewModel: viewModel)
    }

    /// FeedView 생성
    private func makeFeedView() -> FeedView {
        let viewModel = FeedViewModel(coordinator: coordinator)
        return FeedView(viewModel: viewModel)
    }

    /// ShoppingView 생성
    private func makeShoppingView() -> ShoppingView {
        let viewModel = ShoppingViewModel(coordinator: coordinator)
        return ShoppingView(viewModel: viewModel)
    }
}
