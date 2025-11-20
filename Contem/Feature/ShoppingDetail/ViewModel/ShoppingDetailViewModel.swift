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

    // MARK: - MVVM
    private weak var coordinator: AppCoordinator?
    
    var cancellables = Set<AnyCancellable>()
    
    var input = Input()
    
    @Published var output = Output()

    // MARK: - Dependencies

//    private let coordinator: CoordinatorProtocol
//    private let shoppingDetailAPI: ShoppingDetailAPIProtocol
//    private let postId: String

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

    // MARK: - Initialization

    init(
        coordinator: AppCoordinator
//        postId: String,
////        coordinator: CoordinatorProtocol,
//        shoppingDetailAPI: ShoppingDetailAPIProtocol = ShoppingDetailAPI()
    ) {
        self.coordinator = coordinator
//        self.postId = postId
////        self.coordinator = coordinator
//        self.shoppingDetailAPI = shoppingDetailAPI

        transform()
    }

    // MARK: - Transform

    func transform() {
        // View Did Load - API 호출
        input.viewDidLoad
            .sink { [weak self] in
//                self?.fetchDetail()
            }
            .store(in: &cancellables)

        // Like Button
        input.likeButtonTapped
            .sink { [weak self] in
//                guard let self = self else { return }
//                self.output.isLiked.toggle()
            }
            .store(in: &cancellables)

        // Share Button
        input.shareButtonTapped
            .sink { [weak self] in
//                self?.output.showShareAlert = true
            }
            .store(in: &cancellables)

        // Size Selection
        input.sizeSelectionTapped
            .sink { [weak self] in
//                self?.output.showSizeSheet = true
            }
            .store(in: &cancellables)

        input.sizeSelected
            .sink { [weak self] size in
//                self?.output.selectedSize = size
//                self?.output.showSizeSheet = false
            }
            .store(in: &cancellables)

        // Purchase Button
        input.purchaseButtonTapped
            .sink { [weak self] in
//                self?.output.showPurchaseAlert = true
            }
            .store(in: &cancellables)

        // Follow Button
        input.followButtonTapped
            .sink { [weak self] in
//                guard let self = self else { return }
//                self.output.isFollowing.toggle()
            }
            .store(in: &cancellables)

        // Back Button - Coordinator 사용
        input.backButtonTapped
            .sink { [weak self] in
                self?.coordinator?.pop()
//                self?.coordinator.pop()
            }
            .store(in: &cancellables)
    }

    // MARK: - API Methods

    private func fetchDetail() {
//        output.isLoading = true
//        output.errorMessage = nil

//        Task { [weak self] in
//            guard let self = self else { return }
//
//            do {
////                let detailInfo = try await self.shoppingDetailAPI.fetchDetail(postId: self.postId)
////                await MainActor.run {
////                    self.output.detailInfo = detailInfo
////                    self.output.isLoading = false
////                }
//            } catch {
////                await MainActor.run {
////                    self.output.errorMessage = error.localizedDescription
////                    self.output.isLoading = false
////                }
//            }
//        }
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
