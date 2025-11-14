//
//  Publisher+Extension.swift
//  Contem
//
//  Created by HyoTaek on 11/12/25.
//

import Combine

extension Publisher {
    /// RxSwift의 withUnretained와 동일한 기능을 제공하는 연산자
    ///
    /// weak reference를 자동으로 처리하며, object가 nil이 되면 스트림에서 해당 이벤트를 무시합니다.
    ///
    /// - Parameter object: weak으로 캡처할 객체 (주로 self)
    /// - Returns: (Object, Output) 튜플을 방출하는 Publisher
    ///
    /// # Example
    /// ```swift
    /// input.viewDidLoad
    ///     .withUnretained(self)
    ///     .sink { owner, _ in
    ///         owner.loadData()
    ///     }
    ///     .store(in: &cancellables)
    /// ```
    
    func withUnretained<Object: AnyObject>(
        _ object: Object
    ) -> Publishers.CompactMap<Self, (Object, Output)> {
        compactMap { [weak object] output in
            guard let object = object else {
                return nil  // object가 해제되면 이벤트 무시
            }
            return (object, output)
        }
    }
}
