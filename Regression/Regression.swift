//
//  Regression.swift
//  Regression
//
//  Created by Dominik Felber on 15.05.16.
//  Copyright © 2016 Dominik Felber. All rights reserved.
//

import Foundation


class Regression
{
    let degree: Int
    
    private (set) var betas: [Double] = []
    
    
    init(x: Matrix, y: Matrix, degree: Int) {
        self.degree = degree
        self.betas = self.findBetas(x: x, y: y, degree: degree)
    }
    
    
    private func calculatePowersOfX(x: Matrix) -> Matrix {
        var newX = x
        
        if degree > 1 {
            for i in 2...degree {
                let degreeOfX = Matrix(columns: 1, rows: x.rows)
                degreeOfX.setValues(x.values.map({ $0^Double(i) }))
                
                newX = newX.appendHorizontal(degreeOfX)
            }
        }
        
        return newX
    }
    
    
    private func findBetas(x x: Matrix, y: Matrix, degree: Int) -> [Double] {
        let newX = calculatePowersOfX(x)
        let ones = Matrix(columns: 1, rows: y.rows, values: 1)
        let onedNewX = ones.appendHorizontal(newX)
        
        let a = (onedNewX.transposed() * onedNewX).values
        let b = (onedNewX.transposed() * y).values
        
        return solve(a, b)
    }
    
    
    func predict(x: Matrix) -> Matrix {
        let beta = Matrix(columns: 1, rows: UInt(betas.count), values: betas)
        let newX = calculatePowersOfX(x)
        let ones = Matrix(columns: 1, rows: newX.rows, values: 1)
        let onedNewX = ones.appendHorizontal(newX)
        
        return onedNewX * beta
    }
}