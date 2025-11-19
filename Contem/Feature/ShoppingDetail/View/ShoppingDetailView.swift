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

    // MARK: - Initialization

    init(viewModel: ShoppingDetailViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            if viewModel.output.isLoading {
                // 로딩 인디케이터
                ProgressView()
                    .scaleEffect(1.5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let errorMessage = viewModel.output.errorMessage {
                // 에러 메시지
                VStack(spacing: .spacing16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundColor(.red)

                    Text("오류가 발생했습니다")
                        .font(.titleMedium)

                    Text(errorMessage)
                        .font(.bodyRegular)
                        .foregroundColor(.gray500)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, .spacing32)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let detailInfo = viewModel.output.detailInfo {
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
                        .font(.titleSmall)
                        .foregroundColor(.primary100)
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.input.shareButtonTapped.send()
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.titleSmall)
                        .foregroundColor(.primary100)
                }
            }
        }
        .sheet(isPresented: $viewModel.output.showSizeSheet) {
            ShoppingDetailSizeSheet(
                detailInfo: viewModel.output.detailInfo,
                selectedSize: viewModel.output.selectedSize,
                onSizeSelected: { size in
                    viewModel.input.sizeSelected.send(size)
                },
                onDismiss: {
                    viewModel.closeSizeSheet()
                }
            )
        }
        .alert("공유하기", isPresented: $viewModel.output.showShareAlert) {
            Button("확인", role: .cancel) {
                viewModel.closeShareAlert()
            }
        } message: {
            Text("공유 기능은 준비 중입니다")
        }
        .alert("구매하기", isPresented: $viewModel.output.showPurchaseAlert) {
            Button("확인", role: .cancel) {
                viewModel.closePurchaseAlert()
            }
        } message: {
            Text("구매하기 기능은 준비 중입니다")
        }
        .onAppear {
            viewModel.input.viewDidLoad.send()
        }
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
                        .padding(.vertical, .spacing16)

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
                        .padding(.vertical, .spacing24)

                    // Brand Section
                    ShoppingDetailBrandView(
                        brandInfo: detailInfo.creator,
                        isFollowing: viewModel.output.isFollowing,
                        onFollowTapped: {
                            viewModel.input.followButtonTapped.send()
                        }
                    )
                }
                .padding(.bottom, 84)
            }

            // Bottom Action Bar
            ShoppingDetailBottomBar(
                detailInfo: detailInfo,
                isLiked: viewModel.output.isLiked,
                selectedSize: viewModel.output.selectedSize,
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

//#Preview {
//    NavigationStack {
//        ShoppingDetailView(
//            viewModel: ShoppingDetailViewModel(
//                postId: "1",
//                coordinator: MockCoordinator(),
//                shoppingDetailAPI: MockShoppingDetailAPI()
//            )
//        )
//    }
//}
