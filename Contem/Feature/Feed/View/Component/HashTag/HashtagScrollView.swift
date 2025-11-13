//
//  HashtagScrollView.swift
//  Contem
//
//  Created by HyoTaek on 11/13/25.
//

import SwiftUI

struct HashtagScrollView: View {
    
    // MARK: - Properties
    
    let items: [HashtagModel]

    // MARK: - Body
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(items) { item in
                    HashTagCellView(item: item)
                }
            }
            .padding(.horizontal, 16)
        }
    }
}
