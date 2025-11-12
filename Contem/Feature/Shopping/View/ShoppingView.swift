import SwiftUI
import Combine

struct ShoppingView: View {
  @ObservedObject private var viewModel: ShoppingTabViewModel
    
  let tabs = TabCategory.allCases
  
  var currentSubCategories: [String] {
    viewModel.output.currentCategory.subCategories.map { $0.displayName }
  }
  
  var bannerItems: [Banner] {
    viewModel.output.banners.isEmpty ? [] : viewModel.output.banners
  }
  
  @State private var currentBannerIndex = 1
  @State private var dragOffset: CGFloat = 0
  
  private var infiniteBanners: [Banner] {
    guard let first = bannerItems.first, let last = bannerItems.last else { return bannerItems }
    return [last] + bannerItems + [first]
  }
  
  var columns: [GridItem] {
    let columnCount: Int
    
    switch viewModel.output.currentCategory {
    case .outer:
      columnCount = 2
    case .top:
      columnCount = 3
    case .bottom:
      columnCount = 2
    case .beauty:
      columnCount = 3
    case .shoes:
      columnCount = 2
    case .accessory:
      columnCount = 3
    }
    
    return Array(repeating: GridItem(.flexible(), spacing: 8), count: columnCount)
  }
  
  init(viewModel: ShoppingTabViewModel) {
    self.viewModel = viewModel
  }
    
  var body: some View {
    VStack(spacing: 0) {
      // 메인 탭 영역
      mainTabBar
      
      Divider()
      
      ScrollView {
        VStack(spacing: 0) {
          Spacer().frame(height: 20)
          
          // 배너 영역
          bannerSection
          
          Spacer().frame(height: 8)
          
          // 상품 그리드 영역
          productSection
        }
      }
    }
    .onAppear {
      viewModel.input.onAppear.send(())
    }
  }
  
  // MARK: - 메인 탭바
  private var mainTabBar: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: 24) {
        ForEach(tabs, id: \.self) { tab in
          mainTabItem(tab)
        }
      }
      .padding(.horizontal, 20)
    }
  }
  
  private func mainTabItem(_ tab: TabCategory) -> some View {
    VStack(spacing: 8) {
      HStack(spacing: 4) {
        Text(tab.rawValue)
          .font(.system(size: 16, weight: viewModel.output.currentCategory == tab ? .semibold : .regular))
          .foregroundColor(viewModel.output.currentCategory == tab ? .black : .gray)
      }
      
      if viewModel.output.currentCategory == tab {
        Rectangle()
          .fill(Color.black)
          .frame(height: 2)
      } else {
        Rectangle()
          .fill(Color.clear)
          .frame(height: 2)
      }
    }
    .onTapGesture {
      viewModel.input.selectMainCategory.send(tab)
    }
  }
  
  // MARK: - 배너 섹션
  private var bannerSection: some View {
    ZStack {
      GeometryReader { geometry in
        bannerScrollView(screenWidth: geometry.size.width)
      }
      .frame(height: UIScreen.main.bounds.width * 0.9)
      
      bannerIndicator
    }
    .frame(maxWidth: .infinity)
  }
  
  private func bannerScrollView(screenWidth: CGFloat) -> some View {
    let cardWidth = screenWidth * 0.90
    let cardHeight = cardWidth
    let spacing: CGFloat = 8
    
    return ScrollViewReader { proxy in
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: spacing) {
          ForEach(Array(infiniteBanners.enumerated()), id: \.offset) { index, banner in
            bannerCard(banner: banner, cardWidth: cardWidth, cardHeight: cardHeight)
              .id(index)
          }
        }
        .padding(.horizontal, (screenWidth - cardWidth) / 2)
        .gesture(
          DragGesture()
            .onChanged { value in
              dragOffset = value.translation.width
            }
            .onEnded { value in
              handleBannerDragEnd(value: value, cardWidth: cardWidth, proxy: proxy)
            }
        )
      }
      .scrollDisabled(true)
      .onAppear {
        proxy.scrollTo(1, anchor: .center)
      }
      .onChange(of: currentBannerIndex) { newValue in
        handleBannerIndexChange(newValue: newValue, proxy: proxy)
      }
    }
  }
  
  private func bannerCard(banner: Banner, cardWidth: CGFloat, cardHeight: CGFloat) -> some View {
    ZStack(alignment: .bottomLeading) {
      Image(banner.thumbnail)
        .resizable()
        .scaledToFill()
        .frame(width: cardWidth, height: cardHeight)
        .clipped()
        .cornerRadius(16)
      
      LinearGradient(
        gradient: Gradient(colors: [Color.black.opacity(0.3), Color.clear]),
        startPoint: .bottom,
        endPoint: .center
      )
      .frame(width: cardWidth, height: cardHeight)
      .cornerRadius(16)
      
      VStack(alignment: .leading, spacing: 6) {
        Text("\(banner.title)\n\(banner.subtitle)")
          .font(.system(size: 24, weight: .bold))
          .foregroundColor(.white)
      }
      .padding(.leading, 20)
      .padding(.bottom, 20)
    }
    .frame(width: cardWidth, height: cardHeight)
  }
  
  private var bannerIndicator: some View {
    VStack {
      Spacer()
      HStack {
        Spacer()
        HStack(spacing: 6) {
          let displayIndex = calculateDisplayIndex()
          
          Text("\(displayIndex) / \(bannerItems.count)")
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(.black)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
        .background(Color.white.opacity(0.8))
        .cornerRadius(16)
      }
      .padding(.trailing, 32)
      .padding(.bottom, 12)
    }
  }
  
  private func calculateDisplayIndex() -> Int {
    if currentBannerIndex == 0 {
      return bannerItems.count
    } else if currentBannerIndex == infiniteBanners.count - 1 {
      return 1
    } else {
      return currentBannerIndex
    }
  }
  
  private func handleBannerDragEnd(value: DragGesture.Value, cardWidth: CGFloat, proxy: ScrollViewProxy) {
    let threshold: CGFloat = cardWidth * 0.25
    var newIndex = currentBannerIndex
    
    if value.translation.width < -threshold {
      if currentBannerIndex < infiniteBanners.count - 1 {
        newIndex = currentBannerIndex + 1
      }
    } else if value.translation.width > threshold {
      if currentBannerIndex > 0 {
        newIndex = currentBannerIndex - 1
      }
    }
    
    dragOffset = 0
    
    withAnimation(.easeInOut(duration: 0.3)) {
      currentBannerIndex = newIndex
      proxy.scrollTo(newIndex, anchor: .center)
    }
  }
  
  private func handleBannerIndexChange(newValue: Int, proxy: ScrollViewProxy) {
    Task {
      try await Task.sleep(for: .milliseconds(250))
      if newValue == 0 && currentBannerIndex == 0 {
        withAnimation(.none) {
          currentBannerIndex = bannerItems.count
          proxy.scrollTo(bannerItems.count, anchor: .center)
        }
      }
      else if newValue == infiniteBanners.count - 1 && currentBannerIndex == infiniteBanners.count - 1 {
        withAnimation(.none) {
          currentBannerIndex = 1
          proxy.scrollTo(1, anchor: .center)
        }
      }
    }
  }
  
  // MARK: - 상품 섹션
  private var productSection: some View {
    LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
      Section {
        Spacer()
          .frame(height: 20)
        
        LazyVGrid(columns: columns, spacing: 20) {
          ForEach(viewModel.output.products) { product in
            ProductCard(product: product)
          }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
      } header: {
        subCategoryHeader
      }
    }
  }
  
  private var subCategoryHeader: some View {
    VStack(spacing: 0) {
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 12) {
          ForEach(currentSubCategories, id: \.self) { category in
            subCategoryItem(category)
          }
        }
        .padding(.horizontal, 20)
      }
      .padding(.vertical, 12)
      .background(Color.white)
      
      Divider()
    }
  }
  
  private func subCategoryItem(_ category: String) -> some View {
    let isSelected = viewModel.output.currentSubCategory.displayName == category
    
    return Text(category)
      .font(.system(size: 14, weight: isSelected ? .semibold : .regular))
      .foregroundColor(isSelected ? .white : .black)
      .padding(.horizontal, 16)
      .padding(.vertical, 8)
      .background(
        Capsule()
          .fill(isSelected ? Color.black : Color.gray.opacity(0.1))
      )
      .onTapGesture {
        if let subCategory = viewModel.output.currentCategory.subCategories.first(where: { $0.displayName == category }) {
          viewModel.input.selectSubCategory.send(subCategory)
        }
      }
  }
}

struct ProductCard: View {
  let product: ShoppingProduct
  @State private var isLiked: Bool = false
  
  var body: some View {
    VStack(alignment: .leading, spacing: 2) {
      productImageSection
      
      productInfoSection
    }
  }
  
  private var productImageSection: some View {
    ZStack(alignment: .bottomTrailing) {
      GeometryReader { geometry in
        Image(product.imageName)
          .resizable()
          .scaledToFill()
          .frame(width: geometry.size.width, height: geometry.size.width)
          .clipped()
      }
      .aspectRatio(1, contentMode: .fit)
      .cornerRadius(12)
      .background(
        Rectangle()
          .fill(Color.gray.opacity(0.15))
          .cornerRadius(12)
      )
      
      likeButton
    }
  }
  
  private var likeButton: some View {
    Button(action: {
      isLiked.toggle()
    }) {
      Image(systemName: isLiked ? "heart.fill" : "heart")
        .font(.system(size: 16))
        .foregroundColor(isLiked ? .red : .white)
        .padding(8)
        .background(
          Circle()
            .fill(Color.clear.opacity(0.5))
            .frame(width: 28, height: 28)
        )
    }
    .padding(8)
  }
  
  private var productInfoSection: some View {
    VStack(alignment: .leading) {
      Text(product.brand)
        .font(.system(size: 13, weight: .semibold))
        .foregroundColor(.black)
      
      Text(product.name)
        .font(.system(size: 12))
        .foregroundColor(.gray)
        .lineLimit(1)
      
      Text("\(product.price.formatted())원")
        .font(.system(size: 14, weight: .bold))
        .foregroundColor(.black)
    }
    .padding(.top, 8)
    .padding(.leading, 8)
  }
}

#Preview {
  ShoppingView()
}
