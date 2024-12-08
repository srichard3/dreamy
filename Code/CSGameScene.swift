import SpriteKit

class CSGameScene: SKScene {
    var gameContext: CSGameContext
    private var conditionManager: GameConditionManager
    
    private var circleNode: SKShapeNode!
    private var barNode: SKShapeNode!
    private var movingIndicatorNode : MovingIndicatorNode!
    private var targetNode: SKShapeNode!
    var gameStatus: GameStatus
    
    private var isReverse: Bool = false
    private var didTap: Bool = false
    
    private let angleTolerance: Double
    
    init(gameContext: CSGameContext = CSGameContext(),
         conditionManager: GameConditionManager = GameConditionManager()) {
        self.gameContext = gameContext
        self.conditionManager = conditionManager
        self.angleTolerance = Self.calculateAngleTolerance()
        self.gameStatus = GameStatus.notStarted
        super.init(size: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        setupScene()
    }
    
    func setupScene() {
        backgroundColor = .black
        
        // Create circle
        let circleTrackNode = CircleTrackNode(radius: GameConstants.circleTrackRadius,
                                              lineWidth: GameConstants.circleTrackWidth,
                                              color: SKColor(named: "circleTrack")!)
        circleTrackNode.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(circleTrackNode)
            
        // Create target node
        targetNode = TargetNode(angle: gameContext.progress * 360.0, scale: gameContext.scale, offset: gameContext.shakeOffset, isGlowing: gameContext.isGlowing)
        targetNode.position = calculateTargetNodePosition()
        addChild(targetNode)
        
        // Create bar
        movingIndicatorNode = MovingIndicatorNode(circleRadius: GameConstants.circleTrackRadius)
        movingIndicatorNode.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(movingIndicatorNode)
        
        // Setup initial game state
        gameContext.reset()
        conditionManager.updateCondition(for: gameContext)
    }
    
    override func update(_ currentTime: TimeInterval) {
        updateGameState()
        // check if circle should glow when clickabke
        updateNodePositions()
        checkGameConditions()
    }
    
    private func updateGameState() {
        let cycleProgress = gameContext.progress
        var progressChange = isReverse ? -0.01 : 0.01
        
        // Apply condition effects
        progressChange = conditionManager.applyConditionEffects(
            progress: progressChange,
            context: gameContext
        )
        
        gameContext.progress += progressChange
        
        // Ensure progress stays within 0-1 range
        gameContext.progress = gameContext.progress.truncatingRemainder(dividingBy: 1.0)
        if gameContext.progress < 0 {
            gameContext.progress += 1.0
        }
    }
    
    private func updateNodePositions() {
        // Calculate rotation angle based on progress
        let rotationAngle = CGFloat(gameContext.progress * .pi * 2)

        // Update bar node's position and rotation
        let x = frame.midX + CGFloat(GameConstants.circleTrackRadius * cos(rotationAngle - .pi / 2))
        let y = frame.midY + CGFloat(GameConstants.circleTrackRadius * sin(rotationAngle - .pi / 2))
        
        movingIndicatorNode.position = CGPoint(x: x, y: y)
        movingIndicatorNode.zRotation = rotationAngle
        // moveing.update()
    }
    
    private func checkGameConditions() {
        // Check for condition patch
        let currentAngle = normalizeAngle(gameContext.progress * 360)
        let weatherStartAngle = gameContext.conditionPatchStartAngle
        let weatherEndAngle = normalizeAngle(weatherStartAngle + GameConstants.conditionPatchSize)
        
        gameContext.isInConditionPatch = conditionManager.isAngleInRange(
            currentAngle,
            start: weatherStartAngle,
            end: weatherEndAngle
        )
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTap()
    }
    
    private func handleTap() {
        didTap = true
        
        if isRectangleInRange() {
            handleSuccessfulTap()
        } else {
            handleFailedTap()
        }
    }
    
    private func handleSuccessfulTap() {
        gameContext.score += 1
        isReverse.toggle()
        
        // Speed up game
        if gameContext.animationSpeed > 2 {
            gameContext.animationSpeed -= GameConstants.speedUpModifier
        }
        
        // Randomize target node position
        repositionTargetNode()
    }
    
    private func handleFailedTap() {
        // Game over logic TODO
    }
    
    private func repositionTargetNode() {
        let exclusionRange = 360.0 / 4
        var newAngle: Double
        repeat {
            newAngle = Double.random(in: 0..<360)
        } while abs(newAngle - gameContext.randomNodeAngle) < exclusionRange ||
                abs(newAngle - gameContext.randomNodeAngle) > 360 - exclusionRange
        
        gameContext.randomNodeAngle = newAngle
        targetNode.position = calculateTargetNodePosition()
    }
    
    private func calculateTargetNodePosition() -> CGPoint {
        let angle = CGFloat(gameContext.randomNodeAngle * .pi / 180)
        let x = frame.midX + CGFloat(GameConstants.circleTrackRadius * cos(angle))
        let y = frame.midY + CGFloat(GameConstants.circleTrackRadius * sin(angle))
        return CGPoint(x: x, y: y)
    }
    
    // Utility functions
    private func normalizeAngle(_ angle: Double) -> Double {
        var normalized = angle.truncatingRemainder(dividingBy: 360)
        if normalized < 0 { normalized += 360 }
        return normalized
    }
    
    private func isAngleInRange(_ angle: Double, start: Double, end: Double) -> Bool {
        if start <= end {
            return angle >= start && angle <= end
        } else {
            return angle >= start || angle <= end
        }
    }
    
    private func isRectangleInRange() -> Bool {
        let normalizedProgress = normalizeAngle(gameContext.progress * 360)
        let startAngle = normalizeAngle(gameContext.randomNodeAngle - angleTolerance)
        let endAngle = normalizeAngle(gameContext.randomNodeAngle + angleTolerance)
        
        return startAngle < endAngle
            ? normalizedProgress >= startAngle && normalizedProgress <= endAngle
            : normalizedProgress >= startAngle || normalizedProgress <= endAngle
    }
    
    private static func calculateAngleTolerance() -> Double {
        return ((Double(GameConstants.nodeRadius) / Double(GameConstants.circleTrackRadius)) * 180 / .pi) * 1.75
    }
}
