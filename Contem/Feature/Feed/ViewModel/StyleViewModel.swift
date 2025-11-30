import SwiftUI
import Combine

final class StyleViewModel: ViewModelType {

    var cancellables = Set<AnyCancellable>()
    
    var input = Input()
    
    @Published var output = Output()
    
    private var coordinator: AppCoordinator
    
    struct Input {
        let viewOnTask = PassthroughSubject<Void, Never>()
        let createStyleTapped = PassthroughSubject<Void, Never>()
        let cardTapped = PassthroughSubject<FeedModel, Never>()
        let loadMoreTrigger = PassthroughSubject<Void, Never>()
    }

    // MARK: - Output

    struct Output {
        var feeds: [FeedModel] = []
        var hashtagItems: [HashtagModel] = []
        var isLoading: Bool = false
        var errorMessage: String? = nil
        var nextCursor: String? = nil
        var canLoadMore: Bool = true
    }

    // MARK: - Init

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
        
        transform()
    }

    // MARK: - Transform

    func transform() {
        input.createStyleTapped
            .withUnretained(self)
            .sink { owner, _ in
                owner.coordinator.push(.createStyle)
            }
            .store(in: &cancellables)
        
        // viewOnTask 이벤트 처리
        input.viewOnTask
            .withUnretained(self)
            .sink { owner, _ in
                Task {
                    await owner.loadFeeds()
                }
            }
            .store(in: &cancellables)

        // CardView 탭
        input.cardTapped
            .withUnretained(self)
            .sink { owner, feed in
                owner.coordinator.push(.styleDetail(postId: feed.postId))
            }
            .store(in: &cancellables)
            
        // 더 많은 피드 로드
        input.loadMoreTrigger
            .withUnretained(self)
            .sink { owner, _ in
                Task {
                    await owner.loadMoreFeeds()
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Methods

extension StyleViewModel {

    // 피드 데이터 로드
    @MainActor
    private func loadFeeds() async {
        output.isLoading = true
        output.feeds = []
        output.nextCursor = nil
        output.canLoadMore = true
        
        do {
            let response = try await NetworkService.shared.callRequest(
                router: PostRequest
                    .postList(limit: "20", category: ["style_feed"]),
                type: PostListDTO.self
            )
            
            output.feeds = response.data.map { post in
                FeedModel(
                    postId: post.postID,
                    thumbnailImages: post.imageURLs,
                    writer: post.creator.nickname,
                    writerImage: post.creator.profileImage,
                    title: post.title,
                    content: post.content,
                    hashTags: post.hashTags,
                    commentCount: post.commentCount
                )
            }
            output.nextCursor = response.nextCursor
            output.canLoadMore = response.nextCursor != "0"
            loadHashtags()
            output.isLoading = false
        } catch {
            output.errorMessage = error.localizedDescription
            output.isLoading = false
        }
    }
    
    // 더 많은 피드 데이터 로드
    @MainActor
    private func loadMoreFeeds() async {
        guard output.canLoadMore, let nextCursor = output.nextCursor else { return }
//        output.isLoading = true
        
        do {
            let response = try await NetworkService.shared.callRequest(router: PostRequest.postList(next: nextCursor, limit: "20", category: ["style_feed"]), type: PostListDTO.self)
            
            let newFeeds = response.data.map { post in
                FeedModel(
                    postId: post.postID,
                    thumbnailImages: post.imageURLs,
                    writer: post.creator.nickname,
                    writerImage: post.creator.profileImage,
                    title: post.title,
                    content: post.content,
                    hashTags: post.hashTags,
                    commentCount: post.commentCount
                )
            }
            output.feeds.append(contentsOf: newFeeds)
            output.nextCursor = response.nextCursor
            output.canLoadMore = response.nextCursor != "0"
            loadHashtags()
//            output.isLoading = false
        } catch {
            output.errorMessage = error.localizedDescription
            output.isLoading = false
        }
    }
    
    // 피드 데이터 새로고침
    @MainActor
    func refreshFeeds() async {
        output.isLoading = true
        output.nextCursor = nil
        output.canLoadMore = true
        
        do {
            let response = try await NetworkService.shared.callRequest(
                router: PostRequest
                    .postList(limit: "20", category: ["style_feed"]),
                type: PostListDTO.self
            )
            
            let newFeeds = response.data.map { post in
                FeedModel(
                    postId: post.postID,
                    thumbnailImages: post.imageURLs,
                    writer: post.creator.nickname,
                    writerImage: post.creator.profileImage,
                    title: post.title,
                    content: post.content,
                    hashTags: post.hashTags,
                    commentCount: post.commentCount
                )
            }
            
            output.feeds = newFeeds
            
            output.nextCursor = response.nextCursor
            output.canLoadMore = response.nextCursor != "0"
            loadHashtags()
            output.isLoading = false
        } catch {
            output.errorMessage = error.localizedDescription
            output.isLoading = false
        }
    }

    // 해시태그 아이템 로드
    private func loadHashtags() {
        var encounteredHashtags: Set<String> = []
        var orderedHashtagModels: [HashtagModel] = []

        for feed in output.feeds {
            for hashtag in feed.hashTags {
                if !encounteredHashtags.contains(hashtag) {
                    encounteredHashtags.insert(hashtag)
                    orderedHashtagModels.append(
                        HashtagModel(
                            imageURL: feed.thumbnailImages.first,
                            hashtag: hashtag
                        )
                    )
                }
            }
        }
        output.hashtagItems = orderedHashtagModels
    }
}
