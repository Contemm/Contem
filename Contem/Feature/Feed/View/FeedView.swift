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
        VStack(spacing: .zero) {
            FeedSearchBarView()
                .padding(.bottom, .spacing16)

            Rectangle()
                .fill(.gray100)
                .frame(height: 1)
                .padding(.bottom, .spacing8)

            HashtagScrollView(items: viewModel.output.hashtagItems)
                .padding(.bottom, .spacing16)

            Group {
                if viewModel.output.isLoading {
                    ProgressView()
                } else {
                    MasonryLayout(feeds: viewModel.output.feeds)
                        .environmentObject(viewModel)
                }
            }
        }
        .task {
            viewModel.input.viewOnTask.send(())
        }
    }
}
