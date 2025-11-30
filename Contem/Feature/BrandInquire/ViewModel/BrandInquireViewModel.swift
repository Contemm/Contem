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
        let dismissButtonTapped = PassthroughSubject<Void, Never>()
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
        input.dismissButtonTapped
            .sink { [weak self] _ in
                guard let self = self else { return }
                coordinator?.dismissFullScreen()
            }.store(in: &cancellables)
    }

    
    
}
