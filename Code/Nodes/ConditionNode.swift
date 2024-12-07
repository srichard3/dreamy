//
//  ConditionNode.swift
//  circle_snap
//
//  Created by Duy Nguyen on 12/7/24.
//

import SpriteKit

class ConditionNode: SKShapeNode {
    let weather: ConditionType
    let startAngle: CGFloat
    let size: CGFloat
    let trackWidth: CGFloat
    let radius: CGFloat
    
    init(weather: ConditionType, startAngle: CGFloat, size: CGFloat, radius: CGFloat, trackWidth: CGFloat = 45) {
        self.weather = weather
        self.startAngle = startAngle
        self.size = size
        self.radius = radius
        self.trackWidth = trackWidth
        
        super.init()
        
        // Create the arc shape path
        let path = createArcPath()
        self.path = path
        self.strokeColor = weatherColor()
        self.lineWidth = trackWidth
        self.alpha = 0.8
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Method to create the arc path
    private func createArcPath() -> CGPath {
        let path = CGMutablePath()
        let center = CGPoint(x: 0, y: 0)  // The center is at the node's position
        let startAngleRadians = startAngle * .pi / 180
        let endAngleRadians = (startAngle + size) * .pi / 180
        
        path.addArc(
            center: center,
            radius: radius,
            startAngle: startAngleRadians,
            endAngle: endAngleRadians,
            clockwise: false
        )
        
        return path
    }
    
    // Weather color based on the weather type
    private func weatherColor() -> SKColor {
        switch weather {
        case .wind:
            return .white
        case .sand:
            return .green
        case .ice:
            return .cyan
        case .fog:
            return .gray
        case .none:
            return .clear
        }
    }
}
