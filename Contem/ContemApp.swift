//
//  ContemApp.swift
//  Contem
//
//  Created by 송재훈 on 11/9/25.
//

import SwiftUI

@main
struct ContemApp: App {
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.navigationPath) {
                coordinator.build(route: coordinator.rootRoute)
                    .navigationDestination(for: AppCoordinator.Route.self) { route in
                        coordinator.build(route: route)
                    }
            }
        }
    }
}
