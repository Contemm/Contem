//
//  MasonryLayout.swift
//  Contem
//
//  Created by HyoTaek on 11/12/25.
//

import SwiftUI

struct MasonryLayout: View {
    
    // MARK: - Properties
    
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
                    LazyVStack(spacing: .spacing24) {
                        ForEach(leftFeeds) { feed in
                            FeedCardView(
                                feed: feed,
                                cardWidth: columnWidth
                            )
                        }
                    }
                    
                    // 오른쪽 컬럼
                    LazyVStack(spacing: .spacing24) {
                        ForEach(rightFeeds) { feed in
                            FeedCardView(
                                feed: feed,
                                cardWidth: columnWidth
                            )
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
        var leftHeight: CGFloat = .zero
        var rightHeight: CGFloat = .zero

        for feed in feeds {
            // 각 카드의 예상 높이 계산
            let imageHeight = calculateImageHeight(for: feed)
            let cardHeight = imageHeight + 100 // 이미지 + 하단 정보 영역
            
            // 더 짧은 컬럼에 추가
            if leftHeight <= rightHeight {
                leftColumn.append(feed)
                leftHeight += cardHeight + .spacing24 // spacing 포함
            } else {
                rightColumn.append(feed)
                rightHeight += cardHeight + .spacing24 // spacing 포함
            }
        }

        return (leftColumn, rightColumn)
    }

    // 이미지 높이 계산
    private func calculateImageHeight(for feed: FeedModel) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let columnWidth = (screenWidth - horizontalPadding * 2 - spacing) / CGFloat(columns)
        return columnWidth / feed.imageAspectRatio
    }
}
