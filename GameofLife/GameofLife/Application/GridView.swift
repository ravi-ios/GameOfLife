//
//  GridView.swift
//  GameofLife
//
//  Created by RAVI on 10/04/18.
//  Copyright © 2018 RAVI. All rights reserved.
//

import UIKit

final class GridView: UIView {
    
    let viewModel: GridViewModel
    
    init(viewModel: GridViewModel) {
        self.viewModel = viewModel
        super.init(frame: CGRect.zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        /*
         * Configure UI
         */
        
        let context = UIGraphicsGetCurrentContext()
        let dimensions = CGFloat(self.viewModel.gridSize)
        let size = CGSize(width: self.bounds.width / dimensions, height: self.bounds.height / dimensions)
        
        for cell in viewModel.cells {
            context!.setFillColor(cell.state.color().cgColor)
            context!.addRect(cell.frameWith(size: size))
            context!.fillPath()
        }
    }
}
