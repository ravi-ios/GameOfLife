//
//  GameofLifeTests.swift
//  GameofLifeTests
//
//  Created by RAVI on 10/04/18.
//  Copyright © 2018 RAVI. All rights reserved.
//

import XCTest
@testable import GameofLife

class GameofLifeTests: XCTestCase {
    
    var gridModel: GridViewModel?
    let gridSize = 5
    
    /*
     
     Rules:
     
     - a living cell with 1 or less neighbors dies
     - a living cell with 4 or more neighbors dies
     - a living cell with 2 or 3 neighbors continues living
     - a dead cell with 3 neighbors starts to live
     - a dead cell with 4 or more neighbors becomes permanently dead
     
     */
    
    
    
    override func setUp() {
        super.setUp()
        gridModel = GridViewModel.init(gridsize: gridSize)
        
        for index in 0..<gridSize {
            gridModel?[index, index]?.state = .live
            gridModel?[index, (gridSize - 1) - index]?.state = .live
        }
        
        /*
         
         | 1 | 0 | 0 | 0 | 1 |
         ---------------------
         | 0 | 1 | 0 | 1 | 0 |
         ---------------------
         | 0 | 0 | 1 | 0 | 0 |
         ---------------------
         | 0 | 1 | 0 | 1 | 0 |
         ---------------------
         | 1 | 0 | 0 | 0 | 1 |
         
                  ||
                  ||   After First step
                  \/
         
         | 0 | 0 | 0 | 0 | 0 |
         ---------------------
         | 0 | 1 | 1 | 1 | 0 |
         ---------------------
         | 0 | 1 | 0 | 1 | 0 |
         ---------------------
         | 0 | 1 | 1 | 1 | 0 |
         ---------------------
         | 0 | 0 | 0 | 0 | 0 |
         
         
         */
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testNighboursForCell() {
        let index = Int(ceil(Double((gridSize-1)/2)))
        
        let gridCell = gridModel?.cellForPosition(index, y: index)
        
        guard let cell = gridCell else {
            XCTAssertNotNil(gridCell, "cell should not be nil for selected index")
            return
        }
        
        let cells = gridModel?.neighboursFor(cell)
        
        let nighbourRows: [Int] = (gridModel?.nighbourPosition(index))!
        let nighbourColoumns: [Int] = nighbourRows // Coloms and
        var expectedCell: [Cell] = []
        
        for x in nighbourRows {
            for y in nighbourColoumns {
                if index == x, index == y {
                    continue
                }
                if let cell = gridModel?.cellForPosition(x, y: y){
                    expectedCell.append(cell)
                }
            }
        }
        
        let nighbours = cells?.filter({ (cell) -> Bool in
            (expectedCell.filter({ (nighbour) -> Bool in
                (nighbour.position.x == cell.position.x && nighbour.position.y == cell.position.y)
            }).first != nil)
        })
        
        XCTAssertNotNil(nighbours, "Nighbours should not be empty")
        
        XCTAssertEqual(nighbours?.count, cells?.count, "Incorrect resultant nighbours")
        
        XCTAssertEqual(expectedCell.count, cells?.count, "Incorrect expected nighbours")
        
    }
    
    func testNighboursForCellInAlterNative() {
        let index = Int(ceil(Double((gridSize-1)/2)))
        
        let gridCell = gridModel?.cellForPosition(index, y: index)
        
        guard let cell = gridCell else {
            XCTAssertNotNil(gridCell, "cell should not be nil for selected index")
            return
        }
        
        let cells = gridModel?.neighboursFor(cell)
        
        let expectedNighbours : [Position] = [Position(x: 1, y: 1),
                                              Position(x: 1, y: 2),
                                              Position(x: 1, y: 3),
                                              Position(x: 2, y: 1),
                                              Position(x: 2, y: 3),
                                              Position(x: 3, y: 1),
                                              Position(x: 3, y: 2),
                                              Position(x: 3, y: 3)]
        
        
        let resultantCells = cells?.filter({ (cell) -> Bool in
            (expectedNighbours.filter({ (position) -> Bool in
                (position.x == cell.position.x && position.y == cell.position.y)
            }).first != nil)
        })
        
        XCTAssertNotNil(expectedNighbours, "Nighbours should not be nil")
        
        XCTAssertEqual(resultantCells?.count, cells?.count, "Incorrect resultant nighbours")
        
        XCTAssertEqual(expectedNighbours.count, cells?.count, "Incorrect expected nighbours")
        
    }
    
    func testCellPosition() {
        let row = gridSize-1
        let coloumn = gridSize-2
        
        let gridCell = gridModel?.cellForPosition(row, y: coloumn)
        
        guard let cell = gridCell else {
            XCTAssertNotNil(gridCell, "cell should not be nil for selected index")
            return
        }
        
        
        XCTAssertEqual(cell.position.x, 4, "Incorrect x-position for cell")
        
        XCTAssertEqual(cell.position.y, 3, "Incorrect y-position for cell")

    }
    
    func testliveStateNighboursForCell() {
        let index = Int(ceil(Double((gridSize-1)/2)))
        
        let gridCell = gridModel?.cellForPosition(index, y: index)
        
        guard let cell = gridCell else {
            XCTAssertNotNil(gridCell, "cell should not be nil for selected index")
            return
        }
        
        let cells = gridModel?.neighboursFor(cell, with: .live)

        XCTAssertNotNil(cells, "Live nighbours should not be nil")

        let expectedLiveNighbours : [Position] = [Position(x: 1, y: 1),
                                              Position(x: 1, y: 3),
                                              Position(x: 3, y: 1),
                                              Position(x: 3, y: 3)]
        
        XCTAssertEqual(expectedLiveNighbours.count, cells?.count, "Incorrect expected live nighbours")

        
        
        let resultantCells = cells?.filter({ (cell) -> Bool in
            (expectedLiveNighbours.filter({ (position) -> Bool in
                (position.x == cell.position.x && position.y == cell.position.y && cell.state == .live)
            }).first != nil)
        })
        
        XCTAssertEqual(resultantCells?.count, cells?.count, "Incorrect resultant live nighbours")
        
    }
    
    func testDeadStateNighboursForCell() {
        let index = Int(ceil(Double((gridSize-1)/2)))
        
        let gridCell = gridModel?.cellForPosition(index, y: index)
        
        guard let cell = gridCell else {
            XCTAssertNotNil(gridCell, "cell should not be nil for selected index")
            return
        }
        
        let cells = gridModel?.neighboursFor(cell, with: .dead)
        
        XCTAssertNotNil(cells, "Dead nighbours should not be nil")
        
        let expectedLiveNighbours : [Position] = [Position(x: 1, y: 2),
                                                  Position(x: 2, y: 1),
                                                  Position(x: 2, y: 3),
                                                  Position(x: 3, y: 2)]
        
        XCTAssertEqual(expectedLiveNighbours.count, cells?.count, "Incorrect expected dead nighbours")
        

        let resultantCells = cells?.filter({ (cell) -> Bool in
            (expectedLiveNighbours.filter({ (position) -> Bool in
                (position.x == cell.position.x && position.y == cell.position.y && cell.state == .dead)
            }).first != nil)
        })
        
        XCTAssertEqual(resultantCells?.count, cells?.count, "Incorrect resultant dead nighbours")
        
    }
    
    func testPerminantlyDeadStateNighboursForCell() {
        let index = Int(ceil(Double((gridSize-1)/2)))
        
        let gridCell = gridModel?.cellForPosition(index, y: index)
        
        guard let cell = gridCell else {
            XCTAssertNotNil(gridCell, "cell should not be nil for selected index")
            return
        }
        
        let cells = gridModel?.neighboursFor(cell, with: .perminantlyDead)
        
        XCTAssertTrue((cells?.isEmpty)!, "Nighbours should be nil")
    }
    
    func testOneStepForward() {
        
        /*
                Make a first move
        */
        
        gridModel?.triggerNextStep()
        
        /*
         
         Expected out come
         
         | 0 | 0 | 0 | 0 | 0 |
         ---------------------
         | 0 | 1 | 1 | 1 | 0 |
         ---------------------
         | 0 | 1 | 0 | 1 | 0 |
         ---------------------
         | 0 | 1 | 1 | 1 | 0 |
         ---------------------
         | 0 | 0 | 0 | 0 | 0 |
         
         */
        
        let livingCells = gridModel?.cells.filter{ $0.state == .live }
        
        let deadCells = gridModel?.cells.filter{ $0.state == .dead }
        
        let perminantlyDeadCells = gridModel?.cells.filter{ $0.state == .perminantlyDead }
        
        XCTAssertTrue((perminantlyDeadCells?.isEmpty)!, "There should be no Perminantly Dead Cells after first move")

        let expectedDeadPositions : [Position] = [Position(x: 0, y: 0),
                                                  Position(x: 0, y: 1),
                                                  Position(x: 0, y: 2),
                                                  Position(x: 0, y: 3),
                                                  Position(x: 0, y: 4),
                                                  
                                                  Position(x: 1, y: 0),
                                                  Position(x: 1, y: 4),
                                                  
                                                  Position(x: 2, y: 0),
                                                  Position(x: 2, y: 2),
                                                  Position(x: 2, y: 4),
                                                  
                                                  Position(x: 3, y: 0),
                                                  Position(x: 3, y: 4),
                                                  
                                                  Position(x: 4, y: 0),
                                                  Position(x: 4, y: 1),
                                                  Position(x: 4, y: 2),
                                                  Position(x: 4, y: 3),
                                                  Position(x: 4, y: 4)]
        
        
        let expectedLivePositions : [Position] = [Position(x: 1, y: 1),
                                                  Position(x: 1, y: 2),
                                                  Position(x: 1, y: 3),
                                                  
                                                  Position(x: 2, y: 1),
                                                  Position(x: 2, y: 3),
                                                  
                                                  Position(x: 3, y: 1),
                                                  Position(x: 3, y: 2),
                                                  Position(x: 3, y: 3)]
        
        
        let reultingLiveCells = livingCells?.filter({ (cell) -> Bool in
            (expectedLivePositions.filter({
                ($0.x == cell.position.x && $0.y == cell.position.y && cell.state == .live)
            }).first != nil)
        })
        
        XCTAssertEqual(reultingLiveCells?.count, livingCells?.count, "Incorrect resultant live cells")
        
        XCTAssertEqual(reultingLiveCells?.count, expectedLivePositions.count, "Incorrect expected live cells")
        
        let reultingDeadCells = deadCells?.filter({ (cell) -> Bool in
            (expectedDeadPositions.filter({
                ($0.x == cell.position.x && $0.y == cell.position.y && cell.state == .dead)
            }).first != nil)
        })
        
        XCTAssertEqual(reultingDeadCells?.count, deadCells?.count, "Incorrect resultant dead cells")
        
        XCTAssertEqual(expectedDeadPositions.count, reultingDeadCells?.count, "Incorrect expected dead cells")
        
        /*
         
        gridModel?.cells.filter({ (cell) -> Bool in
            print("Cell : Position: \(cell.position),  state: \(cell.state)")
            return false
        })
         
         */
        
    }
    
}
