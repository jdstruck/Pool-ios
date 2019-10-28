//
//  Player.swift
//  Pool-ios
//
//  Created by Jesse Struck on 10/14/19.
//  Copyright © 2019 Jesse Struck. All rights reserved.
//

import Foundation

class Player {
    let name : String
    var _score : Int
    var score : Int {
        get {return self._score}
        set(newValue) {self._score = newValue}

    }
    
    init() {
        self.name = ""
        self._score = 0
    }
    init(name: String, score: Int) {
        self.name = name
        self._score = score
    }
}
