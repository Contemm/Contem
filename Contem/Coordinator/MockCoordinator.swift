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
}
