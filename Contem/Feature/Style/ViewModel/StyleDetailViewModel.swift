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
    
    struct Input{
        let appear = PassthroughSubject<Void, Never>()
    }
    
    struct Output{
        var style: StyleEntity?
        var isLoading: Bool = false
        var errorMessage: String?
        var tags: [Int: [StyleTag]] = [:]
    }
    
    private let postId: String
    private weak var coordinator: AppCoordinator?

    init(postId: String, coordinator: AppCoordinator) {
        self.postId = postId
        self.coordinator = coordinator
        transform()
    }

    func transform() {
        input.appear
            .sink { [weak self] _ in
                guard let self else { return }
                Task{
                    await self.fetchStyleDetail()
                }
            }
            .store(in: &cancellables)
    }
    
    //MARK: - Functions
    private func preParseAllTags(entity: StyleEntity) {
        let values = [
            entity.value1,
            entity.value2,
            entity.value3,
            entity.value4,
            entity.value5
        ]

        var dict: [Int: [StyleTag]] = [:]

        for (idx, raw) in values.enumerated(){
            guard let raw else { return }
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
    
    //MARK: - Network
    func fetchStyleDetail() async{
        output.isLoading = true

        Task{
            do{
                let response = try await NetworkService.shared.callRequest(
                    router: PostRequest.post(postId: APIConfig.testPostId), //실제로 넘겨 받은 id로 넣기
                    type: PostDTO.self
                )
                
                let entity = response.toEntity()
                output.style = entity
                preParseAllTags(entity: entity)
            }catch{
                output.errorMessage = error.localizedDescription
            }
            
            output.isLoading = false
        }
    }
}
