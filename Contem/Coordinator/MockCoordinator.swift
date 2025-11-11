//
//  MockCoordinator.swift
//  Contem
//
//  Created by HyoTaek on 11/11/25.
//

import SwiftUI
import Combine

@MainActor
final class MockCoordinator: ObservableObject, CoordinatorProtocol {

    // MARK: - Properties
    
    @Published var path = NavigationPath()
    @Published var sheet: Page?
    @Published var fullScreen: Page?
}
