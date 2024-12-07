//
//  GameTimerNode.swift
//  circle_snap
//
//  Created by Mario Lopez on 12/6/24.
//

import SpriteKit

class GameTimerNode: SKLabelNode {
    init(timeRemaining: Int) {
        super.init()
        self.fontName = "Arial-BoldMT"
        self.fontSize = 25
        self.fontColor = .white
        self.text = "Time Remaining: \(timeRemaining)"
        self.horizontalAlignmentMode = .center
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateTime(to newTime: Int) {
        self.text = "Time Remaining: \(newTime)"
    }
}
