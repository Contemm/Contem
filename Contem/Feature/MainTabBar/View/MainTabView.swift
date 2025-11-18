//
//  MainTabView.swift
//  Contem
//
//  Created by 이상민 on 11/11/25.
//

import SwiftUI

struct MainTabView: View {
    
    // MARK: - Properties
    
//    @State private var selectedTab: Page = .shopping
    
//    private let viewFactory: ViewFactory
    
    @State private var selectedTab: AppCoordinator.Route = .shopping
    
    private weak var coordinator: AppCoordinator?
    
    // MARK: - Init
    
    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }
    
//    init(viewFactory: ViewFactory) {
//        self.viewFactory = viewFactory
//    }
    
    // MARK: - Body
    
    var body: some View {
        TabView(selection: $selectedTab) {
            coordinator?.build(route: .shopping)
                .tabItem {
                    Label("쇼핑", systemImage: "cart")
                }
                .tag("shopping")

            coordinator?.build(route: .style)
                .tabItem {
                    Label("피드", systemImage: "plus.square")
                }
                .tag("feed")
        }
        .tint(.blue)
    }
}
