//
//  Cell.swift
//  graphtheoryapp
//
//  Created by sankalp kasle on 13/07/20.
//  Copyright © 2020 sankalp kasle. All rights reserved.
//

import SwiftUI

class Celldata: ObservableObject
{
    @Published var isItVisited = false
}

struct Cell: View {
    
    @EnvironmentObject var visitedcellsprop: VisitedCells
    
    var row = 0
    var col = 0
    var distance = Int.max
    var isItStart = false
    var isItEnd = false
    @State var isItVisited = false
    @State var isItAWall = false
    
    var body: some View {
        VStack
        {
            if isItStart == true
            {
                Color.yellow
            }
            else
            {
                if isItEnd == true
                {
                    Color.red
                }
                else
                {
                    if self.isItAWall == true
                    {
                        Color.black
                    }
                    else
                    {
                        if visitedcellsprop.isthisvisited(rowId: row, colId: col) == true
                        {
                            if visitedcellsprop.isthisInPath(rowId: row, colId: col) == true
                            {
                                Color.purple.animation(.easeInOut(duration: 2))
                            }
                            else
                            {
                                //Color.green.animation(.easeInOut(duration: 2))
                                Color.green
                                .animation(Animation.default.speed(1))
                            }
                        }
                        else
                        {
                            Color.blue
                        }
                    }
                }
            }
        }.onTapGesture(count: 1) {
            if self.visitedcellsprop.isthisvisited(rowId: self.row, colId: self.col) == false
            {
                self.visitedcellsprop.clickedWallfunc(rowId: self.row, colId: self.col)
                self.isItAWall = true
            }
            else
            {
                self.isItAWall = false
            }
        }
    }
}

struct Cell_Previews: PreviewProvider {
    static var previews: some View {
        Cell().environmentObject(VisitedCells())
    }
}
