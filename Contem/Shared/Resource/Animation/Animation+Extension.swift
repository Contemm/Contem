//
//  Animation+Extension.swift
//  Contem
//
//  Created by Design System Team
//

import SwiftUI

// MARK: - Animation System Guide
/*
 # 애니메이션(Animation) 시스템 사용 가이드

 ## 기본 원칙
 1. 일관된 타이밍: 동일한 종류의 애니메이션은 동일한 duration 사용
 2. 적절한 easing: easeInOut이 대부분의 경우에 자연스러움
 3. 성능 고려: 과도한 애니메이션은 성능 저하 및 사용자 혼란

 ## Animation 체계

 ### Quick (빠른 전환)
 - Duration: 0.2초
 - Easing: easeInOut
 - 용도: 탭 선택, 토글, 버튼 피드백, 즉각적인 상태 변화

 ### Default (기본 전환)
 - Duration: 0.3초
 - Easing: easeInOut
 - 용도: 일반적인 화면 전환, 카드 등장/사라짐, 대부분의 UI 변화

 ### Slow (느린 전환)
 - Duration: 0.5초
 - Easing: easeInOut
 - 용도: 부드러운 페이드 인/아웃, 스크롤 애니메이션, 강조 효과

 ### Spring (스프링 애니메이션)
 - Response: 0.5초, Damping Fraction: 0.7
 - 용도: 바운스 효과, 모달 등장, 인터랙티브한 요소

 ## 사용 예시

 ### 기본 사용법
 ```swift
 withAnimation(.defaultTransition) {
     isSelected.toggle()
 }
 ```

 ## 결정 가이드
 
 quickTransition (0.2초):
 - 사용자 입력에 대한 즉각적인 피드백
 - 작은 상태 변화 (선택/비선택)
 - 미니멀한 느낌

 defaultTransition (0.3초):
 - 대부분의 경우 기본 선택
 - 자연스러운 변화
 - 확신이 없을 때

 slowTransition (0.5초):
 - 중요한 변화 강조
 - 사용자가 인지할 시간 필요
 - 부드러운 느낌

 spring:
 - 물리적 반응이 필요할 때
 - 인터랙티브한 요소
 - 생동감 있는 느낌
 */

// MARK: - Animation Presets

extension Animation {
    /// Quick Transition - 0.2초
    /// 용도: 탭 선택, 토글, 버튼 피드백
    public static let quickTransition: Animation = .easeInOut(duration: 0.2)

    /// Default Transition - 0.3초 (기본값)
    /// 용도: 일반적인 화면 전환, 카드 등장/사라짐
    public static let defaultTransition: Animation = .easeInOut(duration: 0.3)

    /// Slow Transition - 0.5초
    /// 용도: 부드러운 페이드, 스크롤 애니메이션
    public static let slowTransition: Animation = .easeInOut(duration: 0.5)

    /// Spring Animation - 바운스 효과
    /// 용도: 모달 등장, 인터랙티브한 요소
    public static let spring: Animation = .spring(response: 0.5, dampingFraction: 0.7)

    /// Bouncy Spring - 더 강한 바운스
    /// 용도: 강조가 필요한 등장 효과
    public static let bouncy: Animation = .spring(response: 0.6, dampingFraction: 0.6)

    /// Smooth Spring - 부드러운 스프링
    /// 용도: 자연스러운 물리 효과
    public static let smoothSpring: Animation = .spring(response: 0.4, dampingFraction: 0.8)
}

// MARK: - Transition Presets

extension AnyTransition {
    /// 페이드 + 스케일 전환
    /// 용도: 카드, 모달 등장
    public static let scaleAndFade: AnyTransition = .scale.combined(with: .opacity)

    /// 아래에서 위로 슬라이드 + 페이드
    /// 용도: 바텀시트, 알림
    public static let slideUpAndFade: AnyTransition = .move(edge: .bottom).combined(with: .opacity)

    /// 위에서 아래로 슬라이드 + 페이드
    /// 용도: 드롭다운, 알림 배너
    public static let slideDownAndFade: AnyTransition = .move(edge: .top).combined(with: .opacity)

    /// 왼쪽으로 슬라이드 + 페이드
    /// 용도: 뒤로가기
    public static let slideLeftAndFade: AnyTransition = .move(edge: .trailing).combined(with: .opacity)

    /// 오른쪽으로 슬라이드 + 페이드
    /// 용도: 다음 화면
    public static let slideRightAndFade: AnyTransition = .move(edge: .leading).combined(with: .opacity)
}

// MARK: - View Extension for Convenient Animation

extension View {
    /// 기본 애니메이션 적용 (0.3초)
    /// 용도: 일반적인 UI 변화
    public func animateDefault<V: Equatable>(value: V) -> some View {
        self.animation(.defaultTransition, value: value)
    }

    /// 빠른 애니메이션 적용 (0.2초)
    /// 용도: 탭 선택, 토글
    public func animateQuick<V: Equatable>(value: V) -> some View {
        self.animation(.quickTransition, value: value)
    }

    /// 느린 애니메이션 적용 (0.5초)
    /// 용도: 페이드 인/아웃
    public func animateSlow<V: Equatable>(value: V) -> some View {
        self.animation(.slowTransition, value: value)
    }

    /// 스프링 애니메이션 적용
    /// 용도: 모달, 인터랙티브 요소
    public func animateSpring<V: Equatable>(value: V) -> some View {
        self.animation(.spring, value: value)
    }
}
