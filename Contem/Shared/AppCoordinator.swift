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
    
    @Published var rootRoute: Route
    @Published var navigationPath = NavigationPath()
    
    init() {
        
        self.rootRoute = .tabView
//        if hasAccessToken() {
//            self.rootRoute = .tabView
//        } else {
//            self.rootRoute = .signin
//        }
    }
    
    private func hasAccessToken() -> Bool {
        return Bool.random()
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
            let vm = FeedViewModel(coordinator: self)
            FeedView(viewModel: vm)
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
