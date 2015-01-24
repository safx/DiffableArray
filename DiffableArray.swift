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
        return ArrayDiffer.LCSDiff(oldValue: oldValue, newValue: newValue) { NSIndexPath(forRow: $0, inSection: 0)! }
    }
}

public class DiffableArray<T: Equatable> {
    typealias SinkOfDiffer = SinkOf<ArrayDiffer<T>>
    
    private var _value: [T]
    private var _diffSink: SinkOfDiffer
    
    public var value: [T] {
        get { return self._value }
        set {
            _diffSink.put(ArrayDiffer(oldValue: self._value, newValue: newValue))
            self._value = newValue
        }
    }
    
    public var count: Int {
        return _value.count
    }
    
    public subscript(index: Int) -> T {
        return _value[index]
    }
    
    public init(diffSink: SinkOfDiffer, initialValue: [T] = []) {
        _value = initialValue
        _diffSink = diffSink
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
    
    public init(diffSink: DiffableArray<T>.SinkOfDiffer, initialValue: [T] = []) {
        value = initialValue
        _filteredData = DiffableArray(diffSink: diffSink, initialValue: initialValue)
    }
    
    private func updateFilteredData() {
        if let f = filterFunction {
            _filteredData.value = value.filter(f)
        } else {
            _filteredData.value = value
        }
    }
}


// MARK: - LCS: Longest common subsequence problem
// http://en.wikipedia.org/wiki/Longest_common_subsequence_problem

extension ArrayDiffer {
    
    private typealias IndexType = Int
    private typealias LCSMatrix = Array<Array<IndexType>>
    
    /// @return LCS matrix
    private class func LCSLength(x xlist: [T], y ylist: [T]) -> LCSMatrix {
        let xlen = countElements(xlist) + 1
        let ylen = countElements(ylist) + 1
        
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
        var x = countElements(xlist)
        var y = countElements(ylist)
        while y >= 1 && x >= 1 {
            if xlist[x-1] == ylist[y-1] {
                a.append(xlist[x-1])
                --x
                --y
            } else {
                if m[x][y-1] > m[x-1][y] {
                    --y
                } else {
                    --x
                }
            }
        }
        return a.reverse()
    }
    
    /// @return a mapped list of [x] - [y]
    /// precondition: y is a subset of x
    private class func LCSSubtract<U>(x xlist: [T], y ylist: [T], mapFunc: IndexType -> U) -> [U] {
        let xlen = countElements(xlist)
        let ylen = countElements(ylist)
        
        var indexList = [U]()
        var y = 0
        for x in 0..<xlen {
            if y < ylen && xlist[x] == ylist[y] {
                ++y
            } else {
                indexList.append(mapFunc(x))
            }
        }
        return indexList
    }
    
    private class func LCSDiff<U>(#oldValue: [T], newValue: [T], mapFunc: IndexType -> U) -> ArrayDiff<U> {
        let matrix = LCSLength(x: oldValue, y: newValue)
        let unchanged = LCSBacktrack(matrix: matrix, x: oldValue, y: newValue)
        
        let removed = LCSSubtract(x: oldValue, y: unchanged, mapFunc: mapFunc)
        let added   = LCSSubtract(x: newValue, y: unchanged, mapFunc: mapFunc)
        
        return ArrayDiff(added: added, removed: removed, modified: [])
    }
}