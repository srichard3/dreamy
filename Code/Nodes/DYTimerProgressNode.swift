//
//  DYTimerProgressNode.swift
//  circle_snap
//
//  Created by Sam Richard on 12/18/24.
//


import SpriteKit

class DYTimerProgressNode: SKShapeNode {
    private var totalTime: Double = 5.0
    private var elapsedTime: Double = 0.0
    private var timer: Timer?
    private var radius: CGFloat!
    
    var onTimerEnd: (() -> Void)?
    
    let startColor: UIColor = .white
    let endColor: UIColor = UIColor(hex: "#F3504C")
    
    let colorStartThreshold: CGFloat = 0.5
    let colorEndThreshold: CGFloat = 0.3
    
    init(radius: CGFloat, lineWidth: CGFloat, totalTime: CGFloat) {
        super.init()
        
        self.totalTime = totalTime
        self.elapsedTime = 0.0
        
        let adjustedStrokeWidth = lineWidth * 0.12
        self.lineWidth = adjustedStrokeWidth
        self.strokeColor = startColor
        self.fillColor = .clear
        self.zPosition = 1
        
        let adjustedLineWidth = lineWidth + (adjustedStrokeWidth * 2)
        let x = adjustedLineWidth / 2
        self.radius = radius - x
        self.path = createPath(progress: 1.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startCountdown() {
        stopCountdown()
        elapsedTime = 0.0
        updatePath()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
    }
    
    func resetCountdown() {
        elapsedTime = 0.0
        updatePath()
        timer?.invalidate()
        timer = nil
        startCountdown()
    }
    
    func stopCountdown() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updateTimer() {
        elapsedTime += 0.016
        
        let progress = max(0.0, 1.0 - (elapsedTime / totalTime))
        updatePath(progress: progress)
        
        if elapsedTime >= totalTime {
            stopCountdown()
            onTimerEnd?()
        }
    }
    
    private func updatePath(progress: Double = 1.0) {
        let currentProgress = CGFloat(progress)
        let newPath = createPath(progress: Double(currentProgress))
        self.path = newPath
        
        self.strokeColor = colorForProgress(progress: currentProgress)
    }
    
    private func createPath(progress: Double) -> CGPath {
        let startAngle = -CGFloat.pi / 2
        let endAngle = startAngle + CGFloat(progress * 2 * Double.pi)
        
        let path = CGMutablePath()
        path.addArc(center: .zero, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        return path
    }
    
    private func colorForProgress(progress: CGFloat) -> UIColor {
        if progress > colorStartThreshold {
            return startColor
        } else if progress > colorEndThreshold {
            let normalizedProgress = (progress - colorEndThreshold) / (colorStartThreshold - colorEndThreshold)
            return interpolateColor(from: startColor, to: endColor, progress: 1.0 - normalizedProgress)
        } else {
            return endColor
        }
    }
    
    private func interpolateColor(from startColor: UIColor, to endColor: UIColor, progress: CGFloat) -> UIColor {
        var startRed: CGFloat = 0
        var startGreen: CGFloat = 0
        var startBlue: CGFloat = 0
        var startAlpha: CGFloat = 0
        startColor.getRed(&startRed, green: &startGreen, blue: &startBlue, alpha: &startAlpha)
        
        var endRed: CGFloat = 0
        var endGreen: CGFloat = 0
        var endBlue: CGFloat = 0
        var endAlpha: CGFloat = 0
        endColor.getRed(&endRed, green: &endGreen, blue: &endBlue, alpha: &endAlpha)
        
        let red = startRed + (endRed - startRed) * progress
        let green = startGreen + (endGreen - startGreen) * progress
        let blue = startBlue + (endBlue - startBlue) * progress
        let alpha = startAlpha + (endAlpha - startAlpha) * progress
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    func setTotalTime(_ newTotalTime: Double) {
        self.totalTime = newTotalTime
        self.elapsedTime = 0.0
        updatePath(progress: 1.0)
    }
}
