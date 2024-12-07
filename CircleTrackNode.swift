//
//  CircleTrackNode.swift
//  circle_snap
//
//  Created by Mario Lopez on 12/6/24.
//

import SpriteKit


class CircleTrackNode: SKShapeNode {
    // Custom initializer
    init(radius: CGFloat, lineWidth: CGFloat, color: SKColor) {
        super.init()

        // Define the circular path
        let path = CGMutablePath()
        path.addArc(center: .zero, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: false)
        self.path = path

        // Configure the stroke
        self.strokeColor = color.withAlphaComponent(0.8)
        self.lineWidth = lineWidth

        // Optional: Add effects like glow or shadow
        self.glowWidth = 5.0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
