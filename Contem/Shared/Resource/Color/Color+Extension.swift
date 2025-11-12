//
//  Color+Extension.swift
//  Contem
//
//  Created by 송재훈 on 11/11/25.
//

import SwiftUI

// MARK: - Color System Guide
/*
 # 색상(Color) 시스템 사용 가이드

 ## 기본 원칙
 1. 하드코딩 금지: `.black` 대신 `.primary100` 사용
 2. Assets 기반: 모든 색상은 Assets.xcassets에 정의 (Dark Mode 자동 대응)
 3. Xcode 자동 생성 심볼 사용 (수동 extension 정의 금지)

 ## Color 체계

 ### Gray Scale
 - gray25: #F7F7F7 - 가장 밝은 회색 (배경, 카드)
 - gray50: #F1F1F1 - 밝은 회색 (섹션 배경)
 - gray100: #D9D9D9 - 구분선, 비활성 요소
 - gray300: #B1B1B1 - 비활성 텍스트, 플레이스홀더
 - gray500: #848482 - 보조 텍스트
 - gray700: #717171 - 일반 텍스트
 - gray900: #3C3C3C - 강조 텍스트, 제목

 ### Primary
 - primary0: #FFFFFF - 흰색 (배경, 카드, 버튼 텍스트)
 - primary100: #000000 - 검정 (주요 텍스트, 아이콘)

 ## 사용 예시

 ### 기본 사용법
 ```swift
 Text("제목")
     .foregroundColor(.primary100)

 Rectangle()
     .fill(.gray25)
 ```

 ## 결정 가이드

 텍스트:
 - 제목/강조 → primary100, gray900
 - 본문 → gray700, gray900
 - 보조 텍스트 → gray500
 - 비활성/플레이스홀더 → gray300

 배경:
 - 기본 배경 → primary0
 - 카드/섹션 → gray25, gray50
 - 비활성 배경 → gray100

 UI 요소:
 - 구분선 → gray100
 - 테두리 → gray100, gray300
 - 아이콘 → primary100, gray500, gray700
 */
