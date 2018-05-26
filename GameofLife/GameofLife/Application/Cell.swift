//
//  Cell.swift
//  GameofLife
//
//  Created by RAVI on 10/04/18.
//  Copyright © 2018 RAVI. All rights reserved.
//

import Foundation
import UIKit

enum State {
    case live
    case dead
    case perminantlyDead
    
    func color() -> UIColor {
        switch self {
        case .live:
            return .white
        case .dead:
            return .black
        case .perminantlyDead:
            return .red
        }
    }
}

struct Position {
    var x: Int
    var y: Int
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

final class Cell: NSObject {
    
    let position: Position
    var state: State
    var nighbours: [Cell]?
    
    init(x: Int, y: Int) {
        /*
         * Initialize all the cells in grid with postion in a matrix form along with Dead status,
         */
        self.position = Position.init(x: x, y: y)
        self.state = .dead
    }
    
    func frameWith(size: CGSize ) -> CGRect {
        let x = CGFloat(self.position.x) * size.width
        let y = CGFloat(self.position.y) * size.height
        let height = size.height
        let width = size.width
        return CGRect(x: x, y: y, width: height, height: width)
    }
}
