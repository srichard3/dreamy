//
//  ConditionNode.swift
//  circle_snap
//
//  Created by Duy Nguyen on 12/7/24.
//

import SpriteKit

class ConditionNode: SKShapeNode {
    var weather: ConditionType
    var startAngle: CGFloat
    var trackWidth: CGFloat
    var radius: CGFloat

    init(weather: ConditionType, startAngle: CGFloat, radius: CGFloat, trackWidth: CGFloat = 45) {
        self.weather = weather
        self.startAngle = startAngle
        self.radius = radius
        self.trackWidth = trackWidth

        super.init()

        // Set up the initial arc shape path
        self.path = createArcPath()
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
        let endAngleRadians = (startAngle + GameConstants.conditionPatchSize) * .pi / 180

        path.addArc(
            center: center,
            radius: radius,
            startAngle: startAngleRadians,
            endAngle: endAngleRadians,
            clockwise: false
        )

        return path
    }

    // Method to update the appearance dynamically
    func updateAppearance(gameContext: CSGameContext) {
        self.weather = gameContext.currentCondition
        self.startAngle = CGFloat(gameContext.conditionPatchStartAngle)
        self.path = createArcPath()
        self.strokeColor = weatherColor()
    }

    // Determine the stroke color based on weather type
    private func weatherColor() -> SKColor {
        switch weather {
        case .wind:
            return .white
        case .sand:
            return .yellow
        case .ice:
            return .cyan
        case .fog:
            return .gray
        case .none:
            return .clear
        }
    }
}
