//
//  Opacity+Extension.swift
//  Contem
//
//  Created by 송재훈 on 11/11/25.
//

import SwiftUI

// MARK: - Opacity System Guide
/*
 # 불투명도(Opacity) 시스템 사용 가이드

 ## 기본 원칙
 1. 명명된 상수 사용: `0.1` 대신 `.opacity10` 사용
 2. 접근성 고려: 너무 낮은 opacity는 가독성 저하
 3. 텍스트에는 opacity 대신 색상으로 구분

 ## Opacity 체계

 - opacity10: 0.1 - 비활성 버튼 배경, 미묘한 구분
 - opacity15: 0.15 - 이미지 배경, 카드 배경
 - opacity30: 0.3 - 오버레이, 테두리
 - opacity50: 0.5 - 모달 배경(dimmed), 비활성 상태
 - opacity80: 0.8 - 블러 배경, 네비게이션 바

 ## 사용 예시

 ### 기본 사용법
 ```swift
 Color.primary100.opacity(.opacity30)

 Button("제출") { }
     .opacity(isValid ? 1.0 : .opacity50)
 ```

 ## 결정 가이드

 비활성 상태:
 - 비활성 버튼 배경 → opacity10
 - 이미지 배경 → opacity15
 - 비활성 상태 → opacity50

 배경/오버레이:
 - 오버레이, 테두리 → opacity30
 - 모달 배경 → opacity50
 - 블러 배경 → opacity80
 */

// MARK: - Opacity Constants

extension CGFloat {
    /// 0.1 - 매우 약한 투명도
    public static let opacity10: CGFloat = 0.1

    /// 0.15 - 약한 투명도
    public static let opacity15: CGFloat = 0.15

    /// 0.3 - 중간 투명도
    public static let opacity30: CGFloat = 0.3

    /// 0.5 - 반투명
    public static let opacity50: CGFloat = 0.5

    /// 0.8 - 강한 반투명
    public static let opacity80: CGFloat = 0.8
}

extension Double {
    /// 0.1 - 매우 약한 투명도
    public static let opacity10: Double = 0.1

    /// 0.15 - 약한 투명도
    public static let opacity15: Double = 0.15

    /// 0.3 - 중간 투명도
    public static let opacity30: Double = 0.3

    /// 0.5 - 반투명
    public static let opacity50: Double = 0.5

    /// 0.8 - 강한 반투명
    public static let opacity80: Double = 0.8
}

// MARK: - View Extension

extension View {
    /// 매우 약한 투명도 적용 (0.1)
    public func opacityVeryLight() -> some View {
        self.opacity(.opacity10)
    }

    /// 약한 투명도 적용 (0.15)
    public func opacityLight() -> some View {
        self.opacity(.opacity15)
    }

    /// 중간 투명도 적용 (0.3)
    public func opacityMedium() -> some View {
        self.opacity(.opacity30)
    }

    /// 반투명 적용 (0.5)
    public func opacityHalf() -> some View {
        self.opacity(.opacity50)
    }

    /// 강한 반투명 적용 (0.8)
    public func opacityStrong() -> some View {
        self.opacity(.opacity80)
    }
}

// MARK: - Color Extension

extension Color {
    /// 현재 색상에 매우 약한 투명도 적용 (0.1)
    public func withOpacityVeryLight() -> Color {
        self.opacity(.opacity10)
    }

    /// 현재 색상에 약한 투명도 적용 (0.15)
    public func withOpacityLight() -> Color {
        self.opacity(.opacity15)
    }

    /// 현재 색상에 중간 투명도 적용 (0.3)
    public func withOpacityMedium() -> Color {
        self.opacity(.opacity30)
    }

    /// 현재 색상에 반투명 적용 (0.5)
    public func withOpacityHalf() -> Color {
        self.opacity(.opacity50)
    }

    /// 현재 색상에 강한 반투명 적용 (0.8)
    public func withOpacityStrong() -> Color {
        self.opacity(.opacity80)
    }
}
