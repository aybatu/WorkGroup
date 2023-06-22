//
//  ArrayExtensionBinary.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 22/06/2023.
//

import Foundation

extension Array where Element: Comparable {
    func binarySearch(for element: Element) -> Int? {
        var leftIndex = 0
        var rightIndex = self.count - 1
        
        while leftIndex <= rightIndex {
            let middleIndex = (leftIndex + rightIndex) / 2
            let middleElement = self[middleIndex]
            
            if element == middleElement {
                return middleIndex
            } else if element < middleElement {
                rightIndex = middleIndex - 1
            } else {
                leftIndex = middleIndex + 1
            }
        }
        
        return nil
    }
}
