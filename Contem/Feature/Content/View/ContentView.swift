//
//  ContentView.swift
//  Contem
//
//  Created by 송재훈 on 11/9/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm: ContentViewModel = ContentViewModel(
        content: Content(image: "globe", text: "Hello, world!")
    )
    
    var body: some View {
        VStack {
            Image(systemName: vm.content.image)
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(vm.content.text)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
