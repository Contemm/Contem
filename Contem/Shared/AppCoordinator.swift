import SwiftUI
import Combine
import iamport_ios

final class AppCoordinator: CoordinatorProtocol, ObservableObject {

    enum Route: Hashable {
        case tabView
        case signin
        case shopping
        case shoppingDetail(id: String)
        case style
        case styleDetail
    }
    
    @Published var rootRoute: Route = .signin
    
    enum SheetRoute: Identifiable {
        case comment(postId: String)
        case payment(paymentData: IamportPayment)
        
        var id: String {
            switch self {
            case .comment(let postId): return "comment-\(postId)"
            case .payment: return "payment"
            }
        }
    }
    
    @Published var sheetRoute: SheetRoute?
    
    @Published var navigationPath = NavigationPath()
    
    func checkToken() async {
        let hasToken = await TokenStorage.shared.hasValidAccessToken()
        rootRoute = hasToken ? .tabView : .signin
    }
    
    @ViewBuilder
    func build(route: Route) -> some View {
        switch route {
        case .tabView:
            MainTabView(coordinator: self)
        case .signin:
            let vm = SignInViewModel(coordinator: self)
            SignInView(viewModel: vm)
        case .shopping:
            let vm = ShoppingViewModel(coordinator: self)
            ShoppingView(viewModel: vm)
        case .shoppingDetail(let postId):
            ShoppingDetailView(coordinator: self, postId: postId)
        case .style:
            let vm = StyleViewModel(coordinator: self)
            StyleView(viewModel: vm)
        case .styleDetail:
            let vm = StyleDetailViewModel(coordinator: self)
            StyleDetailView(viewModel: vm)
        }
    }
    
    @ViewBuilder
    func buildSheet(route: SheetRoute) -> some View {
        switch route {
        case .comment(let postId):
            let vm = CommentViewModel(coordinator: self, postId: postId)
            CommentView(viewModel: vm)
        case .payment(let data):
            PaymentBridge(paymentData: data) { [weak self] response in
                self?.sheetRoute = nil
            }
        }
    }
    
    func login() {
        navigationPath = NavigationPath()
        rootRoute = .tabView
    }
    
    func logout() {
        navigationPath = NavigationPath()
        rootRoute = .signin
        
    }
    
    func push(_ route: Route) {
        navigationPath.append(route)
    }
    
    func pop() {
        navigationPath.removeLast()
    }
    
    func popToRoot() {
        navigationPath.removeLast(navigationPath.count)
    }
    
    func present(sheet: SheetRoute) {
        sheetRoute = sheet
    }
    
    func dismissSheet() {
        self.sheetRoute = nil
    }
}
