//
//  FeedViewModel.swift
//  Contem
//
//  Created by HyoTaek on 11/12/25.
//

import SwiftUI
import Combine

final class FeedViewModel: ViewModelType {

    // MARK: - MVVM

    var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published var output = Output()

    // MARK: - Dependencies

    private let coordinator: CoordinatorProtocol

    // MARK: - Input

    struct Input {
        let viewOnTask = PassthroughSubject<Void, Never>()
        let refreshTrigger = PassthroughSubject<Void, Never>()
        let cardTapped = PassthroughSubject<FeedModel, Never>()
    }

    // MARK: - Output

    struct Output {
        var feeds: [FeedModel] = []
        var hashtagItems: [HashtagModel] = []
        var isLoading: Bool = false
        var errorMessage: String? = nil
    }

    // MARK: - Init

    init(coordinator: CoordinatorProtocol) {
        self.coordinator = coordinator
        
        transform()
    }

    // MARK: - Transform

    func transform() {

        // viewOnTask 이벤트 처리
        input.viewOnTask
            .withUnretained(self)
            .sink { owner, _ in
                owner.loadFeeds()
                owner.loadHashtags()
            }
            .store(in: &cancellables)

//        // 피드 새로고침
//        input.refreshTrigger
//            .withUnretained(self)
//            .sink { owner, _ in
//                owner.refreshFeeds()
//            }
//            .store(in: &cancellables)

        // CardView 탭
        input.cardTapped
            .withUnretained(self)
            .sink { owner, feed in
//                owner.coordinator.push(.feedDetail(feed))
            }
            .store(in: &cancellables)
    }
}

// MARK: - Methods

extension FeedViewModel {

    // 더미 데이터 로드
    private func loadFeeds() {
        output.isLoading = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }

            self.output.feeds = FeedModel.dummyData
            self.output.isLoading = false
        }
    }

    // 해시태그 아이템 로드
    private func loadHashtags() {
        let feeds = FeedModel.dummyData.prefix(8)

        output.hashtagItems = feeds.map { feed in
            HashtagModel(
                imageName: feed.thumbnailImages.first ?? "",
                hashtag: feed.hashTags.first ?? "#패션"
            )
        }
    }

    // TODO: 새로고침 기능 추가
    
//    // 새로고침
//    private func refreshFeeds() {
//        output.isLoading = true
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
//            guard let self = self else { return }
//
//            self.output.feeds = FeedModel.dummyData
//            self.output.isLoading = false
//        }
//    }
}
