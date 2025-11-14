//
//  ContemApp.swift
//  Contem
//
//  Created by 송재훈 on 11/9/25.
//

import SwiftUI

@main
struct ContemApp: App {
    
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            AppCoordinatorView(appState: appState)
        }
    }
}
