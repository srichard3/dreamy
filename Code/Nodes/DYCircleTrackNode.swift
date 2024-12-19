//
//  DYCircleTrackNode.swift
//  circle_snap
//
//  Created by Duy Nguyen on 12/7/24.
//


import SpriteKit

class DYCircleTrackNode: SKShapeNode {
    
    private var originalStrokeColor: UIColor!
    private var redColor: UIColor = UIColor(hex: "#F3504C").withAlphaComponent(0.8)
    
    init(radius: CGFloat, lineWidth: CGFloat, color: SKColor) {
        super.init()
        
        self.originalStrokeColor = color.withAlphaComponent(0.8)
        self.strokeColor = originalStrokeColor
        self.lineWidth = lineWidth
        
        let path = CGMutablePath()
        path.addArc(center: .zero, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: false)
        self.path = path

        addBackgroundCircle(radius: radius, mainLineWidth: lineWidth)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addBackgroundCircle(radius: CGFloat, mainLineWidth: CGFloat) {
        let adjustedStrokeWidth = mainLineWidth * 0.12
        let adjustedLineWidth = mainLineWidth + (adjustedStrokeWidth * 2)
        let adjustedRadius = radius
        
        let backgroundPath = CGMutablePath()
        backgroundPath.addArc(center: .zero, radius: adjustedRadius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: false)
        
        let backgroundCircle = SKShapeNode(path: backgroundPath)
        backgroundCircle.strokeColor = .black
        backgroundCircle.lineWidth = adjustedLineWidth
        backgroundCircle.zPosition = -1
        
        addChild(backgroundCircle)
    }
    

    func animateIncorrectTap(completion: (() -> Void)? = nil) {
        let colorizeToRed = SKAction.run {
            self.strokeColor = self.redColor
        }
        let colorizeBack = SKAction.run {
            self.strokeColor = self.originalStrokeColor
        }
        let wait = SKAction.wait(forDuration: 0.025)
        
        let sequence = SKAction.sequence([colorizeToRed, wait, colorizeBack, wait])
        let flash = SKAction.repeat(sequence, count: 5)
        
        if let completion = completion {
            let runCompletion = SKAction.run {
                completion()
            }
            let fullSequence = SKAction.sequence([flash, colorizeToRed, runCompletion])
            self.run(fullSequence)
        } else {
            self.run(flash)
        }
    }
}
