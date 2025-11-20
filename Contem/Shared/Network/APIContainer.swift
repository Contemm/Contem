////
////  APIContainer.swift
////  Contem
////
////  Created by HyoTaek on 11/12/25.
////
//
//import Foundation
//
//// MARK: - APIContainerProtocol
//
//protocol APIContainerProtocol {
////    var profileAPI: ProfileAPIProtocol { get }
////    var signInAPI: SignInAPIProtocol { get }
////    var shoppingAPI: ShoppingAPIProtocol { get }
//}
//
//// MARK: - APIContainer
//
///// 앱의 모든 API를 관리하는 Container (Protocol + DI + Lazy 패턴)
/////
///// **사용 예시:**
///// ```swift
///// // ViewFactory에서 사용
///// final class ViewFactory {
/////     private let apiContainer: APIContainerProtocol
/////
/////     init(coordinator: CoordinatorProtocol,
/////          apiContainer: APIContainerProtocol = APIContainer.shared) {
/////         self.apiContainer = apiContainer
/////     }
/////
/////     func makeView(for page: Page) -> some View {
/////         switch page {
/////         case .feed:
/////             FeedView(
/////                 viewModel: FeedViewModel(
/////                     coordinator: coordinator,
/////                     profileAPI: apiContainer.profileAPI
/////                 )
/////             )
/////         }
/////     }
///// }
//final class APIContainer: APIContainerProtocol {
//
//    // MARK: - Singleton
//    
//    static let shared = APIContainer()
//
//    // MARK: - Properties
//
//    /// NetworkLayer (모든 API가 공유)
//    private let networkLayer: NetworkLayerProtocol
//    
//    // MARK: - APIs
//    
//    /// Profile API
////    lazy var profileAPI: ProfileAPIProtocol = {
////        return ProfileAPI(networkLayer: networkLayer)
////    }()
//    
//    /// SignIn API
////    lazy var signInAPI: SignInAPIProtocol = {
////        return SignInAPI(networkLayer: networkLayer)
////    }()
////    
////    /// ShoppingAPI
////    lazy var shoppingAPI: ShoppingAPIProtocol = {
////        return ShoppingAPI(networkLayer: networkLayer)
////    }()
//
//    // MARK: - Init
//    
//    init(networkLayer: NetworkLayerProtocol = NetworkLayer.shared) {
//        self.networkLayer = networkLayer
//    }
//}
