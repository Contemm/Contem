//
//  MainTabView.swift
//  Contem
//
//  Created by 이상민 on 11/11/25.
//

import SwiftUI

struct MainTabView: View {
    
    weak var coordinator: AppCoordinator?
    
    @State private var selectedTab: AppCoordinator.Route = .shopping
    
    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            coordinator?.build(route: .shopping)
                .tabItem {
                    Label("쇼핑", systemImage: "cart")
                }
                .tag(AppCoordinator.Route.shopping)

            coordinator?.build(route: .style)
                .tabItem {
                    Label("피드", systemImage: "plus.square")
                }
                .tag(AppCoordinator.Route.style)
        }
        .tint(.blue)
    }
}
