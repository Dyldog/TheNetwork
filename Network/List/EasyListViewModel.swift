//
//  EasyListViewModel.swift
//  Network
//
//  Created by Dylan Elliott on 12/9/2022.
//

import Foundation
import Combine
import SwiftUI

class SWAPIListViewModel<T: Codable & Identifiable & RowDisplayable & DetailDisplayable>: EasyListViewModel<T, Text> {
    required init(path: String) {
        super.init(
            title: path.capitalized,
            dataFactory: { SWAPI.list(at: path) }
        )
        load()
    }
}

class EasyListViewModel<T: Codable & Identifiable & RowDisplayable & DetailDisplayable, C: View>: ListViewModel, ObservableObject {
    
    var cancellables: Bag<CancellableType, AnyCancellable> = .init()
    @Published var loading: Bool = false
    
    @Published var searchText: String = ""
    var localSearchEnabled: Bool = true
    
    @Published var unFilteredData: [T] = []
    var dataFactory: () -> AnyPublisher<[T], APIError>
    
    let title: String
    
    var display: (T) -> C
    
    init(title: String, dataFactory: @escaping () -> AnyPublisher<[T], APIError>, display: @escaping (T) -> C) {
        self.title = title
        self.dataFactory = dataFactory
        self.display = display
        self.load()
    }
    
    init(title: String, dataFactory: @escaping () -> AnyPublisher<[T], APIError>) where C == Text {
        self.title = title
        self.dataFactory = dataFactory
        self.display = { Text($0.title) }
        self.load()
    }
    
    func apiSearch(_ search: @escaping (String) -> AnyPublisher<[T], APIError>) -> Self {
        localSearchEnabled = false
        
        $searchText
            .throttle(for: 1, scheduler: RunLoop.main, latest: true)
            .sink(receiveValue: {
                self.cancellables.cancel(.requests)
                self.loading = true
                search($0)
                    .receive(on: RunLoop.main)
                    .sink { completion in
                        switch completion {
                        case .failure(let error): print("ERROR: \(error)")
                        default: break
                        }
                        self.loading = false
                    } receiveValue: { [weak self] value in
                        self?.unFilteredData = value
                    }
                    .store(in: &self.cancellables, for: .requests)
        })
        .store(in: &cancellables, for: .screen)
        
        
        return self
    }
}

enum CancellableType {
    case screen
    case requests
}
struct Bag<ID: Hashable, V: Hashable> {
    struct BagItem<ID: Hashable, V: Hashable>: Hashable {
        let id: ID
        let value: V
    }
    
    var set: Set<BagItem<ID, V>> = .init()
    
    func items(of type: ID) -> Set<BagItem<ID, V>> {
        Set(set.filter { $0.id == type })
    }
    func values(of type: ID) -> Set<V> {
        Set(items(of: type).map { $0.value })
    }
    
    mutating func insert(_ value: V, for type: ID) {
        set.insert(.init(id: type, value: value))
    }
}

extension Bag where V == AnyCancellable {
    mutating func cancel(_ type: ID) {
        items(of: type).forEach {
            $0.value.cancel()
            set.remove($0)
        }
        
    }
}

extension AnyCancellable {
    func store<ID: Hashable>(in bag: inout Bag<ID, AnyCancellable>, for type: ID) {
        bag.insert(self, for: type)
    }
}

extension Set where Element == AnyCancellable {
    mutating func cancel() {
        forEach {
            $0.cancel()
        }
        
        removeAll()
    }
}
