//
//  CoordinatorProtocol.swift
//  Contem
//
//  Created by HyoTaek on 11/11/25.
//

import SwiftUI

@MainActor
protocol CoordinatorProtocol: AnyObject {
    
    // MARK: - Properties
    
    var path: NavigationPath { get set }
    var sheet: Page? { get set }
    var fullScreenCover: Page? { get set }
    
    // MARK: - Push
    
    /// 특정 페이지로 push
    func push(_ page: Page)
    
    /// 이전 화면으로 돌아가기
    func pop()

    /// 루트 화면으로 돌아가기
    func popToRoot()
    
    // MARK: - Sheet
    
    /// Sheet로 페이지 표시
    func presentSheet(_ page: Page)
    
    /// Sheet 닫기
    func dismissSheet()
    
    // MARK: - FullScreenCover
    
    /// FullScreenCover로 페이지 표시
    func presentFullScreenCover(_ page: Page)
    
    /// FullScreenCover 닫기
    func dismissFullScreenCover()
}
