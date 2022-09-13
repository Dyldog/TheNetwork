//
//  DetailViewModel.swift
//  Network
//
//  Created by Dylan Elliott on 12/9/2022.
//

import Foundation
import Combine

typealias OutBlock<T> = () -> T

class DetailViewModel<T: DetailDisplayable & Identifiable>: ObservableObject {
    let object: T
    
    @Published var properties: [(DisplayableDetail, DisplayableDetail)] = []
    
    @Published var subSections: [(String, [DetailDisplayable?])] = []
    
    var cancellables: Set<AnyCancellable> = .init()
    @Published var loading: Bool = false
    
    init(object: T) {
        self.object = object
        self.load()
    }
    
    func load() {
        loading = true
        
        object.properties.enumerated().forEach { (index, property) in
            properties.append((.loading, .loading))
            
            property.0.get()
                .receive(on: RunLoop.main)
                .sink(receiveValue: { value in
                    self.properties[index].0 = value
                })
                .store(in: &cancellables)
            
            property.1.get()
                .receive(on: RunLoop.main)
                .sink(receiveValue: { value in
                    self.properties[index].1 = value
                })
                .store(in: &cancellables)
        }
        
        object.subsections.enumerated().forEach { (index, subsection) in
            subSections.append(
                (subsection.0, Array(repeating: nil, count: subsection.1.count))
            )
            
            Publishers.MergeMany(subsection.1.map { subsection.2.publisher(for: $0) })
                .receive(on: RunLoop.main)
                .sink { completion in
                    self.loading = false
                    switch completion {
                    case .finished: break
                    case let .failure(error):
                        print("Error getting \(subsection.0)...")
                        print(error)
                    }
                } receiveValue: { output in
                    guard let idx = self.subSections[index].1.firstIndex(where: { $0 == nil }) else { return }
                    self.subSections[index].1[idx] = output
                }
                .store(in: &cancellables)
        }
        
    }
}
