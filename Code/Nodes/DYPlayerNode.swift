//
//  DYPlayerNode.swift
//  circle_snap
//
//  Created by Duy Nguyen on 12/7/24.
//

import SpriteKit

class DYPlayerNode: SKNode {
    private let circleRadius: CGFloat
    private let indicator: SKShapeNode

    init(circleRadius: CGFloat, circleTrackLineWidth: CGFloat) {
        self.circleRadius = circleRadius
        self.indicator = SKShapeNode(rectOf: CGSize(width: circleTrackLineWidth * 0.4, height: circleTrackLineWidth * 0.9), cornerRadius: circleTrackLineWidth * 0.2)
        super.init()
        
        indicator.fillColor = UIColor(hex: "#F3504C")
        indicator.lineWidth = circleRadius * 2/150
        indicator.strokeColor = .black
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
