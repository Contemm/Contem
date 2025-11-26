import SwiftUI

struct PaymentView: View {
    @StateObject private var viewModel: PaymentViewModel
    
    init(coordinator: AppCoordinator) {
        _viewModel = StateObject(wrappedValue: PaymentViewModel(coordinator: coordinator))
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

