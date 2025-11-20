import Foundation

// 메인 탭 카테고리
enum TabCategory: String, CaseIterable {
    case outer = "아우터"
    case top = "상의"
    case bottom = "하의"
    case beauty = "뷰티"
    case shoes = "신발"
    case accessory = "악세사리"
    
    // API 요청용 카테고리 이름
    var apiValue: String {
        switch self {
        case .outer: return "banner_outer"
        case .top: return "banner_top"
        case .bottom: return "bottom"
        case .beauty: return "beauty"
        case .shoes: return "shoes"
        case .accessory: return "accessory"
        }
    }
    
    // 서브 카테고리 가져오기
    var subCategories: [SubCategory] {
        switch self {
        case .outer:
            return OuterSubCategory.allCases.map { $0 as SubCategory }
        case .top:
            return TopSubCategory.allCases.map { $0 as SubCategory }
        case .bottom:
            return BottomSubCategory.allCases.map { $0 as SubCategory }
        case .beauty:
            return BeautySubCategory.allCases.map { $0 as SubCategory }
        case .shoes:
            return ShoesSubCategory.allCases.map { $0 as SubCategory }
        case .accessory:
            return AccessorySubCategory.allCases.map { $0 as SubCategory }
        }
    }
}

// 서브 카테고리 프로토콜
protocol SubCategory {
    var displayName: String { get }
    var apiValue: String { get }
}

// 아우터 서브 카테고리
enum OuterSubCategory: String, CaseIterable, SubCategory {
    case padding = "패딩"
    case coat = "코트"
    case mustang = "무스탕"
    case blouson = "블루종"
    case suitBlazer = "슈트/블레이저 재킷"
    
    var displayName: String { rawValue }
    
    var apiValue: String {
        switch self {
        case .padding: return "product_padding"
        case .coat: return "outer_coat"
        case .mustang: return "outer_mustang"
        case .blouson: return "outer_blouson"
        case .suitBlazer: return "outer_suit_blazer"
        }
    }
}

// 상의 서브 카테고리
enum TopSubCategory: String, CaseIterable, SubCategory {
    case sweatshirt = "맨투맨/스웨트"
    case hoodie = "후드"
    case shirt = "셔츠"
    case knit = "니트/스웨터"
    case longSleeve = "긴소매/티셔츠"
    
    var displayName: String { rawValue }
    
    var apiValue: String {
        switch self {
        case .sweatshirt: return "top_sweatshirt"
        case .hoodie: return "top_hoodie"
        case .shirt: return "top_shirt"
        case .knit: return "top_knit"
        case .longSleeve: return "top_long_sleeve"
        }
    }
}

// 하의 서브 카테고리
enum BottomSubCategory: String, CaseIterable, SubCategory {
    case denim = "데님 팬츠"
    case jogger = "트레이닝/조거 팬츠"
    case cotton = "코튼 팬츠"
    case slacks = "슈트 팬츠/슬랙스"
    case shorts = "숏 팬츠"
    
    var displayName: String { rawValue }
    
    var apiValue: String {
        switch self {
        case .denim: return "bottom_denim"
        case .jogger: return "bottom_jogger"
        case .cotton: return "bottom_cotton"
        case .slacks: return "bottom_slacks"
        case .shorts: return "bottom_shorts"
        }
    }
}

// 뷰티 서브 카테고리
enum BeautySubCategory: String, CaseIterable, SubCategory {
    case perfume = "향수"
    case makeup = "메이크업"
    case skincare = "스킨케어"
    case hair = "헤어"
    case body = "바디"
    
    var displayName: String { rawValue }
    
    var apiValue: String {
        switch self {
        case .perfume: return "beauty_perfume"
        case .makeup: return "beauty_makeup"
        case .skincare: return "beauty_skincare"
        case .hair: return "beauty_hair"
        case .body: return "beauty_body"
        }
    }
}

// 신발 서브 카테고리
enum ShoesSubCategory: String, CaseIterable, SubCategory {
    case sneakers = "스니커즈"
    case fur = "패딩/퍼 신발"
    case boots = "부츠/워커"
    case dressShoes = "구두"
    case running = "러닝화"
    
    var displayName: String { rawValue }
    
    var apiValue: String {
        switch self {
        case .sneakers: return "shoes_sneakers"
        case .fur: return "shoes_fur"
        case .boots: return "shoes_boots"
        case .dressShoes: return "shoes_dress"
        case .running: return "shoes_running"
        }
    }
}

// 악세사리 서브 카테고리
enum AccessorySubCategory: String, CaseIterable, SubCategory {
    case hat = "모자"
    case glasses = "안경"
    case watch = "시계"
    
    var displayName: String { rawValue }
    
    var apiValue: String {
        switch self {
        case .hat: return "accessory_hat"
        case .glasses: return "accessory_glasses"
        case .watch: return "accessory_watch"
        }
    }
}
