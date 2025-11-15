//
//  ShoppingDetailViewModel.swift
//  Contem
//
//  Created by 송재훈 on 11/14/25.
//

import SwiftUI
import Combine

final class ShoppingDetailViewModel: ObservableObject {

    // MARK: - Input
    struct Input {
        let viewDidLoad = PassthroughSubject<Void, Never>()
        let likeButtonTapped = PassthroughSubject<Void, Never>()
        let shareButtonTapped = PassthroughSubject<Void, Never>()
        let sizeSelectionTapped = PassthroughSubject<Void, Never>()
        let sizeSelected = PassthroughSubject<String, Never>()
        let purchaseButtonTapped = PassthroughSubject<Void, Never>()
        let followButtonTapped = PassthroughSubject<Void, Never>()
        let backButtonTapped = PassthroughSubject<Void, Never>()
    }

    // MARK: - Output
    struct Output {
        let detailInfo: AnyPublisher<ShoppingDetailInfo?, Never>
        let isLoading: AnyPublisher<Bool, Never>
        let errorMessage: AnyPublisher<String?, Never>
        let isLiked: AnyPublisher<Bool, Never>
        let isFollowing: AnyPublisher<Bool, Never>
        let selectedSize: AnyPublisher<String?, Never>
        let showSizeSheet: AnyPublisher<Bool, Never>
        let showPurchaseAlert: AnyPublisher<Bool, Never>
        let showShareAlert: AnyPublisher<Bool, Never>
    }

    // MARK: - Properties
    let input = Input()
    let output: Output

    private var cancellables = Set<AnyCancellable>()

    // MARK: - State
    private let detailInfoSubject = CurrentValueSubject<ShoppingDetailInfo?, Never>(nil)
    private let isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    private let errorMessageSubject = CurrentValueSubject<String?, Never>(nil)
    private let isLikedSubject = CurrentValueSubject<Bool, Never>(false)
    private let isFollowingSubject = CurrentValueSubject<Bool, Never>(false)
    private let selectedSizeSubject = CurrentValueSubject<String?, Never>(nil)
    private let showSizeSheetSubject = CurrentValueSubject<Bool, Never>(false)
    private let showPurchaseAlertSubject = CurrentValueSubject<Bool, Never>(false)
    private let showShareAlertSubject = CurrentValueSubject<Bool, Never>(false)

    // MARK: - Dependencies
    private let coordinator: CoordinatorProtocol
    private let shoppingDetailAPI: ShoppingDetailAPIProtocol
    private let postId: String

    // MARK: - Initialization
    init(
        postId: String,
        coordinator: CoordinatorProtocol,
        shoppingDetailAPI: ShoppingDetailAPIProtocol = ShoppingDetailAPI()
    ) {
        self.postId = postId
        self.coordinator = coordinator
        self.shoppingDetailAPI = shoppingDetailAPI

        self.output = Output(
            detailInfo: detailInfoSubject.eraseToAnyPublisher(),
            isLoading: isLoadingSubject.eraseToAnyPublisher(),
            errorMessage: errorMessageSubject.eraseToAnyPublisher(),
            isLiked: isLikedSubject.eraseToAnyPublisher(),
            isFollowing: isFollowingSubject.eraseToAnyPublisher(),
            selectedSize: selectedSizeSubject.eraseToAnyPublisher(),
            showSizeSheet: showSizeSheetSubject.eraseToAnyPublisher(),
            showPurchaseAlert: showPurchaseAlertSubject.eraseToAnyPublisher(),
            showShareAlert: showShareAlertSubject.eraseToAnyPublisher()
        )

        bind()
    }

    // MARK: - Bind
    private func bind() {
        // View Did Load - API 호출
        input.viewDidLoad
            .sink { [weak self] in
                self?.fetchDetail()
            }
            .store(in: &cancellables)

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

        // Follow Button
        input.followButtonTapped
            .sink { [weak self] in
                guard let self = self else { return }
                self.isFollowingSubject.send(!self.isFollowingSubject.value)
            }
            .store(in: &cancellables)

        // Back Button - Coordinator 사용
        input.backButtonTapped
            .sink { [weak self] in
                self?.coordinator.pop()
            }
            .store(in: &cancellables)
    }

    // MARK: - API Methods
    private func fetchDetail() {
        isLoadingSubject.send(true)
        errorMessageSubject.send(nil)

        Task { [weak self] in
            guard let self = self else { return }

            do {
                let detailInfo = try await self.shoppingDetailAPI.fetchDetail(postId: self.postId)
                await MainActor.run {
                    self.detailInfoSubject.send(detailInfo)
                    self.isLoadingSubject.send(false)
                }
            } catch {
                await MainActor.run {
                    self.errorMessageSubject.send(error.localizedDescription)
                    self.isLoadingSubject.send(false)
                }
            }
        }
    }

    // MARK: - Helper Methods
    func closeSizeSheet() {
        showSizeSheetSubject.send(false)
    }

    func closePurchaseAlert() {
        showPurchaseAlertSubject.send(false)
    }

    func closeShareAlert() {
        showShareAlertSubject.send(false)
    }
}
