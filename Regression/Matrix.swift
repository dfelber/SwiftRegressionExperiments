//
//  Matrix.swift
//  Regression
//
//  Created by Dominik Felber on 15.05.16.
//  Copyright © 2016 Dominik Felber. All rights reserved.
//

import Foundation
import Accelerate



/// Matrix, storing its values in row-major order.
class Matrix
{
    /// The raw values of the Matrix in row-major order.
    private (set) var values: [Double]
    
    /// The columns of the Matrix.
    let columns: UInt
    
    /// The rows of the Matrix.
    let rows: UInt
    
    
    init(columns: UInt, rows: UInt, values: [Double]? = nil) {
        self.columns = columns
        self.rows = rows
        self.values = values ?? [Double](count: Int(columns * rows), repeatedValue: 0)
    }
    
    
    init(columns: UInt, rows: UInt, values value: Double) {
        self.columns = columns
        self.rows = rows
        self.values = [Double](count: Int(columns * rows), repeatedValue: value)
    }
    
    
    /// Returns the transposed version of the Matrix
    func transposed() -> Matrix {
        var result = self.values
        
        let columns = vDSP_Length(self.rows)
        let rows    = vDSP_Length(self.columns)
        
        vDSP_mtransD(self.values, 1, &result, 1, rows, columns)
        
        return Matrix(columns: columns, rows: rows, values: result)
    }
    
    
    /// Returns the inverted version of the Matrix
    func inverted() -> Matrix {
        var result = self.values
        
        var pivot: __CLPK_integer = 0
        var error: __CLPK_integer = 0
        var workspace = 0.0
        
        var N = __CLPK_integer(sqrt(Double(self.values.count)))
        dgetrf_(&N, &N, &result, &N, &pivot, &error)
        
        guard error == 0 else {
            return self
        }
        
        dgetri_(&N, &result, &N, &pivot, &workspace, &N, &error)
        
        return Matrix(columns: self.rows, rows: self.columns, values: result)
    }
    
    
    /// Sets all values to `value`.
    func setValues(value: Double) {
        values = [Double](count: values.count, repeatedValue: value)
    }
    
    
    /// Replaces `values` with `newValues`.
    ///
    /// - parameter newValues:
    ///        The new values of the Matrix.
    ///        The count of `newValues` must match the count of `values`.
    ///
    func setValues(newValues: [Double]) {
        guard newValues.count == values.count else {
            return
        }
        
        values = newValues
    }
    
    
    /// Get/Set the value at `column` and `row`.
    subscript (column: UInt, row: UInt) -> Double {
        get {
            let index = columns * row + column
            guard index < UInt(self.values.count) else {
                return Double.NaN
            }
            
            return self.values[Int(index)]
        }
        
        set {
            let index = columns * row + column
            guard index < UInt(self.values.count) else {
                return
            }
            
            values[Int(index)] = newValue
        }
    }
    
    
    /// Get/Set the values at range `r`.
    subscript(r: Range<Int>) -> [Double] {
        get {
            return Array(values[r])
        }
        
        set {
            values[r] = ArraySlice(newValue)
        }
    }
}