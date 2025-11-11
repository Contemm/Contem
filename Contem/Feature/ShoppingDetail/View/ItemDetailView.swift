import SwiftUI
import Combine

struct MVVMItemDetailView: View {
    @StateObject private var viewModel: ItemDetailViewModel
    @Environment(\.dismiss) private var dismiss

    // Local state for bindings
    @State private var detailInfo: DetailInfo
    @State private var isLiked = false
    @State private var isFollowing = false
    @State private var selectedSize: String?
    @State private var showSizeSheet = false
    @State private var showPurchaseAlert = false
    @State private var showShareAlert = false
    @State private var showFullScreenImage = false
    @State private var selectedImageIndex = 0

    init(detailInfo: DetailInfo) {
        _detailInfo = State(initialValue: detailInfo)
        _viewModel = StateObject(wrappedValue: ItemDetailViewModel(detailInfo: detailInfo))
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: 0) {
                    // Image Carousel
                    ImageCarouselView(imageNames: detailInfo.contentImages) { index in
                        viewModel.input.imageSelected.send(index)
                    }

                    // Price Info
                    ItemDetailPriceInfoView(detailInfo: detailInfo)

                    Divider()
                        .padding(.vertical, 16)

                    // Accordion Sections
                    VStack(spacing: 0) {
                        AccordionItemView(title: "배송정보") {
                            ShippingInfoView()
                        }

                        AccordionItemView(title: "교환/환불") {
                            ReturnPolicyView()
                        }

                        AccordionItemView(title: "상품정보") {
                            APIProductDetailView(
                                productDetail: ProductDetailParser.parse(detailInfo.value2),
                                category: detailInfo.category
                            )
                        }

                        AccordionItemView(title: "사이즈 가이드") {
                            APISizeGuideView(sizeInfos: SizeInfoParser.parse(detailInfo.value3))
                        }
                    }

                    Divider()
                        .padding(.vertical, 24)

                    // Detail Images
                    VStack(alignment: .leading, spacing: 16) {
                        Text("상세 설명")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)

                        DetailFilesView(files: detailInfo.files)
                    }

                    Divider()
                        .padding(.vertical, 24)

                    // Brand Section
                    ItemDetailBrandSectionView(
                        creator: detailInfo.creator,
                        isFollowing: isFollowing,
                        onFollowTapped: {
                            viewModel.input.followButtonTapped.send()
                        }
                    )
                }
                .padding(.bottom, 80)
            }

            // Bottom Action Bar
            ItemDetailBottomActionBar(
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
            ItemDetailSizeSelectionSheet(
                sizeInfos: SizeInfoParser.parse(detailInfo.value3),
                selectedSize: selectedSize,
                onSizeSelected: { size in
                    viewModel.input.sizeSelected.send(size)
                },
                onDismiss: {
                    viewModel.closeSizeSheet()
                }
            )
        }
        .fullScreenCover(isPresented: $showFullScreenImage) {
            FullScreenImageViewer(
                imageNames: detailInfo.contentImages,
                isPresented: $showFullScreenImage,
                currentIndex: selectedImageIndex
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
        .onReceive(viewModel.output.isLiked) { isLiked = $0 }
        .onReceive(viewModel.output.isFollowing) { isFollowing = $0 }
        .onReceive(viewModel.output.selectedSize) { selectedSize = $0 }
        .onReceive(viewModel.output.showSizeSheet) { showSizeSheet = $0 }
        .onReceive(viewModel.output.showPurchaseAlert) { showPurchaseAlert = $0 }
        .onReceive(viewModel.output.showShareAlert) { showShareAlert = $0 }
        .onReceive(viewModel.output.showFullScreenImage) { showFullScreenImage = $0 }
        .onReceive(viewModel.output.selectedImageIndex) { selectedImageIndex = $0 }
        .onReceive(viewModel.output.shouldDismiss) { _ in dismiss() }
    }
}

#Preview {
    NavigationStack {
        MVVMItemDetailView(detailInfo: DetailInfo.sample)
    }
}
