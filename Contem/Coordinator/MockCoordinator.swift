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
    @Published var fullScreenCover: Page?
    
    // MARK: - Test Tracking Properties
    
    /// Push된 페이지 기록
    var pushedPages: [Page] = []

    /// Sheet로 표시된 페이지 기록
    var presentedSheets: [Page] = []

    /// FullScreen으로 표시된 페이지 기록
    var presentedFullScreens: [Page] = []

    /// 호출 횟수 추적
    var pushCallCount = 0
    var popCallCount = 0
    var popToRootCallCount = 0
    var presentSheetCallCount = 0
    var dismissSheetCallCount = 0
    var presentFullScreenCallCount = 0
    var dismissFullScreenCallCount = 0
    
    // MARK: - Reset

    /// 모든 추적 데이터 초기화
    func reset() {
        pushedPages.removeAll()
        presentedSheets.removeAll()
        presentedFullScreens.removeAll()
        
        pushCallCount = 0
        popCallCount = 0
        popToRootCallCount = 0
        presentSheetCallCount = 0
        dismissSheetCallCount = 0
        presentFullScreenCallCount = 0
        dismissFullScreenCallCount = 0

        path = NavigationPath()
        sheet = nil
        fullScreenCover = nil

        print("[MockCoordinator] 모든 추적 데이터 초기화")
    }
    
    // MARK: - Push

    func push(_ page: Page) {
        pushedPages.append(page)
        path.append(page)
        pushCallCount += 1
        print("[MockCoordinator] Push: \(page)")
    }

    func pop() {
        guard !path.isEmpty else {
            print("[MockCoordinator] Pop 시도 실패: Path가 비어있음")
            return
        }
        path.removeLast()
        popCallCount += 1
        print("[MockCoordinator] Pop")
    }

    func popToRoot() {
        path = NavigationPath()
        popToRootCallCount += 1
        print("[MockCoordinator] Pop to Root")
    }
    
    // MARK: - Sheet
    
    func presentSheet(_ page: Page) {
        presentedSheets.append(page)
        sheet = page
        presentSheetCallCount += 1
        print("[MockCoordinator] Present Sheet: \(page)")
    }

    func dismissSheet() {
        sheet = nil
        dismissSheetCallCount += 1
        print("[MockCoordinator] Dismiss Sheet")
    }
    
    // MARK: - FullScreenCover
    
    func presentFullScreenCover(_ page: Page) {
        presentedFullScreens.append(page)
        fullScreenCover = page
        presentFullScreenCallCount += 1
        print("[MockCoordinator] Present FullScreen: \(page)")
    }

    func dismissFullScreenCover() {
        fullScreenCover = nil
        dismissFullScreenCallCount += 1
        print("[MockCoordinator] Dismiss FullScreen")
    }
}
