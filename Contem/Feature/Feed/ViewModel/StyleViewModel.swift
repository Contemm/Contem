import SwiftUI
import Combine

final class StyleViewModel: ViewModelType {

    var cancellables = Set<AnyCancellable>()
    
    var input = Input()
    
    @Published var output = Output()
    @Published var currentUserId: String? //캐싱된 UserID
    
    private var coordinator: AppCoordinator
    private let networkLikeTrigger = PassthroughSubject<(String, Bool), Never>() //디바운싱용 Subject
    
    struct Input {
        let viewOnTask = PassthroughSubject<Void, Never>()
        let createStyleTapped = PassthroughSubject<Void, Never>()
        let cardTapped = PassthroughSubject<FeedModel, Never>()
        let loadMoreTrigger = PassthroughSubject<Void, Never>()
        let likeButtonTapped = PassthroughSubject<String, Never>()
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
        Task {
            self.currentUserId = await TokenStorage.shared.getUserId()
        }
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
            
        input.likeButtonTapped
            .sink { [weak self] postId in
                guard let self = self else { return }
                
                let isLiked = !(self.output.feeds.first { $0.postId == postId }?.likes.contains(self.currentUserId ?? "") ?? false)
                self.handleOptimisticLike(postId: postId)
                self.networkLikeTrigger.send((postId, isLiked))
            }
            .store(in: &cancellables)
            
        networkLikeTrigger
            .debounce(for: .seconds(0.3), scheduler: RunLoop.main)
            .sink { [weak self] (postId, isLiked) in
                guard let self = self else { return }
                
                Task {
                    await self.postLikeToServer(postId: postId, isLiked: isLiked)
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Methods

extension StyleViewModel {
    
    //좋아요 UI 즉시 업데이트(낙관적 업데이트)
    private func handleOptimisticLike(postId: String){
        guard let userId = currentUserId else {
            output.errorMessage = "로그인 후 이용 가능합니다."
            return
        }
        
        if let index = output.feeds.firstIndex(where: { $0.postId == postId }) {
            output.feeds[index].toggleLike(userId: userId)
        }
    }

    //롤백 함수
    private func rollbackLikeState(postId: String){
        guard let userId = currentUserId else { return }
        if let index = output.feeds.firstIndex(where: { $0.postId == postId }) {
            output.feeds[index].toggleLike(userId: userId)
        }
    }

    //좋아요 서버 요청
    private func postLikeToServer(postId: String, isLiked: Bool) async{
        do{
            _ = try await NetworkService.shared.callRequest(router: PostRequest.like(postId: postId, isLiked: isLiked), type: PostLikeDTO.self)
        }catch let error as NetworkError{
            self.rollbackLikeState(postId: postId)
            
            if case .statusCodeError(let type) = error {
                if type == .refreshTokenExpired() || type == .forbidden() || type == .unauthorized(){
                    currentUserId = nil
                }
            }
            
            output.errorMessage = error.errorDescription
        }catch{
            self.rollbackLikeState(postId: postId)
            output.errorMessage = NetworkError.unknown(error).errorDescription
        }
    }

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
                    commentCount: post.commentCount,
                    likes: post.likes
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
                    commentCount: post.commentCount,
                    likes: post.likes
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
                    commentCount: post.commentCount,
                    likes: post.likes
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
