import Foundation
import Combine

@MainActor
final class ShoppingViewModel:ViewModelType {
//    private let coordinator: CoordinatorProtocol
    private let shoppingAPI: ShoppingAPIProtocol
    
    private weak var coordinator: AppCoordinator?

    // disposeBag
    var cancellables = Set<AnyCancellable>()
    
    var input = Input()
    
    @Published
    var output = Output()
    
    struct Input {
        let onAppear = PassthroughSubject<Void, Never>()
        let selectMainCategory = CurrentValueSubject<TabCategory, Never>(.outer)
        let selectSubCategory = CurrentValueSubject<SubCategory, Never>(OuterSubCategory.padding)
    }
    
    struct Output {
        var banners: [Banner] = []
        var currentBannerIndex: Int = 1
        var infiniteBanners: [Banner] = []
        var displayBannerIndex: Int = 1
        var currentSubCategories: [String] = []
        
        var products: [ShoppingProduct] = []
        var currentCategory = TabCategory.outer
        var currentSubCategory: SubCategory = OuterSubCategory.padding
    }
    
    init(
        coordinator: AppCoordinator,
//        coordinator: CoordinatorProtocol,
         shoppingAPI: ShoppingAPIProtocol) {
        self.coordinator = coordinator
        self.shoppingAPI = shoppingAPI
        transform()
    }
    
    func transform() {
        input.onAppear
            .sink { [weak self] owner in
                guard let self = self else { return }
                
                Task {
                    await self.fetchBanner(body: ["category" : TabCategory.outer.apiValue])
                    await self.fetchProducts(body: ["category" : OuterSubCategory.padding.apiValue])
                }
                
                                
                let initMainCategory = TabCategory.outer
                let initSubCategory = initMainCategory.subCategories[0]
                
                // 초기 카테고리 설정
                output.currentCategory = initMainCategory
                output.currentSubCategory = initSubCategory
                
                // 초기 배너 로드
                
                // 초기 상품 로드
//                let products = self.loadProducts(
//                    tabCategory: initMainCategory,
//                    subCategory: initSubCategory
//                )
//                output.products = products
                
            }.store(in: &cancellables)
        
        // 메인 탭
        input.selectMainCategory
            .sink { [weak self] selectedTab in
                guard let self = self else { return }
                
                let firstSubCategory = selectedTab.subCategories[0]
                
                output.currentCategory = selectedTab
                output.currentSubCategory = firstSubCategory
                
                output.currentSubCategories = selectedTab.subCategories.map { $0.displayName }
                output.currentBannerIndex = 1
                output.displayBannerIndex = 1
                
                if selectedTab == .outer {
                    Task {
                        await self.fetchBanner(body: ["category":selectedTab.apiValue])
                    }
                } else {
                    let mockBanners = self.loadBanners(for: selectedTab)
                    output.banners = mockBanners
                    output.infiniteBanners = calculateInfiniteBanners(from: mockBanners)
                }
                
//                let products = loadProducts(
//                    tabCategory: selectedTab,
//                    subCategory: firstSubCategory
//                )
//                output.products = products
                
                
                // 상품 로드 - 첫번째 서브카테고리에 따라 분기
                if firstSubCategory.apiValue == OuterSubCategory.padding.apiValue {
                    Task {
                        await self.fetchProducts(body: ["category": firstSubCategory.apiValue])
                    }
                } else {
                    output.products = generateMockProducts()
                }
                
            }.store(in: &cancellables)
        
        // 서브 탭
        input.selectSubCategory
            .sink { [weak self] selectedSub in
                guard let self = self else { return }
                
//                let currentTab = output.currentCategory
//                
//                output.currentSubCategory = selectedSub
//                
//                let products = loadProducts(
//                    tabCategory: currentTab,
//                    subCategory: selectedSub
//                )
//                output.products = products
                
                output.currentSubCategory = selectedSub
                
                // .padding 카테고리면 서버 데이터, 아니면 Mock 데이터
                if selectedSub.apiValue == OuterSubCategory.padding.apiValue {
                    Task {
                        await self.fetchProducts(body: ["category": selectedSub.apiValue])
                    }
                } else {
                    output.products = generateMockProducts()
                }
                
            }.store(in: &cancellables)
    }
    
}


// MARK: - Banner Logic
extension ShoppingViewModel {
    private func calculateInfiniteBanners(from banners: [Banner]) -> [Banner] {
        guard let first = banners.first, let last = banners.last else { return banners }
        return [last] + banners + [first]
    }
    
    private func calculateDisplayIndex() -> Int {
        if output.currentBannerIndex == 0 {
            return output.banners.count
        } else if output.currentBannerIndex == output.infiniteBanners.count - 1 {
            return 1
        } else {
            return output.currentBannerIndex
        }
    }
    
    func updateBannerIndex(to newIndex: Int) {
        output.currentBannerIndex = newIndex
        output.displayBannerIndex = calculateDisplayIndex()
    }
    
    func calculateNewBannerIndex(
        dragTranslation: CGFloat,
        cardWidth: CGFloat
    ) -> Int {
        let threshold = cardWidth * 0.25
        var newIndex = output.currentBannerIndex
        
        if dragTranslation < -threshold {
            if output.currentBannerIndex < output.infiniteBanners.count - 1 {
                newIndex = output.currentBannerIndex + 1
            }
        } else if dragTranslation > threshold {
            if output.currentBannerIndex > 0 {
                newIndex = output.currentBannerIndex - 1
            }
        }
        
        return newIndex
    }
    
    func shouldPerformInfiniteScroll(for index: Int) -> Int? {
        if index == 0 && output.currentBannerIndex == 0 {
            return output.banners.count
        } else if index == output.infiniteBanners.count - 1 &&
                    output.currentBannerIndex == output.infiniteBanners.count - 1 {
            return 1
        }
        return nil
    }
}


extension ShoppingViewModel {
    
    private func fetchBanner(body: [String: String]) async {
        do {
            let result = try await shoppingAPI.getBannerList(body: body)
            let bannerList = BannerList(from: result)
            output.banners = bannerList.banners
            output.infiniteBanners = calculateInfiniteBanners(from: bannerList.banners)
            
        } catch {
            print("에러 발생 \(error)")
        }
    }
    
    private func fetchProducts(body: [String: String]) async {
        do {
            let result = try await shoppingAPI.getBannerList(body: body)
            let productList = ShoppingProductList(from: result)
            output.products = productList.products
        } catch {
            print("에러 발생 \(error)")
        }
    }
    
    
    
    /// 카테고리별 배너 로드
    private func loadBanners(for category: TabCategory) -> [Banner] {
        return [
            Banner(title: "특별한 세일\n놓치지 마세요", subtitle: "30% 할인", thumbnail: "banner_1"),
            Banner(title: "신상품 입고\n목업 목업", subtitle: "30% 할인", thumbnail: "banner_2"),
            Banner(title: "시즌 오프\n최대 50% 할인", subtitle: "최대 50% 할인", thumbnail: "banner_3"),
            Banner(title: "베스트 아이템\n목업 목업", subtitle: "30% 할인", thumbnail: "banner_4"),
            Banner(title: "특별한 혜택\n목업 목업", subtitle: "30% 할인", thumbnail: "banner_5"),
        ]
    }
    
    
    private func loadProducts(
        tabCategory: TabCategory,
        subCategory: SubCategory
    ) -> [ShoppingProduct] {
        
        let allProducts = generateMockProducts()
        return allProducts
    }
    
    private func generateMockProducts() -> [ShoppingProduct] {
        return [
            ShoppingProduct(thumbnailUrl: "image_1", brandName: "Palace", productName: "팔라스 퍼텍스 퀼팅 RS…", price: 930000),
            ShoppingProduct(thumbnailUrl: "image_2", brandName: "moif", productName: "[더블점핑][FW25] 모…", price: 567000),
            ShoppingProduct(thumbnailUrl: "image_3", brandName: "Jordan", productName: "조던 1 x 자이언 윌리엄…", price: 210000),
            ShoppingProduct(thumbnailUrl: "image_4", brandName: "Polyteru Human In...", productName: "폴리테루 휴먼인텍스 츄…", price: 164000),
            ShoppingProduct(thumbnailUrl: "image_5", brandName: "Palace", productName: "팔라스 퍼텍스 퀼팅 RS…", price: 840000),
            ShoppingProduct(thumbnailUrl: "image_6", brandName: "moif", productName: "[더블점핑][FW25] 모…", price: 567000),
            ShoppingProduct(thumbnailUrl: "image_7", brandName: "IAB Studio", productName: "아이앱 스튜디오 아이앱…", price: 166000),
            ShoppingProduct(thumbnailUrl: "image_1", brandName: "moif", productName: "[더블점핑][FW25] 모…", price: 495000),
            ShoppingProduct(thumbnailUrl: "image_2", brandName: "Nike", productName: "(W) 나이키 아스트로그…", price: 138000),
            ShoppingProduct(thumbnailUrl: "image_3", brandName: "Polyteru", productName: "폴리테루 팬츠…", price: 164000),
            ShoppingProduct(thumbnailUrl: "image_4", brandName: "Nike", productName: "나이키 신발…", price: 200000),
            ShoppingProduct(thumbnailUrl: "image_5", brandName: "Palace", productName: "팔라스 재킷…", price: 750000)
        ]
    }
    
}
