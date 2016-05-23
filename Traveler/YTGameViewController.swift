//
//  YTGameViewController.swift
//  Traveler
//
//  Created by Ashutosh on 5/22/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit
import SpriteKit

class YTGameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = YTGameScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.presentScene(scene)
    }

    override func loadView() {
        self.view = SKView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
    }
}
