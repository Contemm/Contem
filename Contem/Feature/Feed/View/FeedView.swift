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
            FeedSearchBarView()

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
