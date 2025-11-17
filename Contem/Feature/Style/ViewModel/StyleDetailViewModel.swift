//
//  StyleDetailViewModel.swift
//  Contem
//
//  Created by 이상민 on 11/17/25.
//

import Foundation
import Combine

final class StyleDetailViewModel: ViewModelType{
    
    //MARK: - Properties
    var cancellables = Set<AnyCancellable>()
    
    var input = Input()
    @Published var output: Output = Output()
    
    private var tagsCache: [Int: [StyleTag]] = [:]
    
    struct Input{
        let appear = PassthroughSubject<Void, Never>()
        let changePage = PassthroughSubject<Int, Never>()
    }
    
    struct Output{
        var style: StyleEntity = MockStyle.sample
        var tags: [StyleTag] = []
    }
    
    func transform() {
        input.appear
            .sink { [weak self] _ in
                guard let self else { return }
                self.preParseAllTags()
                self.updateTags(for: 0)
            }
            .store(in: &cancellables)
        
        input.changePage
            .sink { [weak self] newIndex in
                guard let self else { return }
                self.updateTags(for: newIndex)
            }
            .store(in: &cancellables)
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
        
        for (index, raw) in values.enumerated() {
            tagsCache[index] = parseTagString(raw)
        }
    }
    
    private func updateTags(for index: Int) {
        output.tags = tagsCache[index] ?? []
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
