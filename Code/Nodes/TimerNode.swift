//
//  TimerNode.swift
//  circle_snap
//
//  Created by Mario Lopez on 12/9/24.
//

import SpriteKit
class TimerNode: SKLabelNode {
    private var timer: Timer?
    private(set) var remainingTime: Double = 5.0
    
    var onTimerEnd: (() -> Void)?
    
    override init() {
        super.init()
        self.fontName = "Helvetica-Bold"
        self.fontSize = 40
        self.fontColor = .white
        self.text = "\(Int(remainingTime))"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startCountdown() {
        stopCountdown() // Ensure no existing timer
        remainingTime = 5.0
        text = "\(Int(remainingTime))"
        fontColor = .white // Reset color to white
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.remainingTime -= 1.0
            self.text = "\(max(0, Int(self.remainingTime)))"
            self.updateTextColor() // Update color
            self.applyWiggleEffect() // Apply wiggle
            
            if self.remainingTime <= 0 {
                self.stopCountdown()
                self.onTimerEnd?()
            }
        }
    }
    
    func resetCountdown() {
        remainingTime = 5.0
        text = "\(Int(remainingTime))"
        fontColor = .white // Reset color to white
    }
    
    func stopCountdown() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updateTextColor() {
        // Interpolate color from white (at 5) to red (at 0)
        let progress = 1.0 - (remainingTime / 5.0) // Normalize remaining time to range 0-1
        let white = UIColor.white
        let red = UIColor.red
        fontColor = interpolateColor(from: white, to: red, progress: progress)
    }
    
    private func applyWiggleEffect() {
        // Calculate wiggle intensity based on remaining time (stronger as time decreases)
        let intensity = CGFloat(1.0 - (remainingTime / 5.0)) // Ranges from 0 (at 5) to 1 (at 0)
        let wiggleAmount = intensity * 10.0 // Max wiggle of 10 points
        
        // Create wiggle animation
        let moveLeft = SKAction.moveBy(x: -wiggleAmount, y: 0, duration: 0.05)
        let moveRight = SKAction.moveBy(x: wiggleAmount * 2, y: 0, duration: 0.1)
        let moveBack = SKAction.moveBy(x: -wiggleAmount, y: 0, duration: 0.05)
        let wiggleSequence = SKAction.sequence([moveLeft, moveRight, moveBack])
        
        // Scale animation to emphasize intensity
        let scaleUp = SKAction.scale(to: 1.0 + (intensity * 0.1), duration: 0.05)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.05)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        
        // Combine move and scale animations
        let wiggleGroup = SKAction.group([wiggleSequence, scaleSequence])
        
        // Run the wiggle animation
        self.run(wiggleGroup)
    }
    
    private func interpolateColor(from startColor: UIColor, to endColor: UIColor, progress: CGFloat) -> UIColor {
        var startRed: CGFloat = 0, startGreen: CGFloat = 0, startBlue: CGFloat = 0, startAlpha: CGFloat = 0
        var endRed: CGFloat = 0, endGreen: CGFloat = 0, endBlue: CGFloat = 0, endAlpha: CGFloat = 0
        
        startColor.getRed(&startRed, green: &startGreen, blue: &startBlue, alpha: &startAlpha)
        endColor.getRed(&endRed, green: &endGreen, blue: &endBlue, alpha: &endAlpha)
        
        let red = startRed + (endRed - startRed) * progress
        let green = startGreen + (endGreen - startGreen) * progress
        let blue = startBlue + (endBlue - startBlue) * progress
        let alpha = startAlpha + (endAlpha - startAlpha) * progress
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
