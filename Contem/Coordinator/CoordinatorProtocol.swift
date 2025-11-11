//
//  CoordinatorProtocol.swift
//  Contem
//
//  Created by HyoTaek on 11/11/25.
//

import SwiftUI

@MainActor
protocol CoordinatorProtocol: AnyObject {
    
    var path: NavigationPath { get set }
    var sheet: Page? { get set }
    var fullScreenCover: Page? { get set }
}
