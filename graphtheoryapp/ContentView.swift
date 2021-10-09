//
//  ContentView.swift
//  graphtheoryapp
//
//  Created by sankalp kasle on 14/06/20.
//  Copyright © 2020 sankalp kasle. All rights reserved.
//

import SwiftUI
import Foundation

struct ContentView: View {
    
    var ourMatrix = [[Cell]]()
    var startrowindex = 9
    var startcolidex = 0
    var endrowindex = 9
    var endcolindex = 8
    
    @EnvironmentObject var visitedcellsprop: VisitedCells
    
    init() {
        
        for rowindex in 0...19
        {
            var somearray = [Cell]()
            for colindex in 0...12
            {
                if rowindex == startrowindex && colindex == startcolidex
                {
                    somearray.append(Cell(row: rowindex, col: colindex, isItStart: true, isItEnd: false))
                }
                if rowindex == endrowindex && colindex == endcolindex
                {
                    somearray.append(Cell(row: rowindex, col: colindex, isItStart: false, isItEnd: true))
                }
                somearray.append(Cell(row: rowindex, col: colindex, isItStart: false, isItEnd: false))
            }
            ourMatrix.append(somearray)
        }
        
    }
    var body: some View {
        
        VStack{
            HStack{
                Text("Dijkstra's")
                .font(.title)
                .foregroundColor(Color.green)
                Spacer()
                Button(action: {
                    //self.findPath(cellMatrix: self.ourMatrix, startrow: self.startrowindex, startcol: self.startcolidex, endrow: self.endrowindex, endcol: self.endcolindex)
                    self.findShortestPath(cellMatrix: self.ourMatrix, startrow: self.startrowindex, startcol: self.startcolidex, endrow: self.endrowindex, endcol: self.endcolindex)
                }) {
                    Group{
                        Text("FindPath").padding(12).foregroundColor(Color.white)
                        }.background(Color.gray)
                    .cornerRadius(5)
                }
            }.padding(3)
            VStack{
                ForEach(0..<20) { rowindex in
                    HStack{
                        ForEach(0..<13) { colindex in
                            self.ourMatrix[rowindex][colindex].frame(width: 20, height: 20, alignment: .center).cornerRadius(3)
                        }
                    }
                }
            }
        }.padding(10)
    }
    
    func findDijkstraPath(cellMatrix: [[Cell]], startrow: Int, startcol: Int, endrow: Int, endcol: Int) -> ([[Int]], [[(Int, Int)]])
    {
        var tempcellMatrix = cellMatrix
        let rowlength = tempcellMatrix[0].count
        let collength = tempcellMatrix.count
        
        //Djikstra's Algorithm
        var visited = [[Bool]]()
        var distance = [[Int]]()
        var prev = [[(Int, Int)]]()
        var unvisitedNodes : [(row:Int, col:Int, distance:Int)] = []
        
        //tempcellMatrix[startrow][startcol].distance = 5
        //let startNodeDistanceArrayIndex = (rowlength*(startrow)) + startcol
        //let endNodeDistanceArrayIndex = (rowlength*(endrow)) + endcol
        
        for row in 0...tempcellMatrix.count-1
        {
            var somearrayvisi = [Bool]()
            var somearraydist = [Int]()
            var somearrayprev = [(Int, Int)]()
            for col in 0...tempcellMatrix[row].count-1
            {
                somearraydist.append(tempcellMatrix[row][col].distance)
                somearrayvisi.append(false)
                somearrayprev.append((-1, -1))
            }
            distance.append(somearraydist)
            visited.append(somearrayvisi)
            prev.append(somearrayprev)
        }
        distance[startrow][startcol] = 0
        tempcellMatrix[startrow][startcol].distance = 0
        
        //Add start node to PQ
        unvisitedNodes.append((row: startrow, col: startcol, distance: 0))
        
        while unvisitedNodes.count != 0 {
            //Find the min in PQ
            unvisitedNodes.sort(by: {$0.distance < $1.distance})
            
            let minEle = unvisitedNodes[0]
            let minEleRowIndex = minEle.row
            let minEleColIndex = minEle.col
            unvisitedNodes.remove(at: 0)
            
            if self.visitedcellsprop.isthisWall(rowId: minEleRowIndex, colId: minEleColIndex) == true
            {
                continue
            }
            
            if tempcellMatrix[minEleRowIndex][minEleColIndex].isItAWall == true
            {
                print("its a wall")
                continue
            }
            
            if minEleRowIndex == endrow && minEleColIndex == endcol
            {
                print(distance[endrow][endcol])
                return (distance, prev)
            }
            
            visited[minEleRowIndex][minEleColIndex] = true
            self.visitedcellsprop.Visitfunc(rowId: minEleRowIndex, colId: minEleColIndex)
            
            if distance[minEleRowIndex][minEleColIndex] < minEle.distance
            {
                continue
            }
            
            //Find the neighbors of minEle
            var topneighbor : Cell?
            if minEleRowIndex > 0
            {
                topneighbor = tempcellMatrix[minEleRowIndex-1][minEleColIndex]
            }
            
            var bottomneighbor : Cell?
            if minEleRowIndex < collength-1
            {
                bottomneighbor = tempcellMatrix[minEleRowIndex+1][minEleColIndex]
            }
            
            var leftneighbor : Cell?
            if minEleColIndex > 0
            {
                leftneighbor = tempcellMatrix[minEleRowIndex][minEleColIndex-1]
            }
            
            var rightneighbor : Cell?
            if minEleColIndex < rowlength-1
            {
                rightneighbor = tempcellMatrix[minEleRowIndex][minEleColIndex+1]
            }
            
            //Update distance of neighbors in distance array
            //Add updated distance of neighbors in PQ
            let newDist = distance[minEleRowIndex][minEleColIndex] + 1
            if var topneighbor = topneighbor
            {
                if self.visitedcellsprop.isthisWall(rowId: topneighbor.row, colId: topneighbor.col) == false
                {
                    if visited[topneighbor.row][topneighbor.col] == false
                    {
                        if newDist < distance[topneighbor.row][topneighbor.col]
                        {
                            prev[topneighbor.row][topneighbor.col] = (minEleRowIndex, minEleColIndex)
                            distance[topneighbor.row][topneighbor.col] = newDist
                            topneighbor.distance = newDist
                            unvisitedNodes.append((row: topneighbor.row, col: topneighbor.col, distance: newDist))
                        }
                    }
                }
            }
            if var bottomneighbor = bottomneighbor
            {
                if self.visitedcellsprop.isthisWall(rowId: bottomneighbor.row, colId: bottomneighbor.col) == false
                {
                    if visited[bottomneighbor.row][bottomneighbor.col] == false
                    {
                        if newDist < distance[bottomneighbor.row][bottomneighbor.col]
                        {
                            prev[bottomneighbor.row][bottomneighbor.col] = (minEleRowIndex, minEleColIndex)
                            distance[bottomneighbor.row][bottomneighbor.col] = newDist
                            bottomneighbor.distance = newDist
                            unvisitedNodes.append((row: bottomneighbor.row, col: bottomneighbor.col, distance: newDist))
                        }
                    }
                }
            }
            if var leftneighbor = leftneighbor
            {
                if self.visitedcellsprop.isthisWall(rowId: leftneighbor.row, colId: leftneighbor.col) == false
                {
                    if visited[leftneighbor.row][leftneighbor.col] == false
                    {
                        if newDist < distance[leftneighbor.row][leftneighbor.col]
                        {
                            prev[leftneighbor.row][leftneighbor.col] = (minEleRowIndex, minEleColIndex)
                            distance[leftneighbor.row][leftneighbor.col] = newDist
                            leftneighbor.distance = newDist
                            unvisitedNodes.append((row: leftneighbor.row, col: leftneighbor.col, distance: newDist))
                        }
                    }
                }
            }
            if var rightneighbor = rightneighbor
            {
                if self.visitedcellsprop.isthisWall(rowId: rightneighbor.row, colId: rightneighbor.col) == false
                {
                    if visited[rightneighbor.row][rightneighbor.col] == false
                    {
                        if newDist < distance[rightneighbor.row][rightneighbor.col]
                        {
                            prev[rightneighbor.row][rightneighbor.col] = (minEleRowIndex, minEleColIndex)
                            distance[rightneighbor.row][rightneighbor.col] = newDist
                            rightneighbor.distance = newDist
                            unvisitedNodes.append((row: rightneighbor.row, col: rightneighbor.col, distance: newDist))
                        }
                    }
                }
            }
        }
        //return infinity
        return (distance, prev)
    }
    
    func findShortestPath(cellMatrix: [[Cell]], startrow: Int, startcol: Int, endrow: Int, endcol: Int)
    {
        var distance = [[Int]]()
        var prev = [[(Int, Int)]]()
        
        //Dijkstra's Algorithm
        //(distance, prev) = self.findDijkstraPath(cellMatrix: cellMatrix, startrow: startrow, startcol: startcol, endrow: endrow, endcol: endcol)
        (distance, prev) = self.findAStarPath(cellMatrix: cellMatrix, startrow: startrow, startcol: startcol, endrow: endrow, endcol: endcol)
        
        var path = [(Int, Int)]()
        
        if(distance[endrow][endcol] == -1)
        {
            print("No path found")
        }
        else
        {
            var jrow = endrow
            var jcol = endcol
            for i in 0...prev.count+200
            {
                if(jrow != -1 && jcol != -1)
                {
                    path.append(prev[jrow][jcol])
                    (jrow, jcol) = prev[jrow][jcol]
                }
                else
                {
                    break
                }
            }
            path.reverse()
            self.visitedcellsprop.markThePath(path: path)
        }
        print(path)
        
    }
    
    func findAStarPath(cellMatrix: [[Cell]], startrow: Int, startcol: Int, endrow: Int, endcol: Int)  -> ([[Int]], [[(Int, Int)]])
    {
        var tempcellMatrix = cellMatrix
        let rowlength = tempcellMatrix[0].count
        let collength = tempcellMatrix.count
        
        //Djikstra's Algorithm
        var visited = [[Bool]]()
        var distance = [[Int]]()
        var heuristic = [[Double]]()
        var prev = [[(Int, Int)]]()
        var unvisitedNodes : [(row:Int, col:Int, distance: Int, heuristic: Double)] = []
        
        for row in 0...tempcellMatrix.count-1
        {
            var somearrayvisi = [Bool]()
            var somearraydist = [Int]()
            var somearrayheu = [Double]()
            var somearrayprev = [(Int, Int)]()
            for col in 0...tempcellMatrix[row].count-1
            {
                let rowshit = ((endrow-row)*(endrow-row))
                let colshit = ((endcol-col)*(endcol-col))
                let euclidianHeuristic = sqrt(Double(rowshit + colshit))
                somearraydist.append(Int.max)
                somearrayheu.append(euclidianHeuristic)
                somearrayvisi.append(false)
                somearrayprev.append((-1, -1))
            }
            distance.append(somearraydist)
            heuristic.append(somearrayheu)
            visited.append(somearrayvisi)
            prev.append(somearrayprev)
        }
        distance[startrow][startcol] = 0
        tempcellMatrix[startrow][startcol].distance = 0
        
        //Add start node to PQ
        unvisitedNodes.append((row: startrow, col: startcol, distance:0, heuristic: heuristic[startrow][startcol]))
        
        while unvisitedNodes.count != 0 {
            //Find the min in PQ
            unvisitedNodes.sort(by: {$0.heuristic < $1.heuristic})
            
            let minEle = unvisitedNodes[0]
            let minEleRowIndex = minEle.row
            let minEleColIndex = minEle.col
            
            unvisitedNodes.remove(at: 0)
            
            if self.visitedcellsprop.isthisWall(rowId: minEleRowIndex, colId: minEleColIndex) == true
            {
                continue
            }
            
            if minEleRowIndex == endrow && minEleColIndex == endcol
            {
                print(distance[endrow][endcol])
                return (distance, prev)
            }
            
            visited[minEleRowIndex][minEleColIndex] = true
            self.visitedcellsprop.Visitfunc(rowId: minEleRowIndex, colId: minEleColIndex)
            
            if distance[minEleRowIndex][minEleColIndex] < minEle.distance
            {
                continue
            }
            
            //Find the neighbors of minEle
            var topneighbor : Cell?
            if minEleRowIndex > 0
            {
                topneighbor = tempcellMatrix[minEleRowIndex-1][minEleColIndex]
            }
            
            var bottomneighbor : Cell?
            if minEleRowIndex < collength-1
            {
                bottomneighbor = tempcellMatrix[minEleRowIndex+1][minEleColIndex]
            }
            
            var leftneighbor : Cell?
            if minEleColIndex > 0
            {
                leftneighbor = tempcellMatrix[minEleRowIndex][minEleColIndex-1]
            }
            
            var rightneighbor : Cell?
            if minEleColIndex < rowlength-1
            {
                rightneighbor = tempcellMatrix[minEleRowIndex][minEleColIndex+1]
            }
            
            //Update distance of neighbors in distance array
            //Add updated distance of neighbors in PQ
            let newDist = distance[minEleRowIndex][minEleColIndex] + 1
            if var topneighbor = topneighbor
            {
                if self.visitedcellsprop.isthisWall(rowId: topneighbor.row, colId: topneighbor.col) == false
                {
                    if visited[topneighbor.row][topneighbor.col] == false
                    {
                        let heu = heuristic[topneighbor.row][topneighbor.col]
                        let somedist = distance[topneighbor.row][topneighbor.col]
                        if Double(newDist) + heu < Double(somedist) + heu
                        {
                            prev[topneighbor.row][topneighbor.col] = (minEleRowIndex, minEleColIndex)
                            distance[topneighbor.row][topneighbor.col] = newDist
                            //topneighbor.distance = Int(newDist)
                            unvisitedNodes.append((row: topneighbor.row, col: topneighbor.col, distance: newDist, heuristic:Double(newDist) + heu))
                        }
                    }
                }
            }
            if var bottomneighbor = bottomneighbor
            {
                if self.visitedcellsprop.isthisWall(rowId: bottomneighbor.row, colId: bottomneighbor.col) == false
                {
                    if visited[bottomneighbor.row][bottomneighbor.col] == false
                    {
                        let heu = heuristic[bottomneighbor.row][bottomneighbor.col]
                        let somedist = distance[bottomneighbor.row][bottomneighbor.col]
                        if Double(newDist) + heu < Double(somedist) + heu
                        {
                            prev[bottomneighbor.row][bottomneighbor.col] = (minEleRowIndex, minEleColIndex)
                            distance[bottomneighbor.row][bottomneighbor.col] = newDist
                            //bottomneighbor.distance = Int(newDist)
                            unvisitedNodes.append((row: bottomneighbor.row, col: bottomneighbor.col, distance: newDist, heuristic:Double(newDist) + heu))
                        }
                    }
                }
            }
            if var leftneighbor = leftneighbor
            {
                if self.visitedcellsprop.isthisWall(rowId: leftneighbor.row, colId: leftneighbor.col) == false
                {
                    if visited[leftneighbor.row][leftneighbor.col] == false
                    {
                        let heu = heuristic[leftneighbor.row][leftneighbor.col]
                        let somedist = distance[leftneighbor.row][leftneighbor.col]
                        if Double(newDist) + heu < Double(somedist) + heu
                        {
                            prev[leftneighbor.row][leftneighbor.col] = (minEleRowIndex, minEleColIndex)
                            distance[leftneighbor.row][leftneighbor.col] = newDist
                            //leftneighbor.distance = Int(newDist)
                            unvisitedNodes.append((row: leftneighbor.row, col: leftneighbor.col, distance: newDist, heuristic:Double(newDist) + heu))
                        }
                    }
                }
            }
            if var rightneighbor = rightneighbor
            {
                if self.visitedcellsprop.isthisWall(rowId: rightneighbor.row, colId: rightneighbor.col) == false
                {
                    if visited[rightneighbor.row][rightneighbor.col] == false
                    {
                        let heu = heuristic[rightneighbor.row][rightneighbor.col]
                        let somedist = distance[rightneighbor.row][rightneighbor.col]
                        
                        if Double(newDist) + heu < Double(somedist) + heu
                        {
                            prev[rightneighbor.row][rightneighbor.col] = (minEleRowIndex, minEleColIndex)
                            distance[rightneighbor.row][rightneighbor.col] = newDist
                            //rightneighbor.distance = Int(newDist)
                            unvisitedNodes.append((row: rightneighbor.row, col: rightneighbor.col, distance: newDist, heuristic:Double(newDist) + heu))
                        }
                    }
                }
            }
        }
        return (distance, prev)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
