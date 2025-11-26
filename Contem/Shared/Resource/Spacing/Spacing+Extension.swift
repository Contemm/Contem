//
//  Spacing+Extension.swift
//  Contem
//
//  Created by 송재훈 on 11/11/25.
//

import SwiftUI

// MARK: - Spacing System Guide
/*
 # 간격(Spacing) 시스템 사용 가이드
 
 ## 기본 원칙
 1. 4의 배수 사용 (4, 8, 12, 16, 20, 24, 32)
 2. 명명된 상수 사용: `16` 대신 `.spacing16` 사용
 3. 일관성 유지: 동일한 요소는 동일한 간격
 
 ## Spacing 체계
 
 - spacing4: 4pt - 매우 작은 간격
 - spacing8: 8pt - 작은 간격
 - spacing12: 12pt - 중간 간격
 - spacing16: 16pt - 기본 간격 (가장 많이 사용)
 - spacing20: 20pt - 큰 간격
 - spacing24: 24pt - 매우 큰 간격
 - spacing32: 32pt - 최대 간격
 
 ## 사용 예시
 
 ### 기본 사용법
 ```swift
 VStack(spacing: .spacing8) { }
 
 Text("내용")
 .padding(.spacing16)
 ```
 
 ## 결정 가이드
 
 요소 간 간격:
 - 아이콘-텍스트 → spacing4
 - 근접 요소 → spacing8
 - 일반 요소 → spacing12~16
 - 섹션 구분 → spacing20~24
 - 화면 여백 → spacing20~32
 
 패딩:
 - 기본 패딩 → spacing16
 - 화면 패딩 → spacing20
 - 작은 패딩 → spacing8~12
 */

// MARK: - CGFloat Spacing Constants

extension CGFloat {
    /// 4pt - 매우 작은 간격
    static let spacing4: CGFloat = 4
    
    /// 8pt - 작은 간격
    static let spacing8: CGFloat = 8
    
    /// 12pt - 중간 간격
    static let spacing12: CGFloat = 12
    
    /// 16pt - 기본 간격
    static let spacing16: CGFloat = 16
    
    /// 20pt - 큰 간격
    static let spacing20: CGFloat = 20
    
    /// 24pt - 매우 큰 간격
    static let spacing24: CGFloat = 24
    
    /// 28pt - 매우 큰 간격
    static let spacing28: CGFloat = 28
    
    /// 32pt - 최대 간격
    static let spacing32: CGFloat = 32
    
    /// 48pt - 
    static let spacing48: CGFloat = 48
}

// MARK: - EdgeInsets Convenience

extension EdgeInsets {
    /// 모든 방향 동일 spacing
    static func all(_ spacing: CGFloat) -> EdgeInsets {
        EdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
    }
    
    /// 수평 방향 spacing
    static func horizontal(_ spacing: CGFloat) -> EdgeInsets {
        EdgeInsets(top: 0, leading: spacing, bottom: 0, trailing: spacing)
    }
    
    /// 수직 방향 spacing
    static func vertical(_ spacing: CGFloat) -> EdgeInsets {
        EdgeInsets(top: spacing, leading: 0, bottom: spacing, trailing: 0)
    }
}

// MARK: - View Extension

extension View {
    /// 기본 패딩 (16pt)
    func paddingDefault() -> some View {
        padding(.spacing16)
    }
    
    /// 화면 패딩 (20pt)
    func paddingScreen() -> some View {
        padding(.spacing20)
    }
    
    /// 수평 기본 패딩 (16pt)
    func paddingHorizontalDefault() -> some View {
        padding(.horizontal, .spacing16)
    }
    
    /// 수직 기본 패딩 (16pt)
    func paddingVerticalDefault() -> some View {
        padding(.vertical, .spacing16)
    }
}
