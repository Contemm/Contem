//
//  StyleTagLabel.swift
//  Contem
//
//  Created by 이상민 on 11/16/25.
//

import SwiftUI

struct StyleTagLabel: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.captionRegular)
            .padding(.horizontal(.spacing8))
            .padding(.vertical(.spacing4))
            .background(.gray50)
            .clipShape(Capsule())
            .shadowLight()
    }
}

#Preview {
    StyleTagLabel(text: "따듯한 패팅")
}
