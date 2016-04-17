//
//  DiffableArray.swift
//  DiffableArray
//
//  Created by Safx Developer on 2015/01/09.
//  Copyright (c) 2015 Safx Developers. All rights reserved.
//

import Foundation


public struct ArrayDiff<T> {
    public let added: [T]
    public let removed: [T]
    public let modified: [T]
}

public class ArrayDiffer<T: Equatable>{
    public let oldValue: [T]
    public let newValue: [T]
    
    public init(oldValue: [T], newValue: [T]) {
        self.oldValue = oldValue
        self.newValue = newValue
    }
    
    public func diff() -> ArrayDiff<Int> {
        return ArrayDiffer.LCSDiff(oldValue: oldValue, newValue: newValue) { $0 }
    }
    public func diffAsIndexPath() -> ArrayDiff<NSIndexPath> {
        #if os(iOS)
            return ArrayDiffer.LCSDiff(oldValue: oldValue, newValue: newValue) { NSIndexPath(forRow: $0, inSection: 0) }
        #else
            return ArrayDiffer.LCSDiff(oldValue: oldValue, newValue: newValue) { NSIndexPath(index: $0) }
        #endif
    }
}

public class DiffableArray<T: Equatable> {
    public typealias ChangeHandler = ArrayDiffer<T> -> ()
    
    private let changeHandler: ChangeHandler
    
    public var value: [T] {
        willSet {
            changeHandler(ArrayDiffer(oldValue: self.value, newValue: newValue))
        }
    }
    
    public var count: Int {
        return value.count
    }
    
    public subscript(index: Int) -> T {
        return value[index]
    }
    
    public init(initialValue: [T] = [], changeHandler: ChangeHandler) {
        self.changeHandler = changeHandler
        value = initialValue
    }
}


public class FilterableArray<T: Equatable> {
    public typealias FilterFunction = ((T) -> Bool)
    
    public var value: [T] = [] {
        didSet { updateFilteredData() }
    }
    
    public var filterFunction: FilterFunction? = nil {
        didSet { updateFilteredData() }
    }
    
    private var _filteredData: DiffableArray<T>
    
    public var filteredValue: [T] {
        return _filteredData.value
    }
    
    public var count: Int {
        return _filteredData.count
    }
    
    public subscript(index: Int) -> T {
        return _filteredData[index]
    }
    
    public init(initialValue: [T] = [], changeHandler: DiffableArray<T>.ChangeHandler) {
        _filteredData = DiffableArray(initialValue: initialValue, changeHandler: changeHandler)
        value = initialValue
    }
    
    private func updateFilteredData() {
        _filteredData.value = filterFunction.map{value.filter($0)} ?? value
    }
}


// MARK: - LCS: Longest common subsequence problem
// http://en.wikipedia.org/wiki/Longest_common_subsequence_problem

extension ArrayDiffer {
    
    private typealias IndexType = Int
    private typealias LCSMatrix = Array<Array<IndexType>>
    
    /// @return LCS matrix
    private class func LCSLength(x xlist: [T], y ylist: [T]) -> LCSMatrix {
        let xlen = xlist.count + 1
        let ylen = ylist.count + 1
        
        var m = Array(count: xlen, repeatedValue:Array(count:ylen, repeatedValue:0))
        for x in 1..<xlen {
            for y in 1..<ylen {
                if xlist[x-1] == ylist[y-1] {
                    m[x][y] = m[x-1][y-1] + 1
                } else {
                    m[x][y] = max(m[x][y-1], m[x-1][y])
                }
            }
        }
        return m
    }
    
    /// @return array of unchanged elements
    private class func LCSBacktrack(matrix m: LCSMatrix, x xlist:[T], y ylist:[T]) -> [T] {
        var a = [T]()
        var x = xlist.count
        var y = ylist.count
        while y >= 1 && x >= 1 {
            if xlist[x-1] == ylist[y-1] {
                a.append(xlist[x-1])
                x -= 1
                y -= 1
            } else {
                if m[x][y-1] > m[x-1][y] {
                    y -= 1
                } else {
                    x -= 1
                }
            }
        }
        return a.reverse()
    }
    
    /// @return a mapped list of [x] - [y]
    /// precondition: y is a subset of x
    private class func LCSSubtract<U>(x xlist: [T], y ylist: [T], mapFunc: IndexType -> U) -> [U] {
        let xlen = xlist.count
        let ylen = ylist.count
        
        var indexList = [U]()
        var y = 0
        for x in 0..<xlen {
            if y < ylen && xlist[x] == ylist[y] {
                y += 1
            } else {
                indexList.append(mapFunc(x))
            }
        }
        return indexList
    }
    
    private class func LCSDiff<U>(oldValue oldValue: [T], newValue: [T], mapFunc: IndexType -> U) -> ArrayDiff<U> {
        let matrix = LCSLength(x: oldValue, y: newValue)
        let unchanged = LCSBacktrack(matrix: matrix, x: oldValue, y: newValue)
        
        let removed = LCSSubtract(x: oldValue, y: unchanged, mapFunc: mapFunc)
        let added   = LCSSubtract(x: newValue, y: unchanged, mapFunc: mapFunc)
        
        return ArrayDiff(added: added, removed: removed, modified: [])
    }
}