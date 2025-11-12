//
//  Font+Extension.swift
//  Contem
//
//  Created by 이상민 on 11/11/25.
//  Updated by Design System Team
//

import SwiftUI

// MARK: - Typography System Guide
/*
 # 타이포그래피(Font) 시스템 사용 가이드

 ## 기본 원칙
 1. 시스템 폰트 직접 사용 금지: `.system(size: 16)` 대신 `.bodyRegular` 사용
 2. Pretendard 폰트 사용: 모든 폰트는 Pretendard 기반
 3. weight 직접 지정 금지: 정의된 스타일 사용

 ## Font 체계

 ### Title (제목)
 - titleLarge: 24pt Bold - 메인 타이틀, 화면 제목
 - titleMedium: 20pt SemiBold - 서브 타이틀, 섹션 제목
 - titleSmall: 16pt SemiBold - 작은 제목, 카드 제목

 ### Body (본문)
 - bodyLarge: 16pt Medium - 강조 본문, 중요 텍스트
 - bodyRegular: 14pt Regular - 일반 본문, 기본 텍스트
 - bodyMedium: 14pt Medium - 강조 본문

 ### Caption (캡션/보조)
 - captionLarge: 13pt SemiBold - 작은 강조 텍스트, 버튼
 - captionRegular: 12pt Regular - 보조 정보, 부가 설명
 - captionSmall: 12pt Thin - 메타 정보, 타임스탬프

 ## 사용 예시

 ### 기본 사용법
 ```swift
 Text("쇼핑")
     .font(.titleLarge)

 Text("일반 본문")
     .font(.bodyRegular)
 ```

 ## 결정 가이드

 화면 구성:
 - 네비게이션 타이틀 → titleLarge
 - 섹션 제목 → titleMedium
 - 탭 선택/강조 → titleSmall
 - 일반 본문 → bodyRegular
 - 강조 본문 → bodyMedium, bodyLarge
 - 버튼 텍스트 → captionLarge, bodyMedium
 - 보조 정보 → captionRegular
 - 메타 정보 → captionSmall
 */

// MARK: - Title Styles

extension Font {
    /// Title Large - 24pt Bold
    /// 용도: 메인 타이틀, 화면 제목, 배너 타이틀
    static let titleLarge = Font.custom("Pretendard-Bold", size: 24)

    /// Title Medium - 20pt SemiBold
    /// 용도: 서브 타이틀, 섹션 제목
    static let titleMedium = Font.custom("Pretendard-SemiBold", size: 20)

    /// Title Small - 16pt SemiBold
    /// 용도: 작은 제목, 카드 제목, 탭 선택 시
    static let titleSmall = Font.custom("Pretendard-SemiBold", size: 16)
}

// MARK: - Body Styles

extension Font {
    /// Body Large - 16pt Medium
    /// 용도: 강조 본문, 중요 텍스트, 좋아요 카운트
    static let bodyLarge = Font.custom("Pretendard-Medium", size: 16)

    /// Body Regular - 14pt Regular
    /// 용도: 일반 본문, 기본 텍스트, 탭 기본 상태
    static let bodyRegular = Font.custom("Pretendard-Regular", size: 14)

    /// Body Medium - 14pt Medium
    /// 용도: 강조 본문, 가격 표시, 중요 정보
    static let bodyMedium = Font.custom("Pretendard-Medium", size: 14)
}

// MARK: - Caption Styles

extension Font {
    /// Caption Large - 13pt SemiBold
    /// 용도: 작은 강조 텍스트, 버튼, 브랜드명
    static let captionLarge = Font.custom("Pretendard-SemiBold", size: 13)

    /// Caption Regular - 12pt Regular
    /// 용도: 보조 정보, 부가 설명, 상품명, 배너 인디케이터
    static let captionRegular = Font.custom("Pretendard-Regular", size: 12)

    /// Caption Small - 12pt Thin
    /// 용도: 가장 작은 텍스트, 메타 정보, 타임스탬프
    static let captionSmall = Font.custom("Pretendard-Thin", size: 12)
}

// MARK: - Legacy Support (Deprecated)
extension Font {
    @available(*, deprecated, renamed: "titleLarge")
    static let titleBold = Font.custom("Pretendard-Bold", size: 24)

    @available(*, deprecated, renamed: "titleMedium")
    static let titleSemiBold = Font.custom("Pretendard-SemiBold", size: 20)

    @available(*, deprecated, message: "Use bodyLarge instead")
    static let bodyMediumOld = Font.custom("Pretendard-Medium", size: 16)

    @available(*, deprecated, renamed: "captionSmall")
    static let captionThin = Font.custom("Pretendard-Thin", size: 12)
}
