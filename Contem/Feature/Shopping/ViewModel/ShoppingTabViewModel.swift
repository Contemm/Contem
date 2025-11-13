import Foundation
import Combine

@MainActor
final class ShoppingTabViewModel:ViewModelType {
    
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
        var infiniteBanners: [Banner] {
            guard let first = banners.first, let last = banners.last else { return banners }
            return [last] + banners + [first]
        }
        var products: [ShoppingProduct] = []
        var currentCategory = TabCategory.outer
        var currentSubCategory: SubCategory = OuterSubCategory.padding
        var currentSubCategories: [String] {
            currentCategory.subCategories.map { $0.displayName }
        }
        
    }
    
    init() {
        transform()
    }
    
    func transform() {
        input.onAppear
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                let initMainCategory = TabCategory.outer
                let initSubCategory = initMainCategory.subCategories[0]
                
                // 초기 카테고리 설정
                output.currentCategory = initMainCategory
                output.currentSubCategory = initSubCategory
                
                // 초기 배너 로드
                let banners = loadBanners(for: initMainCategory)
                output.banners = banners
                
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
                
                // 첫 번째 서브 카테고리 자동 선택
                let firstSubCategory = selectedTab.subCategories[0]
                
                // 카테고리 업데이트
                output.currentCategory = selectedTab
                output.currentSubCategory = firstSubCategory
                
                // 배너 로드
                let banners = self.loadBanners(for: selectedTab)
                output.banners = banners
                
                // 상품 로드
                let products = self.loadProducts(
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
                
                // 서브 카테고리 업데이트
                output.currentSubCategory = selectedSub
                
                // 현재 탭 + 선택된 서브 카테고리로 상품 필터링
                let products = self.loadProducts(
                    tabCategory: currentTab,
                    subCategory: selectedSub
                )
                output.products = products
                
            }.store(in: &cancellables)
    }
    
}


extension ShoppingTabViewModel {
    /// 카테고리별 배너 로드
    private func loadBanners(for category: TabCategory) -> [Banner] {
        switch category {
        case .outer:
            return [
                Banner(title: "특별한 세일", subtitle: "놓치지 마세요", thumbnail: "banner_1"),
                Banner(title: "신상품 입고", subtitle: "지금 확인해보세요", thumbnail: "banner_2"),
                Banner(title: "시즌 오프", subtitle: "최대 50% 할인", thumbnail: "banner_3"),
                Banner(title: "베스트 아이템", subtitle: "인기 상품", thumbnail: "banner_4"),
                Banner(title: "특별한 혜택", subtitle: "회원 전용", thumbnail: "banner_5"),
            ]
            
        case .top:
            return [
                Banner(title: "특별한 세일", subtitle: "놓치지 마세요", thumbnail: "banner_1"),
                Banner(title: "신상품 입고", subtitle: "지금 확인해보세요", thumbnail: "banner_2"),
                Banner(title: "시즌 오프", subtitle: "최대 50% 할인", thumbnail: "banner_3"),
                Banner(title: "베스트 아이템", subtitle: "인기 상품", thumbnail: "banner_4"),
                Banner(title: "특별한 혜택", subtitle: "회원 전용", thumbnail: "banner_5"),
            ]
            
        case .bottom:
            return [
                Banner(title: "특별한 세일", subtitle: "놓치지 마세요", thumbnail: "banner_1"),
                Banner(title: "신상품 입고", subtitle: "지금 확인해보세요", thumbnail: "banner_2"),
                Banner(title: "시즌 오프", subtitle: "최대 50% 할인", thumbnail: "banner_3"),
                Banner(title: "베스트 아이템", subtitle: "인기 상품", thumbnail: "banner_4"),
                Banner(title: "특별한 혜택", subtitle: "회원 전용", thumbnail: "banner_5"),
            ]
            
        case .beauty:
            return [
                Banner(title: "특별한 세일", subtitle: "놓치지 마세요", thumbnail: "banner_1"),
                Banner(title: "신상품 입고", subtitle: "지금 확인해보세요", thumbnail: "banner_2"),
                Banner(title: "시즌 오프", subtitle: "최대 50% 할인", thumbnail: "banner_3"),
                Banner(title: "베스트 아이템", subtitle: "인기 상품", thumbnail: "banner_4"),
                Banner(title: "특별한 혜택", subtitle: "회원 전용", thumbnail: "banner_5"),
            ]
            
        case .shoes:
            return [
                Banner(title: "특별한 세일", subtitle: "놓치지 마세요", thumbnail: "banner_1"),
                Banner(title: "신상품 입고", subtitle: "지금 확인해보세요", thumbnail: "banner_2"),
                Banner(title: "시즌 오프", subtitle: "최대 50% 할인", thumbnail: "banner_3"),
                Banner(title: "베스트 아이템", subtitle: "인기 상품", thumbnail: "banner_4"),
                Banner(title: "특별한 혜택", subtitle: "회원 전용", thumbnail: "banner_5"),
            ]
            
        case .accessory:
            return [
                Banner(title: "특별한 세일", subtitle: "놓치지 마세요", thumbnail: "banner_1"),
                Banner(title: "신상품 입고", subtitle: "지금 확인해보세요", thumbnail: "banner_2"),
                Banner(title: "시즌 오프", subtitle: "최대 50% 할인", thumbnail: "banner_3"),
                Banner(title: "베스트 아이템", subtitle: "인기 상품", thumbnail: "banner_4"),
                Banner(title: "특별한 혜택", subtitle: "회원 전용", thumbnail: "banner_5"),
            ]
        }
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
