//
//  ListViewModel.swift
//  Network
//
//  Created by Dylan Elliott on 12/9/2022.
//

import Foundation
import Combine
import SwiftUI

protocol ListViewModel: AnyObject {
    associatedtype Data: Codable & Identifiable & RowDisplayable & DetailDisplayable
    associatedtype Content: View
    var unFilteredData: [Data] { get set }
    
    var dataFactory: () -> AnyPublisher<[Data], APIError> { get }
    var display: (Data) -> Content { get }
    
    var cancellables: Bag<CancellableType, AnyCancellable> { get set }
    var loading: Bool { get set }
    
    var title: String { get }
    var searchText: String { get set }
    
    var localSearchEnabled: Bool { get }
    
}

extension ListViewModel {
    var data: [Data] {
        if localSearchEnabled == false || searchText.isEmpty {
            return unFilteredData
        } else {
            return unFilteredData.filter {
                $0.title.searchSanitised.contains(searchText.searchSanitised)
            }
        }
    }
}

extension String {
    var searchSanitised: String {
        self
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
            .lowercased()
    }
}

extension ListViewModel {
    
    func load() {
        loading = true
        
        dataFactory()
            .receive(on: RunLoop.main)
            .sink { completion in
                self.loading = false
                
                switch completion {
                case let .failure(error):
                    print(error)
                case .finished: break
                }
            } receiveValue: { people in
                self.unFilteredData += people
            }
            .store(in: &cancellables, for: .screen)
    }
}
