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
        Group {
            if viewModel.output.isLoading {
                // TODO: 로딩뷰 추가
            } else {
                MasonryLayout(
                    feeds: viewModel.output.feeds
//                    tapPublisher: viewModel.input.cardTapped
                ) {
                    viewModel.input.refreshTrigger.send(())
                }
            }
        }
        .task {
            viewModel.input.viewOnTask.send(())
        }
    }
}
