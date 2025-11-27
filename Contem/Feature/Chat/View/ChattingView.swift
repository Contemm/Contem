//
//  ChattingView.swift
//  Contem
//
//  Created by 이상민 on 11/27/25.
//

import SwiftUI
import Combine

struct ChattingView: View {
    @ObservedObject private var viewModel: ChattingViewModel
    
    init(viewModel: ChattingViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack{
            ScrollView(.vertical) {
                ForEach(viewModel.output.messages, id: \.id){ msg in
                    Text(msg.content ?? "")
                }
            }
        }
        .onAppear {
            viewModel.input.appear.send(())
        }
    }
}
