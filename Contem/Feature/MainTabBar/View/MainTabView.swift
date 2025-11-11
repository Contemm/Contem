//
//  MainTabView.swift
//  Contem
//
//  Created by 이상민 on 11/11/25.
//

import SwiftUI

struct MainTabView: View {
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
