//
//  ShoppingDetailViewModel.swift
//  Contem
//
//  Created by 송재훈 on 11/14/25.
//

import SwiftUI
import Combine

@MainActor
final class ShoppingDetailViewModel: ViewModelType {

    private weak var coordinator: AppCoordinator?
    
    private let postId: String
    
    var cancellables = Set<AnyCancellable>()
    
    var input = Input()
    
    @Published var output = Output()

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
            .sink { [weak self] in
                guard let self = self else { return }
                output.isLiked.toggle()
            }
            .store(in: &cancellables)

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
//                guard let self = self else { return }
//                output.selectedSize = size
//                output.showSizeSheet = false
            }
            .store(in: &cancellables)

        // Purchase Button
        input.purchaseButtonTapped
            .sink { [weak self] in
                self?.output.showPurchaseAlert = true
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

    private func fetchDetail() {
        output.isLoading = true
        output.errorMessage = nil

        Task { [weak self] in
            guard let self = self else { return }

            do {
                let router = PostRequest.postItem(postId: postId)
                let result = try await NetworkService.shared.callRequest(router: router, type: PostDTO.self)
                let detailInfo = ShoppingDetailInfo(from: result)
                print(detailInfo)
                await MainActor.run {
                    self.output.detailInfo = detailInfo
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
}
