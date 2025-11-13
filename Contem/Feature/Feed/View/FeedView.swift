//
//  FeedView.swift
//  Contem
//
//  Created by HyoTaek on 11/11/25.
//

import SwiftUI
import Combine

struct FeedView: View {
    
    // MARK: - ViewModel
    
    @ObservedObject private var viewModel: FeedViewModel

    // MARK: - Init

    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 16) {
            SearchBar()

            HashtagScrollView(items: viewModel.output.hashtagItems)

            Group {
                if viewModel.output.isLoading {
                    ProgressView()
                } else {
                    MasonryLayout(feeds: viewModel.output.feeds)
                }
            }
        }
        .task {
            viewModel.input.viewOnTask.send(())
        }
    }

    // MARK: - Methods

//    private func refresh() async {
//        viewModel.input.refreshTrigger.send(())
//    }
}

// MARK: - SearchBar Component

struct SearchBar: View {
    @State private var searchText = ""

    var body: some View {
        HStack {
            TextField("", text: $searchText, prompt: Text("브랜드, 상품, 프로필, 태그 등")
                .font(.bodyRegular)
                .foregroundColor(.gray300)
            )
            .font(.bodyRegular)
            
            Spacer()
        }
        .padding(.horizontal(16))
        .padding(.vertical(12))
        .background(.gray50)
        .cornerRadiusSmall()
        .padding(.horizontal(16))
    }
}
