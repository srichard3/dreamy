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
    var radius: CGFloat
    var trackWidth: CGFloat

    init(weather: ConditionType, startAngle: CGFloat, radius: CGFloat, trackWidth: CGFloat = 45) {
        self.weather = weather
        self.startAngle = startAngle
        self.radius = radius
        self.trackWidth = trackWidth

        super.init()

        // Set up the initial arc path and appearance
        self.path = createArcPath()
        self.strokeColor = weatherColor()
        self.fillColor = self.strokeColor // Match fill color to stroke color
        self.lineWidth = trackWidth + 2
        self.lineCap = .butt // Ensure flat ends for the arc
//        self.alpha = 0.2
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    private func createArcPath() -> CGPath {
        let path = CGMutablePath()
        let center = CGPoint(x: 0, y: 0) // Center of the arc
        let innerRadius = radius // Inner edge of the arc
        let outerRadius = radius// Outer edge of the arc

        let startAngleRadians = (startAngle - GameConstants.conditionPatchSize)  * .pi / 180
        let endAngleRadians = startAngle * .pi / 180

        // Outer arc
        path.addArc(center: center,
                    radius: outerRadius,
                    startAngle: startAngleRadians,
                    endAngle: endAngleRadians,
                    clockwise: false)
        // Inner arc (reverse direction to close the path)
        path.addArc(center: center,
                    radius: innerRadius,
                    startAngle: endAngleRadians,
                    endAngle: startAngleRadians,
                    clockwise: true)
        

        path.closeSubpath()

        return path
    }


    // Determine the stroke color based on the weather condition
    private func weatherColor() -> SKColor {
        switch weather {
        case .wind:
            return .blue
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

    // Update the arc path and appearance when the condition changes
    func updateAppearance(startAngle: CGFloat, weather: ConditionType) {
        self.startAngle = startAngle
        self.weather = weather
        self.path = createArcPath()
        self.strokeColor = weatherColor()
        self.fillColor = self.strokeColor // Ensure fill color matches stroke color
    }
}
