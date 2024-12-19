//
//  DYGameScene.swift
//  circle_snap
//
//  Created by Duy Nguyen on 12/7/24.
//


import SpriteKit

public enum GameStatus {
    case gameOver
    case inProgress
    case starting
    case tutorial
}

class DYGameScene: SKScene {
    unowned let context: DYGameContext
    var gameInfo: DYGameInfo { return context.gameInfo }
    var layoutInfo: DYLayoutInfo { return context.layoutInfo }
    
    private var backgroundNode: DYBackgroundNode!
    private var circleTrackNode: DYCircleTrackNode!
    private var movingIndicatorNode : DYPlayerNode!
    private var conditionNode : DYConditionNode!
    private var targetNode: DYTargetCircleNode!
    var scoreNode: DYScoreNode!
    private var startNode: DYStartNode!
    private var gameOverNode: DYGameOverNode!
    private var timerProgressNode: DYTimerProgressNode!
    private var fogTargetIndicatorNode: SKShapeNode?
    
    private var isReverse: Bool = false
    private var isTouchingConditionNode: Bool = false
    
    public var didShowTutorial: Bool = true
    private var tutorialConditions: [DYConditionType] = [.ice, .sand, .mud, .fog]
    private var currentTutorialIndex = 0
    private var tutorialShowingTapToContinue = false
    private var tutorialLabel: SKLabelNode?
    private var tutorialOverlayNode: SKSpriteNode?
    
    private var randomNodeAngle: Double!
    private var angleTolerance: Double?
    
    private let successFeedbackGenerator = UINotificationFeedbackGenerator()
    private let errorFeedbackGenerator = UINotificationFeedbackGenerator()
    public let tapFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    init(context: DYGameContext, size: CGSize) {
        self.context = context
        self.angleTolerance = 0
        self.randomNodeAngle = Double.random(in: 0..<360)
        super.init(size: size)
        self.angleTolerance = calculateAngleTolerance()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        successFeedbackGenerator.prepare()
        errorFeedbackGenerator.prepare()
        tapFeedbackGenerator.prepare()
        
        backgroundNode = DYBackgroundNode(size: size, layoutInfo: layoutInfo)
        backgroundNode.zPosition = -1
        addChild(backgroundNode)
        
        enterStarting(animateStart: true)
    }
    
    func reset() {
        gameInfo.reset()
        conditionNode?.conditionType = .none
        
        scoreNode?.updateScore(to: gameInfo.score)
        gameOverNode?.removeFromParent()
        circleTrackNode?.removeFromParent()
        timerProgressNode?.removeFromParent()
        targetNode?.removeFromParent()
        movingIndicatorNode?.removeFromParent()
    }
    
    
    func enterStarting(animateStart: Bool) {
        if animateStart {
            showStartScreen()
        } else {
            let removalDuration: TimeInterval = 0.3
            let removalDelayIncrement: TimeInterval = 0.05
            var delay: TimeInterval = 0.0
            
            circleTrackNode?.animateOut(duration: removalDuration, delay: delay) { [weak self] in
                self?.circleTrackNode?.removeFromParent()
            }
            delay += removalDelayIncrement
            
            conditionNode?.animateOut(duration: removalDuration, delay: delay) { [weak self] in
                self?.conditionNode?.removeFromParent()
            }
            delay += removalDelayIncrement
            
            timerProgressNode?.animateOut(duration: removalDuration, delay: delay) { [weak self] in
                self?.timerProgressNode?.removeFromParent()
            }
            delay += removalDelayIncrement
            
            targetNode?.animateOut(duration: removalDuration, delay: delay) { [weak self] in
                self?.targetNode?.removeFromParent()
            }
            delay += removalDelayIncrement
            
            movingIndicatorNode?.animateOut(duration: removalDuration, delay: delay) { [weak self] in
                self?.movingIndicatorNode?.removeFromParent()
            }
            delay += removalDelayIncrement
            
            scoreNode?.animateOut(duration: removalDuration, delay: delay) { [weak self] in
                self?.scoreNode?.removeFromParent()
            }
            delay += removalDelayIncrement
            
            gameOverNode?.animateOut(duration: removalDuration, delay: delay) { [weak self] in
                self?.gameOverNode?.removeFromParent()
            }
            delay += removalDelayIncrement
            
            let totalDelay = delay + removalDuration
            run(SKAction.sequence([
                SKAction.wait(forDuration: totalDelay),
                SKAction.run { [weak self] in
                    self?.reset()
                    self?.showStartScreen()
                }
            ]))
        }
    }

    private func showStartScreen() {
        startNode = DYStartNode(gameScene: self)
        startNode.position = layoutInfo.startNodePosition
        startNode.zPosition = 10
        startNode.alpha = 0
        startNode.setScale(0.8)
        addChild(startNode)
        
        
        startNode.animateIn(duration: 0.1)
    }
    
    func startGame() {
        startNode.removeFromParent()
        gameInfo.updateGameStatus(.inProgress)
        setupMainNodes()
    }
    
    
    func startTutorial() {
           startNode?.removeFromParent()
           gameInfo.updateGameStatus(.tutorial)

           circleTrackNode = DYCircleTrackNode(
               radius: layoutInfo.circleTrackRadius,
               lineWidth: layoutInfo.circleTrackLineWidth,
               color: UIColor(hex: "#CED2F9")
           )
           let circleTrackNodeSideLength = (layoutInfo.circleTrackRadius + circleTrackNode.lineWidth) * 2
           circleTrackNode.position = layoutInfo.circleTrackNodePosition
           circleTrackNode.zPosition = 1
           circleTrackNode.setScale(0.8)
           circleTrackNode.alpha = 0
           addChild(circleTrackNode)
           circleTrackNode.animateIn(duration: 0.5)

           movingIndicatorNode = DYPlayerNode(
               circleRadius: layoutInfo.circleTrackRadius,
               circleTrackLineWidth: layoutInfo.circleTrackLineWidth
           )
           movingIndicatorNode.position = layoutInfo.playerNodePosition
           movingIndicatorNode.zPosition = circleTrackNode.zPosition + 2
           movingIndicatorNode.alpha = 0
           movingIndicatorNode.setScale(0.8)
           circleTrackNode.addChild(movingIndicatorNode)
           movingIndicatorNode.animateIn(duration: 0.5, delay: 0.5)

           conditionNode = DYConditionNode(layoutInfo: layoutInfo)
           conditionNode.position = .zero
           circleTrackNode.addChild(conditionNode)
           
           // Setup a tutorial overlay node
           tutorialOverlayNode = SKSpriteNode(imageNamed: "dy_ice_tutorial")
           tutorialOverlayNode?.zPosition = 10
           tutorialOverlayNode?.alpha = 0
           tutorialOverlayNode?.setScale(0.0)
           circleTrackNode.addChild(tutorialOverlayNode!)
           
           run(SKAction.sequence([
               SKAction.wait(forDuration: 1.0),
               SKAction.run { [weak self] in
                   self?.showNextTutorialCondition()
               }
           ]))
       }
    
    private func showNextTutorialCondition() {
           guard currentTutorialIndex < tutorialConditions.count else {
               didShowTutorial = true
               
               circleTrackNode?.removeFromParent()
               movingIndicatorNode?.removeFromParent()
               conditionNode?.removeFromParent()
               
               tutorialOverlayNode?.removeFromParent()
               tutorialOverlayNode = nil
               tutorialLabel?.removeFromParent()
               tutorialLabel = nil
               
               conditionNode.conditionType = .none
               conditionNode.updateConditionForCurrentWeather()
               
               startGame()
               return
           }

           tutorialShowingTapToContinue = false

           let condition = tutorialConditions[currentTutorialIndex]
           conditionNode.conditionType = condition
           conditionNode.updateConditionForCurrentWeather()

           if let tutorialTextureName = condition.tutorialTextureName {
               let texture = SKTexture(imageNamed: tutorialTextureName)
               tutorialOverlayNode?.texture = texture
               tutorialOverlayNode?.alpha = 0
               
               tutorialOverlayNode?.setScale(1.0)
               let scale = layoutInfo.circleTrackRadius * 398/150 / (tutorialOverlayNode?.size.width ?? 398)
               tutorialOverlayNode?.setScale(0.0)
               
               tutorialOverlayNode?.position = layoutInfo.tutorialOverlayNodePosition

               let fadeIn = SKAction.fadeIn(withDuration: 0.3)
               let scaleUp = SKAction.scale(to: scale, duration: 0.3)
               tutorialOverlayNode?.run(SKAction.group([fadeIn, scaleUp]))
           } else {
               tutorialOverlayNode?.alpha = 0
           }

           run(SKAction.sequence([
               SKAction.wait(forDuration: 2.0),
               SKAction.run { [weak self] in
                   self?.showTapToContinue()
               }
           ]))
       }

    private func showTapToContinue() {
        guard tutorialLabel == nil else { return }

        tutorialShowingTapToContinue = true
        tutorialLabel = SKLabelNode(text: "tap to continue")
        tutorialLabel?.fontName = "Baloo2-Regular"
        tutorialLabel?.fontColor = .white
        tutorialLabel?.fontSize = layoutInfo.tutorialLabelFontSize
        tutorialLabel?.alpha = 0
        tutorialLabel?.position = .zero
        circleTrackNode.addChild(tutorialLabel!)

        tutorialLabel?.run(SKAction.fadeIn(withDuration: 0.3))
    }


    private func hideCurrentCondition() {
        tutorialOverlayNode?.texture = nil
        tutorialOverlayNode?.alpha = 0
        tutorialLabel?.removeFromParent()
        tutorialLabel = nil
        
        // Reset condition so no effects carry over to next tutorial step
        conditionNode.conditionType = .none
        conditionNode.updateConditionForCurrentWeather()
    }
    
    
    func setupMainNodes() {
        circleTrackNode = DYCircleTrackNode(
            radius: layoutInfo.circleTrackRadius,
            lineWidth: layoutInfo.circleTrackLineWidth,
            color: UIColor(hex: "#CED2F9")
        )
        circleTrackNode.position = layoutInfo.circleTrackNodePosition
        circleTrackNode.zPosition = 1
        circleTrackNode.setScale(0.8)
        circleTrackNode.alpha = 0
        addChild(circleTrackNode)
        circleTrackNode.animateIn(duration: 0.5)
        
        let cloudNode = SKSpriteNode(imageNamed: "dy_cloud_main")
        cloudNode.zPosition = circleTrackNode.zPosition + 4
        cloudNode.position = layoutInfo.cloudNodePosition
        cloudNode.setScale(layoutInfo.circleTrackNodeSideLength * 0.854285714  / cloudNode.size.width)
        cloudNode.alpha = 0
        circleTrackNode.addChild(cloudNode)
        cloudNode.animateIn(duration: 0.5, delay: 0.2)
        
        conditionNode = DYConditionNode(layoutInfo: layoutInfo)
        conditionNode.position = .zero
        circleTrackNode.addChild(conditionNode)
        
        var currentSpeed = isReverse ? -DYLayoutInfo.baseSpeed : DYLayoutInfo.baseSpeed
        let speedMultiplier = 1.0 + (Double(gameInfo.score) * DYLayoutInfo.speedUpMultiplier)
        currentSpeed *= speedMultiplier
        let absoluteSpeed = abs(currentSpeed)
        let totalTime = (4.0 / absoluteSpeed) / 60.0
        
        let timerLineWidth = layoutInfo.circleTrackLineWidth * 1.12
        timerProgressNode = DYTimerProgressNode(
            radius: layoutInfo.circleTrackRadius,
            lineWidth: timerLineWidth,
            totalTime: totalTime
        )
        timerProgressNode.position = .zero
        timerProgressNode.zPosition = circleTrackNode.zPosition + 1
        timerProgressNode.alpha = 0
        timerProgressNode.setScale(0.8)
        timerProgressNode.onTimerEnd = { [weak self] in
            self?.gameOver()
        }
        circleTrackNode.addChild(timerProgressNode)
        timerProgressNode.animateIn(duration: 0.5, delay: 0.4) {
            self.timerProgressNode.startCountdown()
        }
        
        targetNode = DYTargetCircleNode(
            circleTrackRadius: layoutInfo.circleTrackRadius,
            circleTrackLineWidth: layoutInfo.circleTrackLineWidth
        )
        targetNode.position = calculateTargetNodePosition()
        targetNode.zPosition = circleTrackNode.zPosition + 1
        targetNode.alpha = 0
        targetNode.setScale(0.8)
        circleTrackNode.addChild(targetNode)
        targetNode.animateIn(duration: 0.5, delay: 0.6)
        
        movingIndicatorNode = DYPlayerNode(
            circleRadius: layoutInfo.circleTrackRadius,
            circleTrackLineWidth: layoutInfo.circleTrackLineWidth
        )
        movingIndicatorNode.position = layoutInfo.playerNodePosition
        movingIndicatorNode.zPosition = circleTrackNode.zPosition + 2
        movingIndicatorNode.alpha = 0
        movingIndicatorNode.setScale(0.8)
        circleTrackNode.addChild(movingIndicatorNode)
        movingIndicatorNode.animateIn(duration: 0.5, delay: 0.8)
        
        scoreNode = DYScoreNode(score: gameInfo.score, fontSize: layoutInfo.scoreFontSize)
        scoreNode.position = .zero
        scoreNode.zPosition = circleTrackNode.zPosition + 1
        scoreNode.alpha = 0
        scoreNode.setScale(0.8)
        circleTrackNode.addChild(scoreNode)
        scoreNode.animateIn(duration: 0.5, delay: 1.0)
    }
    
    func gameOver() {
        errorFeedbackGenerator.notificationOccurred(.error)

        gameInfo.updateGameStatus(.gameOver)
        timerProgressNode.stopCountdown()
        circleTrackNode.animateIncorrectTap { [weak self] in
            self?.gameOverNode = DYGameOverNode(gameScene: self!)
            self?.gameOverNode.position = CGPoint(x: self!.frame.midX, y: self!.frame.midY)
            self?.gameOverNode.zPosition = 10
            self?.addChild(self!.gameOverNode)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if gameInfo.currentGameStatus == .inProgress {
            updateProgress()
            checkIfTouchingConditionNode()
            updateMovingIndicatorPosition()
        }
        else if gameInfo.currentGameStatus == .tutorial {
            // Move the indicator as normal but no game logic for targets/score
            updateMovingIndicatorPositionForTutorial()
        }
    }
    
    private func updateMovingIndicatorPositionForTutorial() {
        // Apply condition effects here so the player sees the impact
        var speed = DYLayoutInfo.baseSpeed
        
        let currentAngle = normalizeAngle(gameInfo.progress * 360)
        let conditionStartAngle = conditionNode.startAngle
        isTouchingConditionNode = conditionNode.isAngleInRange(
            currentAngle,
            start: Double(conditionStartAngle)
        )
        
        if conditionNode.conditionType != .none && isTouchingConditionNode {
            speed = conditionNode.applyConditionEffects(progress: speed)
        }
        
        gameInfo.progress += speed
        gameInfo.progress = gameInfo.progress.truncatingRemainder(dividingBy: 1.0)
        
        let rotationAngle = CGFloat(gameInfo.progress * .pi * 2)
        let x = CGFloat(layoutInfo.circleTrackRadius * cos(rotationAngle - .pi / 2))
        let y = CGFloat(layoutInfo.circleTrackRadius * sin(rotationAngle - .pi / 2))
        
        movingIndicatorNode.position = CGPoint(x: x, y: y)
        movingIndicatorNode.zRotation = rotationAngle
    }
    
    private func updateProgress() {
        /// set speed of moving indicator
        var speed = isReverse ? -DYLayoutInfo.baseSpeed : DYLayoutInfo.baseSpeed
        let speedMultiplier = 1.0 + (Double(gameInfo.score) * DYLayoutInfo.speedUpMultiplier)
        speed *= speedMultiplier

        /// conditions turn on after 5 points
        if conditionNode.conditionType != .none && isTouchingConditionNode {
            speed = conditionNode.applyConditionEffects(progress: speed)
        }
        
        /// move distance of speed
        gameInfo.progress += speed

        /// Ensure progress stays within 0-1 range
        gameInfo.progress = gameInfo.progress.truncatingRemainder(dividingBy: 1.0)
        if gameInfo.progress < 0 {
            gameInfo.progress += 1.0
        }
        
        targetNode.setIsActive(isRectangleInRange())

    }
    
    private func checkIfTouchingConditionNode() {
        let currentAngle = normalizeAngle(gameInfo.progress * 360)
        let conditionStartAngle = conditionNode.startAngle
        isTouchingConditionNode = conditionNode.isAngleInRange(
            currentAngle,
            start: Double(conditionStartAngle)
        )
    }
    
    private func updateMovingIndicatorPosition() {
        let rotationAngle = CGFloat(gameInfo.progress * .pi * 2)
        let x = CGFloat(layoutInfo.circleTrackRadius * cos(rotationAngle - .pi / 2))
        let y = CGFloat(layoutInfo.circleTrackRadius * sin(rotationAngle - .pi / 2))
        
        movingIndicatorNode.position = CGPoint(x: x, y: y)
        movingIndicatorNode.zRotation = rotationAngle
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if gameInfo.currentGameStatus == .gameOver {
            gameOverNode?.handleTouch(at: location)
        } else if gameInfo.currentGameStatus == .starting {
            startNode?.handleTouch(at: location)
        } else if gameInfo.currentGameStatus == .tutorial {
            if tutorialShowingTapToContinue {
                tapFeedbackGenerator.impactOccurred()
                
                hideCurrentCondition()
                currentTutorialIndex += 1
                showNextTutorialCondition()
            }
        } else {
            let scaleDown = SKAction.scale(to: 0.8, duration: 0.1)
            let scaleUp = SKAction.scale(to: 1.0, duration: 0.1)
            movingIndicatorNode.run(SKAction.sequence([scaleDown, scaleUp]))
            if isRectangleInRange() {
                handleSuccessfulTap()
            } else {
                gameOver()
            }
        }
    }
    
    private func handleSuccessfulTap() {
        successFeedbackGenerator.notificationOccurred(.success)

        gameInfo.updateScore(1)
        scoreNode.updateScore(to: gameInfo.score)
        if gameInfo.score % DYLayoutInfo.minimumConditionScore == 0 {
            conditionNode.randomizeAppearance()
        }
        
        isReverse.toggle()
        repositionTargetNode()
        handleSpeedChange()
    }
    
    private func handleSpeedChange() {
        var currentSpeed = isReverse ? -DYLayoutInfo.baseSpeed : DYLayoutInfo.baseSpeed
        let speedMultiplier = 1.0 + (Double(gameInfo.score) * DYLayoutInfo.speedUpMultiplier)
        currentSpeed *= speedMultiplier
        
        let absoluteSpeed = abs(currentSpeed)
        
        let totalTime = (4.0 / absoluteSpeed) / 60.0 // seconds
        
        timerProgressNode?.setTotalTime(totalTime)
        timerProgressNode?.resetCountdown()
    }
    
    private func repositionTargetNode() {
        let exclusionRange = 360.0 / 6
        var newAngle: Double
        repeat {
            newAngle = Double.random(in: 0..<360)
        } while abs(newAngle - randomNodeAngle) < exclusionRange ||
                abs(newAngle - randomNodeAngle) > 360 - exclusionRange
        
        randomNodeAngle = newAngle
        let newPosition = calculateTargetNodePosition()
        
        self.removeFogTargetIndicator()
        animateTargetNode(to: newPosition)
    }
    
    private func animateTargetNode(to newPosition: CGPoint) {
        let scaleDown = SKAction.scale(to: 0.0, duration: 0.1)
        
        let move = SKAction.move(to: newPosition, duration: 0.0)
        
        let scaleUpBounce = SKAction.sequence([
            SKAction.scale(to: 1.1, duration: 0.1),
            SKAction.scale(to: 1.0, duration: 0.1)
        ])
        
        let sequence = SKAction.sequence([scaleDown, move, scaleUpBounce])
        
        targetNode.run(sequence) {
            self.updateFogTargetIndicator()
        }
    }
    
    private func calculateTargetNodePosition() -> CGPoint {
        let rotationAngle = CGFloat(randomNodeAngle * .pi / 180)
        
        let x = CGFloat(layoutInfo.circleTrackRadius * cos(rotationAngle - .pi / 2))
        let y = CGFloat(layoutInfo.circleTrackRadius * sin(rotationAngle - .pi / 2))
        
        return CGPoint(x: x, y: y)
    }
    
    private func showFogTargetIndicator(at position: CGPoint, radius: CGFloat) {
        // Avoid creating multiple indicators
        print("here")
        guard fogTargetIndicatorNode == nil else { return }
        print("there")
        let indicator = SKShapeNode(circleOfRadius: radius)
        indicator.strokeColor = UIColor(hex: "#FFCF69")
        indicator.lineWidth = 2
        indicator.fillColor = .clear
        indicator.position = position
        indicator.zPosition = targetNode.zPosition + 10
        circleTrackNode.addChild(indicator)
        
        fogTargetIndicatorNode = indicator
    }
    
    private func removeFogTargetIndicator() {
        fogTargetIndicatorNode?.removeFromParent()
        fogTargetIndicatorNode = nil
    }
    
    private func updateFogTargetIndicator() {
        // Calculate the target's current angle
        let targetAngle = normalizeAngle(randomNodeAngle)
        
        // Check if the current condition is fog and the target is within the fog range
        if conditionNode.conditionType == .fog && conditionNode.isAngleInRange(Double(targetAngle), start: Double(conditionNode.startAngle)) {
            print("covered!")
            // Determine the radius for the indicator (slightly larger than the target)
            let indicatorRadius = targetNode.frame.width / 2 + 4
            
            // Show the indicator
            showFogTargetIndicator(at: targetNode.position, radius: indicatorRadius)
        } else {
            // Remove the indicator if conditions are not met
            removeFogTargetIndicator()
        }
    }

    private func normalizeAngle(_ angle: Double) -> Double {
        var normalized = angle.truncatingRemainder(dividingBy: 360)
        if normalized < 0 { normalized += 360 }
        return normalized
    }
    
    private func isRectangleInRange() -> Bool {
        let normalizedProgress = normalizeAngle(gameInfo.progress * 360)
        let startAngle = normalizeAngle(randomNodeAngle - (angleTolerance ?? 0.0))
        let endAngle = normalizeAngle(randomNodeAngle + (angleTolerance ?? 0.0))
        
        return startAngle < endAngle
            ? normalizedProgress >= startAngle && normalizedProgress <= endAngle
            : normalizedProgress >= startAngle || normalizedProgress <= endAngle
    }
    
    private func calculateAngleTolerance() -> Double {
        return ((Double(layoutInfo.nodeRadius) / Double(layoutInfo.circleTrackRadius)) * 180 / .pi) * 1.75
    }
}


// MARK: Extensions

extension SKNode {
    func animateIn(duration: TimeInterval = 0.3, scale: CGFloat = 1.0, delay: TimeInterval = 0.0, completion: (() -> Void)? = nil) {
        self.alpha = 0
        self.setScale(0.8)
        let fadeIn = SKAction.fadeIn(withDuration: duration)
        let scaleUp = SKAction.scale(to: scale, duration: duration)
        let group = SKAction.group([fadeIn, scaleUp])
        let sequence = SKAction.sequence([SKAction.wait(forDuration: delay), group])
        if let completion = completion {
            self.run(sequence) {
                completion()
            }
        } else {
            self.run(sequence)
        }
    }
    
    func animateOut(duration: TimeInterval = 0.3, scale: CGFloat = 0.8, delay: TimeInterval = 0.0, completion: (() -> Void)? = nil) {
        let fadeOut = SKAction.fadeOut(withDuration: duration)
        let scaleDown = SKAction.scale(to: scale, duration: duration)
        let group = SKAction.group([fadeOut, scaleDown])
        let sequence = SKAction.sequence([SKAction.wait(forDuration: delay), group])
        if let completion = completion {
            self.run(sequence) {
                completion()
            }
        } else {
            self.run(sequence)
        }
    }
}
