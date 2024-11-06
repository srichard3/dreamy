import SwiftUI
import Combine

// ViewModel to manage the game's state and logic, including the timer and game actions.
class CSViewModel: ObservableObject {
    @Published var gameState = GameState() // Observable game state object to manage UI updates
    @Published var gameStatus: GameStatus = .notStarted
    private var rotationTimer: AnyCancellable?
    private var countdownTimer: AnyCancellable?
    private let angleTolerance: Double // Tolerance for alignment detection
    private var displayLink: CADisplayLink? // CADisplayLink for syncing with screen refresh rate
        private var startTime: CFTimeInterval? // Track the start time of the animation
        
    
    // Debug properties to visualize the start and end angles for the active zone
    var debugStartAngle: Double { normalizeAngle(gameState.randomNodeAngle - angleTolerance) }
    var debugEndAngle: Double { normalizeAngle(gameState.randomNodeAngle + angleTolerance) }
    
    // Initializes the ViewModel and calculates angle tolerance for determining successful taps.
    init() {
        self.angleTolerance = Self.calculateAngleTolerance()
    }
    
    func onAppear() {
        startRotation()
        startCountdown()
    }
    
    
    // Calculates the tolerance angle based on the radius of the node and circle.
    private static func calculateAngleTolerance() -> Double {
        return ((Double(GameConstants.nodeRadius) / Double(GameConstants.circleRadius)) * 180 / .pi) * 1.75
    }
    
    
    // Starts the rotation animation timer, updating `progress` based on elapsed time.
    private func startRotation() {
        startTime = CACurrentMediaTime() // Track the start time when rotation begins
        displayLink = CADisplayLink(target: self, selector: #selector(updateRotation))
        displayLink?.add(to: .current, forMode: .common)
    }
    
    // Called by CADisplayLink to update the game state on each frame.
    @objc private func updateRotation() {
        guard let startTime = startTime else { return } // Ensure startTime is set
            
        let elapsedTime = CACurrentMediaTime() - startTime
        let cycleProgress = elapsedTime.truncatingRemainder(dividingBy: GameConstants.animationSpeed) / GameConstants.animationSpeed
        gameState.progress = cycleProgress // Update animation progress
        gameState.isGlowing = isRectangleInRange() // Update glow effect only when near target
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
    
    
    func startCountdown() {
        // Reset the countdown timer
        gameState.gameTimer = 10
        
        // Invalidate any existing timer to avoid duplicate timers
        countdownTimer?.cancel()
        
        // Start a new timer that updates every second
        countdownTimer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                // Decrease the countdown, if it reaches 0, handle timeout
                if self.gameState.gameTimer > 0 {
                    self.gameState.gameTimer -= 1
                } else {
                    self.handleFailedTap() // treat as a failed tap
                }
            }
    }
    
    // calls success or failure handlers based on alignment.
    func handleTap() {
        if isRectangleInRange() {
            handleSuccessfulTap()
        } else {
            handleFailedTap()
        }
        startCountdown()
    }
    
    
    // Handles a successful tap, triggering animations and updating the node position.
    private func handleSuccessfulTap() {
        gameState.lastClickProgress = gameState.progress
        
        // Calculate accuracy based on how close to the center of the target range
        let normalizedProgress = normalizeAngle(gameState.progress * 360)
        let targetAngle = gameState.randomNodeAngle
        let angleDifference = abs(normalizedProgress - targetAngle)
        let accuracy = calculateAccuracy(angleDifference)
        
        // Update score based on accuracy
        let basePoints = calculateBasePoints(accuracy)
        gameState.combo += 1
        let comboMultiplier = min(Double(gameState.combo) * 0.1 + 1.0, 2.0) // Max 2x multiplier
        let finalPoints = Int(Double(basePoints) * comboMultiplier)
        
        // Update game state
        gameState.score += finalPoints
        gameState.highestCombo = max(gameState.highestCombo, gameState.combo)
        gameState.lastHitAccuracy = accuracy
        
        // Animations
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
    
    private func calculateAccuracy(_ angleDifference: Double) -> String {
        if angleDifference <= 5 { return "PERFECT!" }
        else if angleDifference <= 10 { return "Great!" }
        else if angleDifference <= 15 { return "Good" }
        else { return "OK" }
    }
    
    private func calculateBasePoints(_ accuracy: String) -> Int {
        switch accuracy {
        case "PERFECT!": return 100
        case "Great!": return 75
        case "Good": return 50
        default: return 25
        }
    }
    
    // Handles a failed tap, triggering a shaking animation to indicate incorrect alignment.
    private func handleFailedTap() {
        gameState.combo = 0  // Reset combo on miss
        
        if gameState.lives <= 1  {
            gameStatus = .gameOver
            countdownTimer?.cancel()
        } else {
            gameState.lives -= 1
                startCountdown()
            }
            
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
        
        
        // Normalizes an angle to fall within the 0-360° range.
        private func normalizeAngle(_ angle: Double) -> Double {
            var normalized = angle.truncatingRemainder(dividingBy: 360)
            if normalized < 0 { normalized += 360 }
            return normalized
        }
        
        // Cancels the timer when the ViewModel is deinitialized.
        deinit {
            displayLink?.invalidate() // Stop the display link when the ViewModel is deallocated
            countdownTimer?.cancel()
        }
    }

