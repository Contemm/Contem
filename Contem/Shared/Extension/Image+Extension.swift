//
//  Image+Extension.swift
//  Contem
//
//  Created by HyoTaek on 11/13/25.
//

import SwiftUI

enum ImageAsset {
    
    // MARK: -  Asset Images
    
    case banner1
    case banner2
    case banner3
    case banner4
    case banner5

    // MARK: - System Images
    
    case rectangleStackFill

    // MARK: - Asset Name
    
    var assetName: String? {
        switch self {
        case .banner1:
            return "banner_1"
        case .banner2:
            return "banner_2"
        case .banner3:
            return "banner_3"
        case .banner4:
            return "banner_4"
        case .banner5:
            return "banner_5"
        case .rectangleStackFill:
            return nil
        }
    }

    // MARK: - System Name
    
    var systemName: String? {
        switch self {
        case .banner1, .banner2, .banner3, .banner4, .banner5:
            return nil
        case .rectangleStackFill:
            return "rectangle.stack.fill"
        }
    }
}

extension Image {
    init(asset: ImageAsset) {
        if let assetName = asset.assetName {
            self.init(assetName)
        } else if let systemName = asset.systemName {
            self.init(systemName: systemName)
        } else {
            // Fallback
            self.init(systemName: "questionmark")
        }
    }
}
