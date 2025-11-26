import SwiftUI
import Combine
import iamport_ios
internal import Then


@MainActor
final class ShoppingDetailViewModel: ViewModelType {

    private weak var coordinator: AppCoordinator?
    
    private let postId: String
    
    private let likeNetworkTrigger = PassthroughSubject<(Bool, String), Never>()
    
    var cancellables = Set<AnyCancellable>()
    
    var input = Input()
    
    @Published var output = Output()

    struct Input {
        let viewDidLoad = PassthroughSubject<Void, Never>()
        let likeButtonTapped = PassthroughSubject<String, Never>()
        let shareButtonTapped = PassthroughSubject<Void, Never>()
        let sizeSelectionTapped = PassthroughSubject<Void, Never>()
        let sizeSelected = PassthroughSubject<String, Never>()
        let purchaseButtonTapped = PassthroughSubject<Void, Never>()
        let followButtonTapped = PassthroughSubject<Void, Never>()
        let backButtonTapped = PassthroughSubject<Void, Never>()
    }

    struct Output {
        var detailInfo: ShoppingDetailInfo?
        var isLoading = false
        var errorMessage: String?
        var isLiked = false
        var isFollowing = false
        var selectedSize: String?
        var showSizeSheet = false
        var showPurchaseAlert = false
        var showShareAlert = false
    }

    init(
        coordinator: AppCoordinator,
        postId: String
    ) {
        self.coordinator = coordinator
        self.postId = postId
        transform()
    }

    func transform() {
        // View Did Load - API 호출
        input.viewDidLoad
            .withUnretained(self)
            .sink { owner, _ in
                owner.fetchDetail()
            }
            .store(in: &cancellables)

        // Like Button
        input.likeButtonTapped
            .sink { [weak self] postId in
                guard let self = self else { return }
                output.isLiked.toggle()
                
                likeNetworkTrigger.send((output.isLiked, postId))
                
            }
            .store(in: &cancellables)
        
        // 좋아요 통신
        likeNetworkTrigger
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] (isLiked, postId) in
                guard let self = self else { return }
                postLike(currentLike: output.isLiked, postId: postId)
            }.store(in: &cancellables)
        

        // Share Button
        input.shareButtonTapped
            .sink { [weak self] in
                guard let self = self else { return }
                output.showShareAlert = true
            }
            .store(in: &cancellables)

        // Size Selection
        input.sizeSelectionTapped
            .sink { [weak self] in
                guard let self = self else { return }
                output.showSizeSheet = true
            }
            .store(in: &cancellables)

        input.sizeSelected
            .sink { [weak self] size in
                guard let self = self else { return }
                output.selectedSize = size
                output.showSizeSheet = false
            }
            .store(in: &cancellables)

        // Purchase Button
        input.purchaseButtonTapped
            .sink { [weak self]  in
                guard let self = self else { return }
                let paymentData = createPaymentData()
                coordinator?.present(sheet: .payment(paymentData: paymentData))
//                self?.output.showPurchaseAlert = true
                
            }
            .store(in: &cancellables)

        // Follow Button
        input.followButtonTapped
            .sink { [weak self] in
                guard let self = self else { return }
                output.isFollowing.toggle()
            }
            .store(in: &cancellables)

        // Back Button - Coordinator 사용
        input.backButtonTapped
            .sink { [weak self] in
                guard let self = self else { return }
                coordinator?.pop()
            }
            .store(in: &cancellables)
    }

    // 상품 상세 정보 불러오기
    private func fetchDetail() {
        output.isLoading = true
        output.errorMessage = nil

        Task { [weak self] in
            guard let self = self else { return }

            do {
                let router = PostRequest.postItem(postId: postId)
                let result = try await NetworkService.shared.callRequest(router: router, type: PostDTO.self)
                let detailInfo = ShoppingDetailInfo(from: result)
                await MainActor.run {
                    self.output.detailInfo = detailInfo
                    self.output.isLiked = detailInfo.isLiked
                    self.output.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.output.errorMessage = error.localizedDescription
                    self.output.isLoading = false
                }
            }
        }
    }
    
    private func postLike(currentLike: Bool, postId: String) {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let router = PostRequest.liked(isLiked: output.isLiked, userId: postId)
                let _ = try await NetworkService.shared.callRequest(router: router, type: PostLikeDTO.self)
            } catch {
                await MainActor.run {
                    self.output.isLiked.toggle()
                }
            }
        }
    }

    // MARK: - Helper Methods

    func closeSizeSheet() {
        output.showSizeSheet = false
    }

    func closePurchaseAlert() {
        output.showPurchaseAlert = false
    }

    func closeShareAlert() {
        output.showShareAlert = false
    }
    
    // 결제 데이터 생성 로직
    private func createPaymentData() -> IamportPayment {
        return IamportPayment(
            pg: PG.html5_inicis.makePgRawName(pgId: "INIpayTest"),
            merchant_uid: "mid_\(Int(Date().timeIntervalSince1970*1000))",
            amount: "100"
        ).then {
            $0.pay_method = PayMethod.card.rawValue
            $0.name = "상품명 예시 옷 입니다"
            $0.buyer_name = "박도원"
            $0.app_scheme = "contem"
        }
    }
}
