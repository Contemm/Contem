import SwiftUI
import Combine

final class ItemDetailViewModel: ObservableObject {

    // MARK: - Input
    struct Input {
        let viewDidLoad = PassthroughSubject<Void, Never>()
        let likeButtonTapped = PassthroughSubject<Void, Never>()
        let shareButtonTapped = PassthroughSubject<Void, Never>()
        let sizeSelectionTapped = PassthroughSubject<Void, Never>()
        let sizeSelected = PassthroughSubject<String, Never>()
        let purchaseButtonTapped = PassthroughSubject<Void, Never>()
        let imageSelected = PassthroughSubject<Int, Never>()
        let followButtonTapped = PassthroughSubject<Void, Never>()
        let backButtonTapped = PassthroughSubject<Void, Never>()
    }

    // MARK: - Output
    struct Output {
        let detailInfo: AnyPublisher<DetailInfo, Never>
        let isLiked: AnyPublisher<Bool, Never>
        let isFollowing: AnyPublisher<Bool, Never>
        let selectedSize: AnyPublisher<String?, Never>
        let showSizeSheet: AnyPublisher<Bool, Never>
        let showPurchaseAlert: AnyPublisher<Bool, Never>
        let showShareAlert: AnyPublisher<Bool, Never>
        let showFullScreenImage: AnyPublisher<Bool, Never>
        let selectedImageIndex: AnyPublisher<Int, Never>
        let shouldDismiss: AnyPublisher<Void, Never>
    }

    // MARK: - Properties
    let input = Input()
    let output: Output

    private var cancellables = Set<AnyCancellable>()

    // MARK: - State
    private let detailInfoSubject: CurrentValueSubject<DetailInfo, Never>
    private let isLikedSubject = CurrentValueSubject<Bool, Never>(false)
    private let isFollowingSubject = CurrentValueSubject<Bool, Never>(false)
    private let selectedSizeSubject = CurrentValueSubject<String?, Never>(nil)
    private let showSizeSheetSubject = CurrentValueSubject<Bool, Never>(false)
    private let showPurchaseAlertSubject = CurrentValueSubject<Bool, Never>(false)
    private let showShareAlertSubject = CurrentValueSubject<Bool, Never>(false)
    private let showFullScreenImageSubject = CurrentValueSubject<Bool, Never>(false)
    private let selectedImageIndexSubject = CurrentValueSubject<Int, Never>(0)
    private let shouldDismissSubject = PassthroughSubject<Void, Never>()

    // MARK: - Initialization
    init(detailInfo: DetailInfo) {
        self.detailInfoSubject = CurrentValueSubject<DetailInfo, Never>(detailInfo)

        self.output = Output(
            detailInfo: detailInfoSubject.eraseToAnyPublisher(),
            isLiked: isLikedSubject.eraseToAnyPublisher(),
            isFollowing: isFollowingSubject.eraseToAnyPublisher(),
            selectedSize: selectedSizeSubject.eraseToAnyPublisher(),
            showSizeSheet: showSizeSheetSubject.eraseToAnyPublisher(),
            showPurchaseAlert: showPurchaseAlertSubject.eraseToAnyPublisher(),
            showShareAlert: showShareAlertSubject.eraseToAnyPublisher(),
            showFullScreenImage: showFullScreenImageSubject.eraseToAnyPublisher(),
            selectedImageIndex: selectedImageIndexSubject.eraseToAnyPublisher(),
            shouldDismiss: shouldDismissSubject.eraseToAnyPublisher()
        )

        bind()
    }

    // MARK: - Bind
    private func bind() {
        // Like Button
        input.likeButtonTapped
            .sink { [weak self] in
                guard let self = self else { return }
                self.isLikedSubject.send(!self.isLikedSubject.value)
            }
            .store(in: &cancellables)

        // Share Button
        input.shareButtonTapped
            .sink { [weak self] in
                self?.showShareAlertSubject.send(true)
            }
            .store(in: &cancellables)

        // Size Selection
        input.sizeSelectionTapped
            .sink { [weak self] in
                self?.showSizeSheetSubject.send(true)
            }
            .store(in: &cancellables)

        input.sizeSelected
            .sink { [weak self] size in
                self?.selectedSizeSubject.send(size)
                self?.showSizeSheetSubject.send(false)
            }
            .store(in: &cancellables)

        // Purchase Button
        input.purchaseButtonTapped
            .sink { [weak self] in
                self?.showPurchaseAlertSubject.send(true)
            }
            .store(in: &cancellables)

        // Image Selection
        input.imageSelected
            .sink { [weak self] index in
                self?.selectedImageIndexSubject.send(index)
                self?.showFullScreenImageSubject.send(true)
            }
            .store(in: &cancellables)

        // Follow Button
        input.followButtonTapped
            .sink { [weak self] in
                guard let self = self else { return }
                self.isFollowingSubject.send(!self.isFollowingSubject.value)
            }
            .store(in: &cancellables)

        // Back Button
        input.backButtonTapped
            .sink { [weak self] in
                self?.shouldDismissSubject.send(())
            }
            .store(in: &cancellables)
    }

    // MARK: - Helper Methods
    func closeSizeSheet() {
        showSizeSheetSubject.send(false)
    }

    func closeFullScreenImage() {
        showFullScreenImageSubject.send(false)
    }

    func closePurchaseAlert() {
        showPurchaseAlertSubject.send(false)
    }

    func closeShareAlert() {
        showShareAlertSubject.send(false)
    }
}
