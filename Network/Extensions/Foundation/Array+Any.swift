//
//  Arrqy+Any.swift
//  Network
//
//  Created by Dylan Elliott on 13/9/2022.
//

import Foundation

extension Array {
    func any(where checker: (Element) -> Bool) -> Bool {
        guard self.isEmpty == false else { return false }
        
        for value in self {
            if checker(value) == true {
                return true
            }
        }
        
        return false
    }
}
