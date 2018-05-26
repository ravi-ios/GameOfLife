//
//  GridViewModel.swift
//  GameofLife
//
//  Created by RAVI on 10/04/18.
//  Copyright © 2018 RAVI. All rights reserved.
//

import Foundation

struct GridViewModel {

    var cells: [Cell]
    
    let gridSize: Int
    
    
    /*
     * Initialize with size of the matrix, Here I am assuming number of row are same as number of cloloumns
     */
    
    init(gridsize: Int) {
        self.gridSize = gridsize
        cells = []
        for x in 0..<gridSize {
            for y in 0..<gridSize {
                /*
                 * Of course, With 2D array we can traverse easily our matrix structure.
                 * To make it even simpler just assign the x ,y position to every cell (Pretty cool ahh)
                 */
                cells.append(Cell(x: x, y: y))
            }
        }
    }
        
    //Get nighbours for cell
    func neighboursFor(_ cell: Cell) ->  [Cell] {
        
        /*
         * We do not need to calculate nighbours of evry cell over and over
         * Calculate once use at any time
         */
        
        if let nighbours =  cell.nighbours {
            return nighbours
        }
        
        let row = cell.position.x
        let coloumn = cell.position.y
        
        /*
         * Simplest way to calculate nighbour indexes. (i.e just Row-1, Row, Row+1, Coloumn-1, Coloumn, Coloumn-1 will provide all nighbors positions)
         */
        
        let nighbourRows: [Int] = nighbourPosition(row)
        let nighbourColoumns: [Int] = nighbourPosition(coloumn)
        var nighbourCells: [Cell] = []
        
        for x in nighbourRows {
            for y in nighbourColoumns {
                if row == x, coloumn == y {
                    continue
                }
                if let cell = cellForPosition(x, y: y){
                    nighbourCells.append(cell)
                }
            }
        }
        
        let currentCell = cell
        currentCell.nighbours = nighbourCells
        
        return nighbourCells
    }
    
    func neighboursFor(_ cell: Cell, with state: State) ->  [Cell] {
        return neighboursFor(cell).filter { $0.state == state } //Get nighbours for cell with specified state
    }
    
    func cellForPosition(_ x: Int, y: Int) -> Cell? {
        return cells.filter { $0.position.x == x && $0.position.y == y }.first //Get cell for specified position
    }
    
    func nighbourPosition(_ postion: Int) -> [Int] {
        
//        just Row-1, Row, Row+1, Coloumn-1, Coloumn, Coloumn-1 will provide all nighbours positions
        
        if (postion == 0) {
            return [postion, postion+1]
        }
        else if (postion == gridSize) {
            return [postion-1, postion]
        }
        else {
            return [postion-1, postion, postion+1]
        }
    }
    
    func triggerNextStep() {
        
        /*
         
         Here is the most important game rules
         
         - a living cell with 1 or less neighbors dies
         - a living cell with 4 or more neighbors dies
         - a living cell with 2 or 3 neighbors continues living
         - a dead cell with 3 neighbors starts to live
         - a dead cell with 4 or more neighbors becomes permanently dead
         
         */
        
        let liveCells = cells.filter { $0.state == .live }
        
        let dyingCells = liveCells.filter {
            /*
             - a living cell with 1 or less neighbors dies
             - a living cell with 4 or more neighbors dies
             */
            
            let livingCellsCount = self.neighboursFor($0, with: .live).count
            return (livingCellsCount <= 1 || livingCellsCount >= 4 )
        }
        
        let livingCells = liveCells.filter {
            
            /*
             - a living cell with 2 or 3 neighbors continues living
             */
            
            let livingCellsCount = self.neighboursFor($0, with: .live).count
            return (livingCellsCount == 2 || livingCellsCount == 3)
        }
        
        let deadCells = cells.filter { $0.state == .dead }
        
        let newLife = deadCells.filter {
            
            /*
             - a dead cell with 3 neighbors starts to live
             */
            return (self.neighboursFor($0, with: .live).count == 3)
        }
        
        let perminantlyDyingCells = deadCells.filter {
            /*
             - a dead cell with 4 or more neighbors becomes permanently dead
             */
            (self.neighboursFor($0, with: .live).count >= 4)
        }
        
        dyingCells.forEach { $0.state = .dead }
        
        livingCells.forEach { $0.state = .live }
        
        newLife.forEach { $0.state = .live }
        
        perminantlyDyingCells.forEach { $0.state = .perminantlyDead }
    }
    
    subscript (x: Int, y: Int) -> Cell? {
        return cells.filter { $0.position.x == x && $0.position.y == y }.first
    }
}
