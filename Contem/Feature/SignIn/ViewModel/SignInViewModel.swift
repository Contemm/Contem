//
//  SignInViewModel.swift
//  Contem
//
//  Created by HyoTaek on 11/13/25.
//

import SwiftUI
import Combine

final class SignInViewModel: ViewModelType {
    
    // MARK: - MVVM
    
    var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published var output = Output()
    
    // MARK: - Dependencies

    private let coordinator: CoordinatorProtocol

    // MARK: - Input

    struct Input {
        
    }

    // MARK: - Output

    struct Output {
        
    }

    // MARK: - Init

    init(coordinator: CoordinatorProtocol) {
        self.coordinator = coordinator
        transform()
    }

    // MARK: - Transform

    func transform() {
        
    }
}
