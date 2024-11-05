import SwiftUI
import Combine

// ViewModel to manage the game's state and logic, including the timer and game actions.
class CSViewModel: ObservableObject {
    @Published var gameState = GameState() // Observable game state object to manage UI updates
    private var timer: AnyCancellable? // Timer to manage animation cycle
    private let angleTolerance: Double // Tolerance for alignment detection

    // Debug properties to visualize the start and end angles for the active zone
    var debugStartAngle: Double { normalizeAngle(gameState.randomNodeAngle - angleTolerance) }
    var debugEndAngle: Double { normalizeAngle(gameState.randomNodeAngle + angleTolerance) }
    
    // Initializes the ViewModel and calculates angle tolerance for determining successful taps.
    init() {
        self.angleTolerance = Self.calculateAngleTolerance()
    }
    
    func onAppear() {
        startRotation()
    }
    
    // Calculates the tolerance angle based on the radius of the node and circle.
    private static func calculateAngleTolerance() -> Double {
        return ((Double(GameConstants.nodeRadius) / Double(GameConstants.circleRadius)) * 180 / .pi) * 1.75
    }
    
    // Starts the rotation animation timer, updating `progress` based on elapsed time.
    private func startRotation() {
        let startTime = Date()
        timer = Timer.publish(every: GameConstants.timerInterval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                let elapsedTime = Date().timeIntervalSince(startTime)
                let cycleProgress = elapsedTime.truncatingRemainder(dividingBy: GameConstants.animationSpeed) / GameConstants.animationSpeed
                self.gameState.progress = cycleProgress // Update animation progress
                self.gameState.isGlowing = self.isRectangleInRange() // Set glowing effect based on alignment
            }
    }
    
    // Checks if the rotating rectangle is within the success range of the node's angle.
    private func isRectangleInRange() -> Bool {
        let normalizedProgress = normalizeAngle(gameState.progress * 360)
        let startAngle = debugStartAngle
        let endAngle = debugEndAngle
        
        // Determines if the progress angle falls within the specified tolerance range
        return startAngle < endAngle
            ? normalizedProgress >= startAngle && normalizedProgress <= endAngle
            : normalizedProgress >= startAngle || normalizedProgress <= endAngle
    }
    
    // calls success or failure handlers based on alignment.
    func handleTap() {
        if isRectangleInRange() {
            handleSuccessfulTap()
        } else {
            handleFailedTap()
        }
    }
    
    // Handles a successful tap, triggering animations and updating the node position.
    private func handleSuccessfulTap() {
        gameState.lastClickProgress = gameState.progress // Store click position for feedback
        
        withAnimation(.easeIn(duration: GameConstants.scaleAnimationDuration)) {
            gameState.scale = 0.0 // Shrinks the node temporarily for feedback effect
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + GameConstants.scaleAnimationDuration) {
            self.gameState.randomNodeAngle = Double.random(in: 0..<360) // Reposition node
            withAnimation(.easeOut(duration: GameConstants.scaleAnimationDuration)) {
                self.gameState.scale = 1.0 // Restore the node's scale
            }
        }
    }
    
    // Handles a failed tap, triggering a shaking animation to indicate incorrect alignment.
    private func handleFailedTap() {
        withAnimation(Animation.easeInOut(duration: GameConstants.shakeDuration).repeatCount(3, autoreverses: true)) {
            gameState.scale = 0.95 // Shrinks slightly
            gameState.shakeOffset = 10 // Adds offset to simulate shake
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation {
                self.gameState.scale = 1.0 // Restore to original size
                self.gameState.shakeOffset = 0 // Reset offset after shake
            }
        }
    }
    
    // Normalizes an angle to fall within the 0-360° range.
    private func normalizeAngle(_ angle: Double) -> Double {
        var normalized = angle.truncatingRemainder(dividingBy: 360)
        if normalized < 0 { normalized += 360 }
        return normalized
    }
    
    // Cancels the timer when the ViewModel is deinitialized.
    deinit {
        timer?.cancel()
    }
}
