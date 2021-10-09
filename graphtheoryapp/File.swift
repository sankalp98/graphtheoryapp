//
//  File.swift
//  graphtheoryapp
//
//  Created by sankalp kasale on 20/08/20.
//  Copyright © 2020 sankalp kasle. All rights reserved.
//

import Foundation

class VisitedCells: ObservableObject
{
    @Published var visitedCordinates = [[Int()]]
    @Published var wallCordinates = [[Int()]]
    @Published var pathCordinates = [[Int()]]

    func Visitfunc(rowId: Int, colId: Int)
    {
        let somecordinate = [rowId, colId]
        visitedCordinates.append(somecordinate)
    }
    func clickedWallfunc(rowId: Int, colId: Int)
    {
        let somecordinate = [rowId, colId]
        wallCordinates.append(somecordinate)
    }
    func isthisvisited(rowId: Int, colId: Int) -> Bool
    {
        for cordi in visitedCordinates
        {
            let some = [rowId, colId]
            
            if cordi == some
            {
                //print("its there")
                return true
            }
        }
        return false
    }
    func isthisWall(rowId: Int, colId: Int) -> Bool
    {
        for cordi in wallCordinates
        {
            let some = [rowId, colId]
            
            if cordi == some
            {
                //print("its there")
                return true
            }
        }
        return false
    }
    func isthisInPath(rowId: Int, colId: Int) -> Bool
    {
        for cordi in pathCordinates
        {
            let some = [rowId, colId]
            
            if cordi == some
            {
                return true
            }
        }
        return false
    }
    
    func markThePath(path: [(Int, Int)])
    {
        for cordi in path
        {
            let row = cordi.0
            let col = cordi.1
            
            self.pathCordinates.append([row, col])
        }
    }
}
