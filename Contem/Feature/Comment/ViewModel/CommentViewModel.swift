import Foundation
import Combine


@MainActor
final class CommentViewModel: ViewModelType {
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
        transform()
    }
    
    func transform() {
        
    }
}

