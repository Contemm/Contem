import Foundation
import Combine

@MainActor
final class BrandInquireViewModel: ViewModelType {
    private weak var coordinator: AppCoordinator?
    var cancellables = Set<AnyCancellable>()
    
    private let userId: String
    
    var input = Input()

    @Published var output = Output()
    
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    init(
        coordinator: AppCoordinator,
        userId: String
    ) {
        self.coordinator = coordinator
        self.userId = userId
        transform()
    }
    

    func transform() {
        
    }

    
    
}
