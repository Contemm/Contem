//
//  MainTabView.swift
//  Contem
//
//  Created by 이상민 on 11/11/25.
//

import SwiftUI

struct MainTabView: View {
    
    // MARK: - Properties
    
    @State private var selectedTab: Page = .shopping
    private let viewFactory: ViewFactory
    
    // MARK: - Init
    
    init(viewFactory: ViewFactory) {
        self.viewFactory = viewFactory
    }
    
    // MARK: - Body
    
    var body: some View {
        TabView(selection: $selectedTab) {
            viewFactory.makeView(for: .shopping)
                .tabItem {
                    Label("쇼핑", systemImage: "cart")
                }
                .tag(Page.shopping)
            
            viewFactory.makeView(for: .feed)
                .tabItem {
                    Label("피드", systemImage: "plus.square")
                }
                .tag(Page.feed)
        }
        .tint(.blue)
    }
}
