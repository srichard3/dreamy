//
//  TargetNode.swift
//  circle_snap
//
//  Created by Duy Nguyen on 12/7/24.
//

import SpriteKit

class TargetNode: SKShapeNode {
    init(angle: CGFloat, scale: CGFloat, offset: CGFloat, isGlowing: Bool) {
        super.init()
        self.path = CGPath(ellipseIn: CGRect(x: -25, y: -25, width: 50, height: 50), transform: nil)
        self.fillColor = .red
        self.position = CGPoint(
            x: offset * cos(angle),
            y: offset * sin(angle)
        )
        self.setScale(scale)
        if isGlowing {
            self.glowWidth = 10
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
