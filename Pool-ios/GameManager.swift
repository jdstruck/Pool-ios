//
//  GameManager.swift
//  Pool-ios
//
//  Created by Jesse Struck on 10/27/19.
//  Copyright © 2019 Jesse Struck. All rights reserved.
//

import Foundation

class GameManager {
    static let gameInstance = GameManager()
    
    static var currentPlayer : Player = Player()
    static var players : [Player] = [Player(), Player()]
    static var leaderboard : [String: Int] = [:]
    
    private init(){}
    
    func swapPlayers() {
        print(GameManager.currentPlayer.name)
        if GameManager.currentPlayer === GameManager.players[0] {
            GameManager.currentPlayer = GameManager.players[1]
        } else {
            GameManager.currentPlayer = GameManager.players[0]
        }
    }
    
    func gameOver() {
        GameManager.currentPlayer.score += 1
        GameManager.leaderboard.updateValue(GameManager.currentPlayer.score, forKey: GameManager.currentPlayer.name)
        GameManager.gameInstance.swapPlayers()
    }
    
    func highScore() -> String {
        var p : Player
        if (GameManager.players[0].score > GameManager.players[1].score) {
            p = GameManager.players[0]
        } else {
            p = GameManager.players[1]
        }
        return "\(p.name) \(p.score)"
    }
}
