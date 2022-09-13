//
//  PersonView.swift
//  Network
//
//  Created by Dylan Elliott on 12/9/2022.
//

import Foundation
import Combine
import SwiftUI

struct DetailView<T: DetailDisplayable & Identifiable>: View {
    @StateObject var viewModel: DetailViewModel<T>
    
    var body: some View {
        List {
            DetailInfoSection(properties: viewModel.properties)
            
            ForEach(Array(viewModel.subSections.enumerated()), id: \.offset) { offset, element in
                DetailSubSection(element: element)
            }
        }
        .navigationTitle(viewModel.object.title)
    }
}
