//
//  BinarySearch.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 22/06/2023.
//

import Foundation

class Search<T> where T: Comparable {
    func binarySearch<U: Comparable>(_ array: [T], target: U, keyPath: KeyPath<T, U>) -> T? {
        var left = 0
        var right = array.count - 1
        
        while left <= right {
            let mid = left + (right - left) / 2
            let currentObject = array[mid]
            let currentValue = currentObject[keyPath: keyPath]
            
            if currentValue == target {
                return currentObject
            }
            
            if currentValue < target {
                left = mid + 1
            } else {
                right = mid - 1
            }
        }
        
        return nil
    }
}
