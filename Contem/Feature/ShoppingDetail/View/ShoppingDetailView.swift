//
//  ShoppingDetailView.swift
//  Contem
//
//  Created by 송재훈 on 11/14/25.
//

import SwiftUI
import Combine

struct ShoppingDetailView: View {

    // MARK: - ViewModel

    @ObservedObject private var viewModel: ShoppingDetailViewModel

    // MARK: - Properties

    @State private var detailInfo: ShoppingDetailInfo?
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var isLiked = false
    @State private var isFollowing = false
    @State private var selectedSize: String?
    @State private var showSizeSheet = false
    @State private var showPurchaseAlert = false
    @State private var showShareAlert = false

    // MARK: - Initialization

    init(viewModel: ShoppingDetailViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            if isLoading {
                // 로딩 인디케이터
                ProgressView()
                    .scaleEffect(1.5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let errorMessage = errorMessage {
                // 에러 메시지
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 50))
                        .foregroundColor(.red)

                    Text("오류가 발생했습니다")
                        .font(.system(size: 18, weight: .bold))

                    Text(errorMessage)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let detailInfo = detailInfo {
                // 데이터 로드 성공
                contentView(detailInfo: detailInfo)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    viewModel.input.backButtonTapped.send()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.input.shareButtonTapped.send()
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 18))
                        .foregroundColor(.black)
                }
            }
        }
        .sheet(isPresented: $showSizeSheet) {
            ShoppingDetailSizeSheet(
                detailInfo: detailInfo,
                selectedSize: selectedSize,
                onSizeSelected: { size in
                    viewModel.input.sizeSelected.send(size)
                },
                onDismiss: {
                    viewModel.closeSizeSheet()
                }
            )
        }
        .alert("공유하기", isPresented: $showShareAlert) {
            Button("확인", role: .cancel) {
                viewModel.closeShareAlert()
            }
        } message: {
            Text("공유 기능은 준비 중입니다")
        }
        .alert("구매하기", isPresented: $showPurchaseAlert) {
            Button("확인", role: .cancel) {
                viewModel.closePurchaseAlert()
            }
        } message: {
            Text("구매하기 기능은 준비 중입니다")
        }
        .onAppear {
            viewModel.input.viewDidLoad.send()
        }
        .onReceive(viewModel.output.detailInfo) { detailInfo = $0 }
        .onReceive(viewModel.output.isLoading) { isLoading = $0 }
        .onReceive(viewModel.output.errorMessage) { errorMessage = $0 }
        .onReceive(viewModel.output.isLiked) { isLiked = $0 }
        .onReceive(viewModel.output.isFollowing) { isFollowing = $0 }
        .onReceive(viewModel.output.selectedSize) { selectedSize = $0 }
        .onReceive(viewModel.output.showSizeSheet) { showSizeSheet = $0 }
        .onReceive(viewModel.output.showPurchaseAlert) { showPurchaseAlert = $0 }
        .onReceive(viewModel.output.showShareAlert) { showShareAlert = $0 }
    }

    // MARK: - UI Components

    @ViewBuilder
    private func contentView(detailInfo: ShoppingDetailInfo) -> some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: 0) {
                    // Image Carousel
                    ImageCarouselView(imageNames: detailInfo.contentImages)

                    // Price Info
                    ShoppingDetailPriceView(detailInfo: detailInfo)

                    Divider()
                        .padding(.vertical, 16)

                    // Accordion Sections (간소화 버전)
                    VStack(spacing: 0) {
                        AccordionItemView(
                            title: "상품 정보",
                            content: detailInfo.value2.isEmpty ? "상품 정보가 없습니다" : detailInfo.value2
                        )

                        AccordionItemView(
                            title: "배송 정보",
                            content: "배송비: 무료배송\n배송기간: 2-3일 소요"
                        )

                        AccordionItemView(
                            title: "교환/반품 안내",
                            content: "교환 및 반품은 상품 수령 후 7일 이내 가능합니다."
                        )
                    }

                    Divider()
                        .padding(.vertical, 24)

                    // Brand Section
                    ShoppingDetailBrandView(
                        brandInfo: detailInfo.creator,
                        isFollowing: isFollowing,
                        onFollowTapped: {
                            viewModel.input.followButtonTapped.send()
                        }
                    )
                }
                .padding(.bottom, 80)
            }

            // Bottom Action Bar
            ShoppingDetailBottomBar(
                detailInfo: detailInfo,
                isLiked: isLiked,
                selectedSize: selectedSize,
                onLikeTapped: {
                    viewModel.input.likeButtonTapped.send()
                },
                onShareTapped: {
                    viewModel.input.shareButtonTapped.send()
                },
                onSizeSelectionTapped: {
                    viewModel.input.sizeSelectionTapped.send()
                },
                onPurchaseTapped: {
                    viewModel.input.purchaseButtonTapped.send()
                }
            )
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ShoppingDetailView(
            viewModel: ShoppingDetailViewModel(
                postId: "sample_post_001",
                coordinator: MockCoordinator()
            )
        )
    }
}
