//
//  ViewController.swift
//  GameofLife
//
//  Created by RAVI on 10/04/18.
//  Copyright © 2018 RAVI. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let gridView: GridView
    let viewModel: GridViewModel
    var timer: Timer?
    let gridSize: Int = 25
    let moveInterval = 0.8
    
    required init?(coder aDecoder: NSCoder) {

        viewModel = GridViewModel.init(gridsize: gridSize)
        gridView = GridView.init(viewModel: viewModel)
        
        super.init(coder: aDecoder)
        self.generateDiagonalPattrn()
        
//        self.generateRandomPattrn()
        
        /*
         * Feel free to use any pattrn
         */
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         * Initializing Grid,
         */
        
        let margin: CGFloat = 20.0
        let height = view.frame.width - margin * 2.0
        let y = (view.frame.height - height) / 2.0
        
        gridView.frame = CGRect(x: margin, y: y, width: height, height: height)
        gridView.layer.borderColor = UIColor.darkGray.cgColor
        gridView.layer.borderWidth = 2.0
        view.addSubview(gridView)
        
        timer = Timer.scheduledTimer(timeInterval: moveInterval, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    func generateRandomPattrn() {
        
        func randLocation () -> Int {
            return Int(arc4random()) % viewModel.gridSize
        }

        let randomNumber = (gridSize*gridSize)/2
        for _ in 0...randomNumber {
            let x = randLocation(), y = randLocation()
            viewModel[x, y]?.state = .live
        }
    }
    
    func generateDiagonalPattrn() {
        for index in 0..<gridSize {
            viewModel[index, index]?.state = .live
            viewModel[index, (gridSize - 1) - index]?.state = .live
        }
    }
    
    @objc func fireTimer() {
        
        /*
         * Make a move at specified time interval else we do not know what is happening on UI
         */
        viewModel.triggerNextStep()
        gridView.setNeedsDisplay()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
