import SwiftUI
import Combine

protocol CoordinatorProtocol: AnyObject {
    associatedtype Route
    associatedtype SheetRoute
    var navigationPath: NavigationPath { get set }
    
    func push(_ route: Route)
    func pop()
    func popToRoot()
    func present(sheet: SheetRoute)
    func dismissSheet()
}
