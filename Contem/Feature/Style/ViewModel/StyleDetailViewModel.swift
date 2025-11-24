//
//  StyleDetailViewModel.swift
//  Contem
//
//  Created by 이상민 on 11/17/25.
//

import Foundation
import Combine

final class StyleDetailViewModel: ViewModelType{
    
    private weak var coordinator: AppCoordinator?
    
    //MARK: - Properties
    var cancellables = Set<AnyCancellable>()
    
    var input = Input()
    @Published var output: Output = Output()
    
    struct Input{
        let appear = PassthroughSubject<Void, Never>()
        let commentButtonTapped = PassthroughSubject<String, Never>()
    }
    
    struct Output{
        var style: StyleEntity = MockStyle.sample
        var tags: [Int: [StyleTag]] = [:]
    }

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
        transform()
    }

    func transform() {
        input.appear
            .sink { [weak self] _ in
                guard let self else { return }
                self.preParseAllTags()
            }
            .store(in: &cancellables)
        
        input.commentButtonTapped
            .withUnretained(self)
            .sink { owner, postId in
                print("댓글 화면 열기 >> \(postId)")
                owner.coordinator?.present(sheet: .comment(postId: postId))
            }.store(in: &cancellables)
    }
    
    //MARK: - Functions
    private func preParseAllTags() {
        let values = [
            output.style.value1,
            output.style.value2,
            output.style.value3,
            output.style.value4,
            output.style.value5
        ]

        var dict: [Int: [StyleTag]] = [:]

        for (idx, raw) in values.enumerated() {
            dict[idx] = parseTagString(raw)
        }

        output.tags = dict
    }

    // Tag Parser
    func parseTagString(_ raw: String) -> [StyleTag] {
        let parts = raw.split(separator: ":")
        var result: [StyleTag] = []
        
        for part in parts {
            guard let xRange = part.range(of: "x"),
                  let yRange = part.range(of: "y") else { continue }
            
            let xStr = part[xRange.upperBound..<yRange.lowerBound]
            let yStr = part[yRange.upperBound...]
            
            guard let x = Double(xStr),
                  let y = Double(yStr) else { continue }
            
            result.append(StyleTag(relX: CGFloat(x), relY: CGFloat(y)))
        }
        
        return result
    }
}
