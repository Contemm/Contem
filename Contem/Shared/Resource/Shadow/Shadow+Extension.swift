//
//  Shadow+Extension.swift
//  Contem
//
//  Created by 송재훈 on 11/11/25.
//

import SwiftUI

// MARK: - Shadow System Guide
/*
 # 그림자(Shadow) 시스템 사용 가이드
 
 ## 기본 원칙
 1. Material Design Elevation 개념
 2. 일관된 그림자: 동일한 레벨은 동일한 그림자
 3. 성능 고려: 필요한 곳에만 사용
 
 ## Shadow 체계
 
 - shadowLight (Elevation 1): 카드 기본 상태, hover
 - shadowMedium (Elevation 2): 활성 카드, 버튼, 드롭다운
 - shadowHeavy (Elevation 3): 모달, 팝업, 플로팅 버튼
 
 ## 사용 예시
 
 ### 기본 사용법
 ```swift
 Rectangle()
 .shadowMedium()
 
 VStack { }
 .shadowLight()
 ```
 
 ## 결정 가이드
 
 UI 요소:
 - 카드 기본 상태, hover → shadowLight (Elevation 1)
 - 활성 카드, 버튼, 드롭다운 → shadowMedium (Elevation 2)
 - 모달, 팝업, 플로팅 버튼 → shadowHeavy (Elevation 3)
 
 주의사항:
 - ScrollView 내 많은 아이템에 사용 시 성능 저하
 - 대안: 배경색 또는 테두리 사용
 - 그림자 중첩 금지
 */

// MARK: - Shadow Presets

struct ShadowStyle {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
    
    /// Light Shadow - Elevation 1
    static let light = ShadowStyle(
        color: Color.primary100.opacity(0.05),
        radius: 4,
        x: 0,
        y: 2
    )
    
    /// Medium Shadow - Elevation 2
    static let medium = ShadowStyle(
        color: Color.primary100.opacity(0.1),
        radius: 8,
        x: 0,
        y: 4
    )
    
    /// Heavy Shadow - Elevation 3
    static let heavy = ShadowStyle(
        color: Color.primary100.opacity(0.2),
        radius: 16,
        x: 0,
        y: 8
    )
}

// MARK: - View Extension

extension View {
    /// 가벼운 그림자 (Elevation 1)
    func shadowLight() -> some View {
        self.shadow(
            color: ShadowStyle.light.color,
            radius: ShadowStyle.light.radius,
            x: ShadowStyle.light.x,
            y: ShadowStyle.light.y
        )
    }
    
    /// 중간 그림자 (Elevation 2)
    func shadowMedium() -> some View {
        self.shadow(
            color: ShadowStyle.medium.color,
            radius: ShadowStyle.medium.radius,
            x: ShadowStyle.medium.x,
            y: ShadowStyle.medium.y
        )
    }
    
    /// 강한 그림자 (Elevation 3)
    func shadowHeavy() -> some View {
        self.shadow(
            color: ShadowStyle.heavy.color,
            radius: ShadowStyle.heavy.radius,
            x: ShadowStyle.heavy.x,
            y: ShadowStyle.heavy.y
        )
    }
    
    /// 그림자 제거
    func shadowNone() -> some View {
        self.shadow(color: .clear, radius: 0)
    }
}
