import Foundation
import Combine


@MainActor
final class PaymentViewModel: ViewModelType {
    var cancellables = Set<AnyCancellable>()
    private weak var coordinator: AppCoordinator?
    
    var input = Input()
    
    @Published
    var output = Output()
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }
    
    func transform() {
        
    }
}
