//
//  CSView.swift
//  circle_snap
//
//  Created by Duy Nguyen on 11/4/24.
//

import SwiftUI
import Combine


class CSViewModel: ObservableObject {
    @Published var gameState = GameState()
    private var timer: AnyCancellable?
    private let angleTolerance: Double
    
    // Debug properties
    var debugStartAngle: Double { normalizeAngle(gameState.randomNodeAngle - angleTolerance) }
    var debugEndAngle: Double { normalizeAngle(gameState.randomNodeAngle + angleTolerance) }
    
    init() {
        self.angleTolerance = Self.calculateAngleTolerance()
    }
    
    func onAppear() {
        startRotation()
    }
    
    private static func calculateAngleTolerance() -> Double {
        return ((Double(GameConstants.nodeRadius) / Double(GameConstants.circleRadius)) * 180 / .pi) * 1.75
    }
    
    private func startRotation() {
        let startTime = Date()
        timer = Timer.publish(every: GameConstants.timerInterval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                let elapsedTime = Date().timeIntervalSince(startTime)
                let cycleProgress = elapsedTime.truncatingRemainder(dividingBy: GameConstants.animationSpeed) / GameConstants.animationSpeed
                self.gameState.progress = cycleProgress
                self.gameState.isGlowing = self.isRectangleInRange()
            }
    }
    
    private func isRectangleInRange() -> Bool {
        let normalizedProgress = normalizeAngle(gameState.progress * 360)
        let startAngle = debugStartAngle
        let endAngle = debugEndAngle
        
        return startAngle < endAngle
            ? normalizedProgress >= startAngle && normalizedProgress <= endAngle
            : normalizedProgress >= startAngle || normalizedProgress <= endAngle
    }
    
    func handleTap() {
        if isRectangleInRange() {
            handleSuccessfulTap()
        } else {
            handleFailedTap()
        }
    }
    
    private func handleSuccessfulTap() {
        gameState.lastClickProgress = gameState.progress
        
        withAnimation(.easeIn(duration: GameConstants.scaleAnimationDuration)) {
            gameState.scale = 0.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + GameConstants.scaleAnimationDuration) {
            self.gameState.randomNodeAngle = Double.random(in: 0..<360)
            withAnimation(.easeOut(duration: GameConstants.scaleAnimationDuration)) {
                self.gameState.scale = 1.0
            }
        }
    }
    
    private func handleFailedTap() {
        withAnimation(Animation.easeInOut(duration: GameConstants.shakeDuration).repeatCount(3, autoreverses: true)) {
            gameState.scale = 0.95
            gameState.shakeOffset = 10
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation {
                self.gameState.scale = 1.0
                self.gameState.shakeOffset = 0
            }
        }
    }
    
    private func normalizeAngle(_ angle: Double) -> Double {
        var normalized = angle.truncatingRemainder(dividingBy: 360)
        if normalized < 0 { normalized += 360 }
        return normalized
    }
    
    deinit {
        timer?.cancel()
    }
}
