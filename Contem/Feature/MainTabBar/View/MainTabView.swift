//
//  MainTabView.swift
//  Contem
//
//  Created by 이상민 on 11/11/25.
//

import SwiftUI

struct MainTabView: View {
    
    // MARK: - Properties
    
    private let coordinator: CoordinatorProtocol
    
    // MARK: - Init
    
    init(coordinator: CoordinatorProtocol) {
        self.coordinator = coordinator
    }
    
    // MARK: - Body
    
    var body: some View {
        TabView {
            ShoppingView()
                .tabItem {
                    Label("쇼핑", systemImage: "cart")
                }
            FeedView()
                .tabItem {
                    Label("피드", systemImage: "plus.square")
                }
        }
        .tint(.blue)
    }
}

#Preview {
    MainTabView()
}
