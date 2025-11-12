//
//  CornerRadius+Extension.swift
//  Contem
//
//  Created by Design System Team
//

import SwiftUI

// MARK: - Corner Radius System Guide
/*
 # 모서리 둥글기(CornerRadius) 시스템 사용 가이드

 ## 기본 원칙
 1. 하드코딩 금지: `.cornerRadius(12)` 대신 `.radiusMedium` 사용
 2. 일관된 둥글기: 동일한 UI 요소는 동일한 radius 사용
 3. 4의 배수 체계 (8, 12, 16, 20)

 ## CornerRadius 체계

 - radiusSmall: 8pt - 버튼, 태그, 칩
 - radiusMedium: 12pt - 카드, 일반 컨테이너, 이미지
 - radiusLarge: 16pt - 배너, 큰 카드, 섹션
 - radiusXLarge: 20pt - 모달, 바텀시트

 ## 사용 예시

 ### 기본 사용법
 ```swift
 Rectangle()
     .cornerRadius(.radiusMedium)

 Button("구매하기") { }
     .cornerRadius(.radiusSmall)
 ```

 ## 결정 가이드

 UI 요소:
 - 버튼, 태그, 칩 → radiusSmall (8pt)
 - 카드, 컨테이너, 이미지 → radiusMedium (12pt)
 - 배너, 큰 카드, 섹션 → radiusLarge (16pt)
 - 모달, 바텀시트 → radiusXLarge (20pt)

 특수 케이스:
 - 완전한 원형 → Circle() 사용
 - 캡슐형 → Capsule() 사용
 */

// MARK: - CGFloat Corner Radius Constants

extension CGFloat {
    /// 8pt - 작은 둥글기
    public static let radiusSmall: CGFloat = 8

    /// 12pt - 중간 둥글기 (기본값)
    public static let radiusMedium: CGFloat = 12

    /// 16pt - 큰 둥글기
    public static let radiusLarge: CGFloat = 16

    /// 20pt - 매우 큰 둥글기
    public static let radiusXLarge: CGFloat = 20
}

// MARK: - View Extension

extension View {
    /// 작은 모서리 둥글기 (8pt)
    public func cornerRadiusSmall() -> some View {
        self.cornerRadius(.radiusSmall)
    }

    /// 중간 모서리 둥글기 (12pt)
    public func cornerRadiusMedium() -> some View {
        self.cornerRadius(.radiusMedium)
    }

    /// 큰 모서리 둥글기 (16pt)
    public func cornerRadiusLarge() -> some View {
        self.cornerRadius(.radiusLarge)
    }

    /// 매우 큰 모서리 둥글기 (20pt)
    public func cornerRadiusXLarge() -> some View {
        self.cornerRadius(.radiusXLarge)
    }
}
