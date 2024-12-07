//
//  ScoreNode.swift
//  circle_snap
//
//  Created by Mario Lopez on 12/6/24.
//

import SpriteKit

class ScoreNode: SKLabelNode {
    init(score: Int) {
        super.init()
        self.fontName = "Arial-BoldMT"
        self.fontSize = 30
        self.fontColor = .white
        self.text = "\(score)"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateScore(to newScore: Int) {
        self.text = "\(newScore)"
    }
}
