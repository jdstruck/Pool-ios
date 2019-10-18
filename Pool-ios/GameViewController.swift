//
//  GameViewController.swift
//  Asteriods
//
//  Created by Jesse Struck on 9/24/19.
//  Copyright © 2019 Jesse Struck. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as! SKView? {
            view.ignoresSiblingOrder = true
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                let gameScene : GameScene! = scene as? GameScene
                gameScene!.gameViewController = self
                // Present the scene
                view.presentScene(scene)
            }
            
            
            //scene.gameViewController = self
            
            view.ignoresSiblingOrder = true
            
//            view.showsFPS = false
//            view.showsNodeCount = false
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func gameOver() {
        print("game over")
        let gameOverViewController = storyboard!.instantiateViewController(withIdentifier: "game_over")
        self.navigationController?.pushViewController(gameOverViewController, animated: true)
    }
}
