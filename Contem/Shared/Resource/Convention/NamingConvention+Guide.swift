//
//  NamingConvention+Guide.swift
//  Contem
//
//  Created by 송재훈 on 11/11/25.
//

import Foundation

// MARK: - Naming Convention Guide
/*
 # 네이밍 컨벤션 가이드

 ## 기본 원칙
 1. 명확성 > 간결성
 2. 일관성 유지
 3. Swift API Design Guidelines 준수

 ---
 
 # 변수 네이밍

 ## 단수형 vs 복수형
 - 배열/컬렉션 → 복수형
 - 단일 값 → 단수형
 - 불가산 명사 → 단수형 유지

 ```swift
 // 올바른 예시
 let products: [Product] = []      // 복수형
 let selectedProduct: Product      // 단수형

 // 불가산 명사 (Uncountable Nouns)
 let userData: UserData            // data는 불가산 명사
 let userInfo: UserInformation     // information도 불가산 명사
 let musicPlaylist: [Music]        // music은 불가산이지만 컬렉션은 복수형 변수명

 // 잘못된 예시
 let product: [Product] = []       // 배열인데 단수형
 let selectedProducts: Product     // 단일 값인데 복수형
 let datas: Data                   // data를 복수형으로 잘못 사용
 ```

 ### 주요 불가산 명사 예시
 - `data` (데이터)
 - `information` (정보)
 - `content` (콘텐츠)
 - `music` (음악)
 - `news` (뉴스)
 - `feedback` (피드백)
 - `equipment` (장비)
 - `software` (소프트웨어)

 ## Bool 변수
 - is: 상태
 - has: 소유/포함
 - should: 조건/권장
 - can: 가능 여부
 - did: 과거 완료

 ```swift
 // 올바른 예시
 var isSelected: Bool
 var hasData: Bool
 var shouldRefresh: Bool
 var canEdit: Bool
 var didAppear: Bool

 // 잘못된 예시
 var selected: Bool           // is 접두사 없음
 var isNotSelected: Bool      // 부정형 지양
 ```

 ## Closure/Action 변수
 - 동사로 시작
 - on/did: 이벤트 핸들러
 - handle: 이벤트 처리

 ```swift
 // 올바른 예시
 let onAppear: () -> Void
 let selectCategory: (Category) -> Void
 let didTapButton: () -> Void
 let handleError: (Error) -> Void

 // 잘못된 예시
 let category: (Category) -> Void      // 동사 없음
 ```

 ## State/Published 변수
 ```swift
 @State private var isLoading: Bool = false
 @State private var selectedTab: TabCategory = .outer
 @Published var products: [Product] = []
 @StateObject private var viewModel: ViewModel
 ```

 ---

 # 함수 네이밍

 ## 기본 규칙
 - 동사로 시작
 - camelCase 사용

 ```swift
 // 올바른 예시
 func fetchProducts()
 func selectCategory(_ category: Category)
 func toggleLike(for productId: String)
 func calculateTotal() -> Int

 // 잘못된 예시
 func product()           // 명사로 시작
 func handle()            // 불명확
 func updProd()           // 축약어 사용
 ```

 ---

 # 타입 네이밍

 ## View
 - PascalCase 사용
 - View 접미사 권장

 ```swift
 struct ShoppingView: View { }
 struct ProductCard: View { }
 struct PrimaryButton: View { }
 ```

 ### 하위 컴포넌트 (Subviews)
 같은 파일 내에서만 사용되는 작은 뷰 조각들

 **방법 1: Private Struct (권장 - 복잡한 UI)**
 ```swift
 struct ShoppingView: View {
     var body: some View {
         VStack {
             HeaderSection()
             ProductList()
             FooterSection()
         }
     }

     // 하위 컴포넌트는 파일 하단에 정의
 }

 // MARK: - Subviews

 private struct HeaderSection: View {
     var body: some View { }
 }

 private struct ProductList: View {
     var body: some View { }
 }

 private struct FooterSection: View {
     var body: some View { }
 }
 ```

 **방법 2: Computed Property (권장 - 간단한 UI)**
 ```swift
 struct ShoppingView: View {
     var body: some View {
         VStack {
             headerSection
             productList
             footerSection
         }
     }

     private var headerSection: some View {
         // 간단한 UI
     }

     private var productList: some View {
         // 간단한 UI
     }
 }
 ```

 **방법 3: @ViewBuilder 메서드**
 ```swift
 struct ShoppingView: View {
     var body: some View {
         VStack {
             makeHeader()
             makeProductList()
         }
     }

     @ViewBuilder
     private func makeHeader() -> some View {
         // 파라미터가 필요한 경우
     }

     @ViewBuilder
     private func makeProductList() -> some View {
         // 조건부 렌더링이 많은 경우
     }
 }
 ```

 ### 재사용 컴포넌트 (Reusable Components)
 여러 화면에서 사용되는 독립적인 컴포넌트

 **위치**: `Shared/Component/` 폴더에 별도 파일로 분리

 **네이밍 규칙**:
 - 용도 + 타입 형태
 - Card, Row, Button, Badge, Tag 등 UI 타입 명시

 ```swift
 // Shared/Component/ProductCard.swift
 struct ProductCard: View {
     let product: Product
     let onTap: () -> Void

     var body: some View { }
 }

 // Shared/Component/CategoryButton.swift
 struct CategoryButton: View {
     let category: Category
     let isSelected: Bool
     let action: () -> Void

     var body: some View { }
 }

 // Shared/Component/PriceTag.swift
 struct PriceTag: View {
     let price: Int
     let discountRate: Int?

     var body: some View { }
 }
 ```

 **사용 예시**:
 ```swift
 // ShoppingView.swift에서 재사용 컴포넌트 사용
 struct ShoppingView: View {
     var body: some View {
         ScrollView {
             ForEach(products) { product in
                 ProductCard(
                     product: product,
                     onTap: { selectProduct(product) }
                 )
             }
         }
     }
 }
 ```

 ### 네이밍 체크리스트
 - [ ] 하위 컴포넌트는 `private` 접근 제어자 사용
 - [ ] 간단한 UI는 computed property, 복잡한 UI는 struct
 - [ ] 재사용 컴포넌트는 별도 파일로 분리
 - [ ] 컴포넌트 이름에서 용도를 명확히 알 수 있어야 함
 - [ ] View 접미사는 화면 레벨에서만 사용, 작은 컴포넌트는 생략 가능

 ## ViewModel
 - PascalCase 사용
 - ViewModel 접미사 필수

 ```swift
 class ShoppingTabViewModel: ViewModelType { }
 class ItemDetailViewModel: ObservableObject { }
 ```

 ## Model
 - PascalCase 사용
 - 명사 사용

 ```swift
 struct Product { }
 struct ShoppingProduct { }
 struct ProductResponse { }
 ```

 ## Protocol
 - able/ible: 능력/특성
 - Type: 타입 정의
 - Delegate: 위임 패턴

 ```swift
 protocol Likeable { }
 protocol ViewModelType { }
 protocol ProductCardDelegate { }
 ```

 ## Enum
 - 타입명: PascalCase
 - case명: camelCase

 ```swift
 enum TabCategory: String {
     case outer = "아우터"
     case top = "상의"
 }

 enum LoadingState {
     case idle
     case loading
     case loaded
     case failed(Error)
 }
 ```

 ---

 # 파일/폴더 네이밍

 ## 파일명
 - PascalCase 사용
 - 타입명 + .swift
 - Extension: Type+Extension.swift

 ```
 ShoppingView.swift
 ShoppingTabViewModel.swift
 Product.swift
 Color+Extension.swift
 ```

 ## 폴더명
 - PascalCase 단수형

 ```
 Feature/
 ├── Shopping/
 ├── Feed/
 └── MainTabBar/

 Shared/
 ├── Resource/
 ├── Component/
 └── Util/
 ```

 ## 리소스 파일
 - snake_case 사용
 - 용도_설명_번호 형식

 ```
 banner_promotion_1.jpg
 product_outer_jacket.png
 icon_heart_filled.png
 ```

 ---

 # MARK 주석 규칙

 - 영어 사용
 - 하이픈(-) 포함
 - 대문자로 시작

 ```swift
 // MARK: - Properties
 // MARK: - Initialization
 // MARK: - Body
 // MARK: - UI Components
 // MARK: - Actions
 // MARK: - Private Methods
 ```

 ## 권장 순서
 1. Properties
 2. Initialization
 3. Life Cycle
 4. Body
 5. UI Components
 6. Actions
 7. Private Methods

 ---

 # 체크리스트

 ## 변수
 - [ ] 배열은 복수형, 단일 값은 단수형
 - [ ] Bool은 is/has/should/can/did 접두사
 - [ ] Closure는 동사로 시작

 ## 함수
 - [ ] 동사로 시작
 - [ ] camelCase 사용

 ## 타입
 - [ ] PascalCase 사용
 - [ ] View는 View 접미사
 - [ ] ViewModel은 ViewModel 접미사

 ## 파일/폴더
 - [ ] 파일은 PascalCase
 - [ ] 폴더는 PascalCase 단수형
 - [ ] Assets는 snake_case

 ## MARK
 - [ ] 영어 사용
 - [ ] 하이픈(-) 포함
 - [ ] 일관된 순서
 */
