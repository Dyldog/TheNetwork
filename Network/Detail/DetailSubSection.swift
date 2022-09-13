//
//  DetailSubSection.swift
//  Network
//
//  Created by Dylan Elliott on 13/9/2022.
//

import Foundation
import Combine
import SwiftUI

struct DetailSubSection: View {
    let element: (String, [DetailDisplayable?])
    
    var body: some View {
        Section("\(element.0) (\(element.1.count))") {
            ForEach(Array(element.1.compactMap { $0 }), id: \.id) { item in
                NavigationLink(item.title) {
                    item.detailView()
                }
            }
            
            if element.1.any { $0 == nil } {
                ProgressView()
            }
        }
    }
}
