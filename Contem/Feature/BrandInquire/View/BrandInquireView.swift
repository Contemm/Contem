import SwiftUI
import Combine

struct BrandInquireView: View {
    
    @StateObject private var viewModel: BrandInquireViewModel
    
    init(coordinator: AppCoordinator, userId: String) {
        _viewModel = StateObject(
            wrappedValue: BrandInquireViewModel(
                coordinator: coordinator,
                userId: userId
            )
        )
    }
    
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

//#Preview {
//    BrandInquireView()
//}
