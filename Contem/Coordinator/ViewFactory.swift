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
    
    // MARK: - Init
    
    init(
        coordinator: CoordinatorProtocol,
        apiContainer: APIContainerProtocol = APIContainer.shared
    ) {
        self.coordinator = coordinator
        self.apiContainer = apiContainer
    }
    
    // MARK: - View Builder
    
    @ViewBuilder
    func makeView(for page: Page) -> some View {
        switch page {
        case .tabView:
            MainTabView(coordinator: coordinator)
        }
    }
}
