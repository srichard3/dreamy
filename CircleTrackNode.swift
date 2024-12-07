//
//  CircleTrackNode.swift
//  circle_snap
//
//  Created by Mario Lopez on 12/6/24.
//

import SpriteKit

class CircleTrackNode: SKShapeNode {
    init(radius: CGFloat) {
        super.init()
        self.path = CGPath(ellipseIn: CGRect(x: -radius, y: -radius, width: 2 * radius, height: 2 * radius), transform: nil)
        self.strokeColor = .white
        self.lineWidth = 45
        self.alpha = 0.8
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
