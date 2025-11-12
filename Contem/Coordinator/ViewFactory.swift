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
    
//    /// API Container
//    private let apiContainer: APIContainerProtocol
    
    // MARK: - Init
    
    init(coordinator: CoordinatorProtocol) {
        self.coordinator = coordinator
    }
    
    // MARK: - View Builder
    
    @ViewBuilder
    func makeView(for page: Page) -> some View {
        switch page {
        case .tabView:
            MainTabView(viewFactory: self)
        case .feed:
            makeFeedView()
        case .shopping:
            makeShoppingView()
        }
    }

    // MARK: - Private View Builders

    /// FeedView 생성
    private func makeFeedView() -> FeedView {
        let viewModel = FeedViewModel(coordinator: coordinator)
        return FeedView(viewModel: viewModel)
    }

    /// ShoppingView 생성
    private func makeShoppingView() -> ShoppingView {
        let viewModel = ShoppingTabViewModel(coordinator: coordinator)
        return ShoppingView(viewModel: viewModel)
    }
}
