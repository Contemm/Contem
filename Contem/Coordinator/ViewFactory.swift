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
}
