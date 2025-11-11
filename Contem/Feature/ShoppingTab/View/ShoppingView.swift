import SwiftUI
import Combine

struct ShoppingTabView: View {
  @StateObject private var viewModel = ShoppingTabViewModel()
  @State private var cancellables = Set<AnyCancellable>()
  
  // Subjects
  private let onAppearTrigger = PassthroughSubject<Void, Never>()
  private let mainCategoryTap = PassthroughSubject<TabCategory, Never>()
  private let subCategoryTap = PassthroughSubject<SubCategory, Never>()
  
  // ViewModel에서 받을 데이터를 저장할 State 추가
  @State private var viewModelBanners: [Banner] = []
  @State private var viewModelProducts: [ShoppingProduct] = []
  
  let tabs = TabCategory.allCases
  @State private var selectedTab: TabCategory = .outer
  
  @State private var selectedSubCategory: String
  
  var currentSubCategories: [String] {
    selectedTab.subCategories.map { $0.displayName }
  }
  
  init() {
    let firstSubCategory = TabCategory.outer.subCategories.first?.displayName ?? ""
    _selectedSubCategory = State(initialValue: firstSubCategory)
  }
  
  // ViewModel 데이터 사용 (banners)
  var bannerItems: [Banner] {
    viewModelBanners.isEmpty ? [] : viewModelBanners
  }
  
  @State private var currentBannerIndex = 1
  @State private var dragOffset: CGFloat = 0
  
  private var infiniteBanners: [Banner] {
    guard let first = bannerItems.first, let last = bannerItems.last else { return bannerItems }
    return [last] + bannerItems + [first]
  }
  
  // ViewModel 데이터 사용 (products)
  var products: [ShoppingProduct] {
    viewModelProducts
  }
  
  var columns: [GridItem] {
    let columnCount: Int
    
    switch selectedTab {
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
  
  var body: some View {
    VStack(spacing: 0) {
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 24) {
          ForEach(tabs, id: \.self) { tab in
            VStack(spacing: 8) {
              HStack(spacing: 4) {
                Text(tab.rawValue)
                  .font(.system(size: 16, weight: selectedTab == tab ? .semibold : .regular))
                  .foregroundColor(selectedTab == tab ? .black : .gray)
              }
              
              if selectedTab == tab {
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
              selectedTab = tab
              selectedSubCategory = tab.subCategories.first?.displayName ?? ""
              
              mainCategoryTap.send(tab)
            }
          }
        }
        .padding(.horizontal, 20)
      }
      
      Divider()
      
      ScrollView {
        VStack(spacing: 0) {
          Spacer().frame(height: 20)
          
          ZStack {
            GeometryReader { geometry in
              let screenWidth = geometry.size.width
              let cardWidth = screenWidth * 0.90
              let cardHeight = cardWidth
              let spacing: CGFloat = 8
              
              ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                  HStack(spacing: spacing) {
                    ForEach(Array(infiniteBanners.enumerated()), id: \.offset) { index, banner in
                      ZStack(alignment: .bottomLeading) {
                        // banner.thumbnail
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
                  )
                }
                .scrollDisabled(true)
                .onAppear {
                  proxy.scrollTo(1, anchor: .center)
                }
                .onChange(of: currentBannerIndex) { newValue in
                  Task {
                    try await Task.sleep(for:. milliseconds(250))
                    if newValue == 0 && currentBannerIndex == 0 {
                      withAnimation(.none) {
                        // --- 수정된 부분 ('banners' -> 'bannerItems') ---
                        currentBannerIndex = bannerItems.count
                        proxy.scrollTo(bannerItems.count, anchor: .center)
                        // --- 수정 종료 ---
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
              }
            }
            .frame(height: UIScreen.main.bounds.width * 0.9)
            
            VStack {
              Spacer()
              HStack {
                Spacer()
                HStack(spacing: 6) {
                  let displayIndex: Int = {
                    if currentBannerIndex == 0 {
                      // --- 수정된 부분 ('banners' -> 'bannerItems') ---
                      return bannerItems.count
                      // --- 수정 종료 ---
                    } else if currentBannerIndex == infiniteBanners.count - 1 {
                      return 1
                    } else {
                      return currentBannerIndex
                    }
                  }()
                  
                  // --- 수정된 부분 ('banners' -> 'bannerItems') ---
                  Text("\(displayIndex) / \(bannerItems.count)")
                  // --- 수정 종료 ---
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
          .frame(maxWidth: .infinity)
          Spacer().frame(height: 8)
          
          LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
            Section {
              Spacer()
                .frame(height: 20)
              
              LazyVGrid(columns: columns, spacing: 20) {
                ForEach(products) { product in
                  ProductCard(product: product)
                }
              }
              .padding(.horizontal, 16)
              .padding(.bottom, 20)
            } header: {
              VStack(spacing: 0) {
                ScrollView(.horizontal, showsIndicators: false) {
                  HStack(spacing: 12) {
                    ForEach(currentSubCategories, id: \.self) { category in
                      Text(category)
                        .font(.system(size: 14, weight: selectedSubCategory == category ? .semibold : .regular))
                        .foregroundColor(selectedSubCategory == category ? .white : .black)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                          Capsule()
                            .fill(selectedSubCategory == category ? Color.black : Color.gray.opacity(0.1))
                        )
                        .onTapGesture {
                          selectedSubCategory = category
                          
                          if let subCategory = selectedTab.subCategories.first(where: { $0.displayName == category }) {
                            subCategoryTap.send(subCategory)
                          }
                        }
                    }
                  }
                  .padding(.horizontal, 20)
                }
                .padding(.vertical, 12)
                .background(Color.white)
                
                Divider()
              }
            }
          }
        }
      }
    }
    .onAppear {
      bind()
      onAppearTrigger.send(())
    }
  }
  
  
  private func bind() {
    let input = ShoppingTabViewModel.Input(
      onAppear: onAppearTrigger.eraseToAnyPublisher(),
      selectMainCategory: mainCategoryTap.eraseToAnyPublisher(),
      selectSubCategory: subCategoryTap.eraseToAnyPublisher()
    )
    let output = viewModel.transform(input: input)
    
    // 배너 바인딩
    output.banners
      .receive(on: DispatchQueue.main)
      .sink { [self] banners in
        print("✅ 배너 수신: \(banners.count)개")
        viewModelBanners = banners
        // 배너가 로드되면 인덱스 초기화
        if !banners.isEmpty && currentBannerIndex == 1 {
          currentBannerIndex = 1
        }
      }
      .store(in: &cancellables)
    
    // 상품 바인딩
    output.products
      .receive(on: DispatchQueue.main)
      .sink { [self] products in
        print("✅ 상품 수신: \(products.count)개")
        viewModelProducts = products
      }
      .store(in: &cancellables)
    
    // 현재 탭 카테고리 바인딩
    output.currentTabCategory
      .receive(on: DispatchQueue.main)
      .sink { [self] tab in
        selectedTab = tab
      }
      .store(in: &cancellables)
    
    // 현재 서브 카테고리 바인딩
    output.currentSubCategory
      .receive(on: DispatchQueue.main)
      .sink { [self] subCategory in
        selectedSubCategory = subCategory.displayName
      }
      .store(in: &cancellables)
  }
}

struct ProductCard: View {
  // --- 수정된 부분 ('Product' -> 'ShoppingProduct') ---
  let product: ShoppingProduct
  // --- 수정 종료 ---
  @State private var isLiked: Bool = false
  
  var body: some View {
    VStack(alignment: .leading, spacing: 2) {
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
}

#Preview {
  ShoppingTabView()
}
