import SwiftUI
import Combine

final class AppCoordinator: CoordinatorProtocol, ObservableObject {

    enum Route: Hashable {
        case tabView
        case signin
        case shopping
        case shoppingDetail
        case style
        case styleDetail
    }
    
    @Published var rootRoute: Route = .signin
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
        case .shoppingDetail:
            let vm = ShoppingDetailViewModel(coordinator: self)
            ShoppingDetailView(viewModel: vm)
        case .style:
            let vm = StyleViewModel(coordinator: self)
            StyleView(viewModel: vm)
        case .styleDetail:
            let vm = StyleDetailViewModel(coordinator: self)
            StyleDetailView(viewModel: vm)
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
}
