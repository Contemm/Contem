import SwiftUI
import Combine

protocol CoordinatorProtocol: AnyObject {
    associatedtype Route
    var navigationPath: NavigationPath { get set }
    
    func push(_ route: Route)
    func pop()
    func popToRoot()
}



struct TestAView: View {
    
    var body: some View {
        Text("A View")
    }
    
}
struct TestBView: View {
    
    var body: some View {
        Text("b View")
    }
    
}
struct TestCView: View {
    
    var body: some View {
        Text("c View")
    }
    
}
struct TestDView: View {
    
    var body: some View {
        Text("d View")
    }
    
}
