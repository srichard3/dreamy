//
//  MovingIndicatorNode.swift
//  circle_snap
//
//  Created by Duy Nguyen on 12/7/24.
//

import SpriteKit

class MovingIndicatorNode: SKNode {
    private let circleRadius: CGFloat
    private let indicator: SKShapeNode

    init(circleRadius: CGFloat) {
        self.circleRadius = circleRadius
        self.indicator = SKShapeNode(rectOf: CGSize(width: 20, height: 48), cornerRadius: 10)
        super.init()
        
        indicator.fillColor = SKColor(named: "movingIndicator")!
        indicator.lineWidth = 0
        addChild(indicator)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(progress: Double) {
        let angle = progress * 2 * .pi - .pi / 2
        let x = circleRadius * cos(angle)
        let y = circleRadius * sin(angle)
        indicator.position = CGPoint(x: x, y: y)
        indicator.zRotation = CGFloat(angle)
    }
}
