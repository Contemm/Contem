//
//  ContentViewModel.swift
//  Contem
//
//  Created by 송재훈 on 11/9/25.
//

import SwiftUI
import Combine

class ContentViewModel: ObservableObject {
    @Published var content: Content
    
    init(content: Content) {
        self.content = content
    }
}
