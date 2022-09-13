//
//  String+FirstCapitalized.swift
//  Network
//
//  Created by Dylan Elliott on 12/9/2022.
//

import Foundation

extension String {
    var firstCapitalized: String {
        components(separatedBy: " ").map {
            guard self.isEmpty == false else { return "" }
            return String($0.first!).uppercased() + String($0.dropFirst())
        }
        .joined(separator: " ")
    }
}
