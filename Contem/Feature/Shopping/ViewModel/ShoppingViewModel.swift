import Foundation
import Combine

@MainActor
final class ShoppingViewModel:ViewModelType {
    private let coordinator: CoordinatorProtocol
    private let shoppingAPI: ShoppingAPIProtocol

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
    
    init(coordinator: CoordinatorProtocol,
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
                }
                                
                let initMainCategory = TabCategory.outer
                let initSubCategory = initMainCategory.subCategories[0]
                
                // 초기 카테고리 설정
                output.currentCategory = initMainCategory
                output.currentSubCategory = initSubCategory
                
                // 초기 배너 로드
//                let banners = loadBanners(for: initMainCategory)
//                output.banners = banners
//                output.infiniteBanners = calculateInfiniteBanners(from: banners)
//                output.currentSubCategories = initMainCategory.subCategories.map { $0.displayName }
//                output.displayBannerIndex = calculateDisplayIndex()
                
                // 초기 상품 로드
                let products = self.loadProducts(
                    tabCategory: initMainCategory,
                    subCategory: initSubCategory
                )
                output.products = products
                
            }.store(in: &cancellables)
        
        // 메인 탭
        input.selectMainCategory
            .sink { [weak self] selectedTab in
                guard let self = self else { return }
                
                let firstSubCategory = selectedTab.subCategories[0]
                
                output.currentCategory = selectedTab
                output.currentSubCategory = firstSubCategory
                
//                let banners = loadBanners(for: selectedTab)
//                output.banners = banners
//                output.infiniteBanners = calculateInfiniteBanners(from: banners)
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
                
                let products = loadProducts(
                    tabCategory: selectedTab,
                    subCategory: firstSubCategory
                )
                output.products = products
                
            }.store(in: &cancellables)
        
        // 서브 탭
        input.selectSubCategory
            .sink { [weak self] selectedSub in
                guard let self = self else { return }
                
                let currentTab = output.currentCategory
                
                output.currentSubCategory = selectedSub
                
                let products = loadProducts(
                    tabCategory: currentTab,
                    subCategory: selectedSub
                )
                output.products = products
                
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
            ShoppingProduct(brand: "Palace", name: "팔라스 퍼텍스 퀼팅 RS…", price: 930000, imageName: "image_1"),
            ShoppingProduct(brand: "moif", name: "[더블점핑][FW25] 모…", price: 567000, imageName: "image_2"),
            ShoppingProduct(brand: "Jordan", name: "조던 1 x 자이언 윌리엄…", price: 210000, imageName: "image_3"),
            ShoppingProduct(brand: "Polyteru Human In...", name: "폴리테루 휴먼인텍스 츄…", price: 164000, imageName: "image_4"),
            ShoppingProduct(brand: "Palace", name: "팔라스 퍼텍스 퀼팅 RS…", price: 840000, imageName: "image_5"),
            ShoppingProduct(brand: "moif", name: "[더블점핑][FW25] 모…", price: 567000, imageName: "image_6"),
            ShoppingProduct(brand: "IAB Studio", name: "아이앱 스튜디오 아이앱…", price: 166000, imageName: "image_7"),
            ShoppingProduct(brand: "moif", name: "[더블점핑][FW25] 모…", price: 495000, imageName: "image_1"),
            ShoppingProduct(brand: "Nike", name: "(W) 나이키 아스트로그…", price: 138000, imageName: "image_2"),
            ShoppingProduct(brand: "Polyteru", name: "폴리테루 팬츠…", price: 164000, imageName: "image_3"),
            ShoppingProduct(brand: "Nike", name: "나이키 신발…", price: 200000, imageName: "image_4"),
            ShoppingProduct(brand: "Palace", name: "팔라스 재킷…", price: 750000, imageName: "image_5")
        ]
    }
    
}
