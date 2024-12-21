//
//  DYGameOverNode.swift
//  circle_snap
//
//  Created by Duy Nguyen on 12/7/24.
//


import SpriteKit

class DYGameOverNode: SKNode {
    let gameScene: DYGameScene
    
    private var overlay: SKShapeNode!
    private var gameOverImage: SKSpriteNode!
    private var tapToContinueLabel: SKLabelNode!
    
    private var isTapToContinueActive: Bool = false
    
    init(gameScene: DYGameScene) {
        self.gameScene = gameScene
        super.init()
        
        setupOverlay()
        setupGameOverImage()
        setupTapToContinueLabel()
        
        overlay.alpha = 0.0
        gameOverImage.alpha = 0
        tapToContinueLabel.alpha = 0
        
        runFadeInSequence()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupOverlay() {
        overlay = SKShapeNode(rectOf: gameScene.size)
        overlay.fillColor = UIColor.black.withAlphaComponent(0.8)
        overlay.strokeColor = .clear
        overlay.zPosition = 1
        overlay.position = .zero
        addChild(overlay)
    }
    
    private func setupGameOverImage() {
        gameOverImage = SKSpriteNode(imageNamed: "dy_game_over")
        gameOverImage.zPosition = 2
        gameOverImage.position = CGPoint(x: 0, y: gameScene.size.height * 0.02)
        gameOverImage.setScale(gameScene.size.width * 401/440 / gameOverImage.size.width)
        addChild(gameOverImage)
    }
    
    private func setupTapToContinueLabel() {
        tapToContinueLabel = SKLabelNode(text: "tap to continue")
        tapToContinueLabel.fontSize = 20
        tapToContinueLabel.fontColor = .white
        tapToContinueLabel.fontName = "Baloo2-Medium"
        tapToContinueLabel.position = CGPoint(x: 0, y: gameScene.size.height * -0.15)
        tapToContinueLabel.zPosition = 2
        addChild(tapToContinueLabel)
    }
    
    private func runFadeInSequence() {
        let fadeInOverlay = SKAction.fadeAlpha(to: 0.8, duration: 1.0)
        let fadeInGameOverImage = SKAction.fadeAlpha(to: 1.0, duration: 1.0)
        let wait = SKAction.wait(forDuration: 1.0)
        let fadeInTapToContinue = SKAction.fadeAlpha(to: 1.0, duration: 0.8)
        
        let sequence = SKAction.sequence([
            SKAction.run { self.overlay.run(fadeInOverlay) },
            SKAction.run { self.gameOverImage.run(fadeInGameOverImage) },
            wait,
            SKAction.run { self.tapToContinueLabel.run(fadeInTapToContinue) },
            SKAction.run { [weak self] in
                self?.startFlashingAnimation()
                self?.isTapToContinueActive = true
            }
        ])
        
        run(sequence)
    }
    
    private func startFlashingAnimation() {
        guard let tapLabel = tapToContinueLabel else { return }
        
        let fadeOut = SKAction.fadeAlpha(to: 0.15, duration: 1.0)
        let fadeIn = SKAction.fadeAlpha(to: 0.8, duration: 1.0)
        fadeOut.timingMode = .easeInEaseOut
        fadeIn.timingMode = .easeInEaseOut
        
        let flashSequence = SKAction.sequence([fadeOut, fadeIn])
        let flashForever = SKAction.repeatForever(flashSequence)
        
        tapLabel.run(flashForever)
    }
    
    func handleTouch(at point: CGPoint) {
        guard isTapToContinueActive else { return }
        
        gameScene.tapFeedbackGenerator.impactOccurred()
        let soundAction = SKAction.playSoundFileNamed("dy_button.mp3", waitForCompletion: false)
        run(soundAction)
        
        handleRestartTapped()
    }
    
    func handleRestartTapped() {
        isTapToContinueActive = false
        
        let fadeOut = SKAction.fadeAlpha(to: 0.0, duration: 0.5)
        let removeAndRestart = SKAction.run { [weak self] in
            self?.gameScene.enterStarting(animateStart: false)
        }
        
        let fullSequence = SKAction.sequence([
            fadeOut,
            removeAndRestart
        ])
        
        run(fullSequence)
    }
    
}
