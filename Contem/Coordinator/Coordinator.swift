//
//  Coordinator.swift
//  Contem
//
//  Created by HyoTaek on 11/11/25.
//

import SwiftUI
import Combine

@MainActor
final class Coordinator: ObservableObject, CoordinatorProtocol {
    
    // MARK: - Properties
    
    @Published var path = NavigationPath()
    @Published var sheet: Page?
    @Published var fullScreenCover: Page?

    // MARK: - Push

    /// 특정 페이지로 push
    func push(_ page: Page) {
        path.append(page)
    }

    /// 이전 화면으로 돌아가기
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    /// 루트 화면으로 돌아가기
    func popToRoot() {
        path = NavigationPath()
    }
    
    // MARK: - Sheet
    
    /// Sheet로 페이지 표시
    func presentSheet(_ page: Page) {
        sheet = page
    }

    /// Sheet 닫기
    func dismissSheet() {
        sheet = nil
    }
    
    // MARK: - FullScreenCover
    
    /// FullScreenCover로 페이지 표시
    func presentFullScreenCover(_ page: Page) {
        fullScreenCover = page
    }

    /// FullScreenCover 닫기
    func dismissFullScreenCover() {
        fullScreenCover = nil
    }
}
