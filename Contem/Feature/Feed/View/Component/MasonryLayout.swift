//
//  MasonryLayout.swift
//  Contem
//
//  Created by HyoTaek on 11/12/25.
//

import SwiftUI
import Combine

struct MasonryLayout: View {
    
    // MARK: - Properties
    @EnvironmentObject private var viewModel: StyleViewModel
    
    
    // 피드 분배 결과를 미리 계산
    private var distributedFeeds: ([FeedModel], [FeedModel]) {
        distributeFeeds()
    }
    let feeds: [FeedModel]
    let refreshAction: (() async -> Void)?
    
    private let columns = 2
    private let spacing: CGFloat = .spacing8
    private let horizontalPadding: CGFloat = .spacing16

    // MARK: - Init
    
    init(feeds: [FeedModel], refreshAction: (() async -> Void)? = nil) {
        self.feeds = feeds
        self.refreshAction = refreshAction
    }
    
    // MARK: - Body
    
    var body: some View {
        
        GeometryReader { geometry in
            let columnWidth = (geometry.size.width - horizontalPadding * 2 - spacing) / CGFloat(columns)
            let (leftFeeds, rightFeeds) = distributedFeeds
            
            ScrollView {
                HStack(alignment: .top, spacing: spacing) {
                    // 왼쪽 컬럼
                    LazyVStack(spacing: .spacing16) {
                        ForEach(leftFeeds) { feed in
                            let isLiked = feed.likes.contains(viewModel.currentUserId ?? "")
                            FeedCardView(
                                feed: feed,
                                cardWidth: columnWidth,
                                isLiked: isLiked,
                                onLikeTapped: {
                                    viewModel.input.likeButtonTapped.send(feed.postId)
                                }
                            )
                            .onTapGesture {
                                viewModel.input.cardTapped.send(feed)
                            }
                            .onAppear {
                                if feed == feeds.last {
                                    viewModel.input.loadMoreTrigger.send(())
                                }
                            }
                        }
                    }
                    
                    // 오른쪽 컬럼
                    LazyVStack(spacing: .spacing16) {
                        ForEach(rightFeeds) { feed in
                            let isLiked = feed.likes.contains(viewModel.currentUserId ?? "")
                            FeedCardView(
                                feed: feed,
                                cardWidth: columnWidth,
                                isLiked: isLiked,
                                onLikeTapped: {
                                    viewModel.input.likeButtonTapped.send(feed.postId)
                                }
                            )
                            .onTapGesture {
                                viewModel.input.cardTapped.send(feed)
                            }
                            .onAppear {
                                if feed == feeds.last {
                                    viewModel.input.loadMoreTrigger.send(())
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, horizontalPadding)
            }
            .refreshable {
                if let action = refreshAction {
                    await action()
                }
            }
        }
    }
}

// MARK: - Method

extension MasonryLayout {
    
    // 피드를 두 컬럼에 균형있게 분배
    private func distributeFeeds() -> ([FeedModel], [FeedModel]) {
        var leftColumn: [FeedModel] = []
        var rightColumn: [FeedModel] = []

        let sortedFeeds = feeds.sorted { $0.content.count > $1.content.count }

        for (index, feed) in sortedFeeds.enumerated() {
            if index % 2 == 0 {
                leftColumn.append(feed)
            } else {
                rightColumn.append(feed)
            }
        }

        return (leftColumn, rightColumn)
    }
}
