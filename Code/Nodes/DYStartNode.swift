//
//  DYStartNode.swift
//  circle_snap
//
//  Created by Duy Nguyen on 12/7/24.
//

import SpriteKit


class DYStartNode: SKNode {
    let gameScene: DYGameScene
    private var startGameButton: SKSpriteNode!

    init(gameScene: DYGameScene) {
        self.gameScene = gameScene
        super.init()

        startGameButton = SKSpriteNode(imageNamed: "dy_start")
        startGameButton.zPosition = 2
        startGameButton.name = "startGameButton"
        startGameButton.position = CGPoint(x: 0, y: startGameButton.size.height / 2)
        addChild(startGameButton)

        startPulsingAnimation()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func handleTouch(at point: CGPoint) {
        let localPoint = self.convert(point, from: self.scene!)
        if let startGameLabel = self.childNode(withName: "startGameButton") as? SKSpriteNode,
           startGameLabel.frame.contains(localPoint) {
            animateButtonPress {
                self.gameScene.tapFeedbackGenerator.impactOccurred()
                if !self.gameScene.didShowTutorial {
                    self.gameScene.startTutorial()
                } else {
                    self.gameScene.startGame()
                }
            }
        }
    }
    
    private func startPulsingAnimation() {
        let scaleUp = SKAction.scale(to: 1.1, duration: 3.0)
        let fadeOut = SKAction.fadeAlpha(to: 0.5, duration: 1.0)
        scaleUp.timingMode = .easeInEaseOut
        fadeOut.timingMode = .easeInEaseOut
        let scaleDown = SKAction.scale(to: 1.0, duration: 3.0)
        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 1.0)
        scaleDown.timingMode = .easeInEaseOut
        fadeIn.timingMode = .easeInEaseOut

        let fadeSequence = SKAction.sequence([fadeOut, fadeIn])
        let pulseSequence = SKAction.sequence([scaleUp, scaleDown])
        let fadeForever = SKAction.repeatForever(fadeSequence)
        let pulseForever = SKAction.repeatForever(pulseSequence)

        startGameButton.run(fadeForever)
        startGameButton.run(pulseForever)
    }
    
    private func animateButtonPress(completion: @escaping () -> Void) {
        let scaleDown = SKAction.scale(to: 0.95, duration: 0.2)
        scaleDown.timingMode = .easeInEaseOut
        let scaleUp = SKAction.scale(to: 1.1, duration: 0.2)
        scaleUp.timingMode = .easeInEaseOut

        let tapSequence = SKAction.sequence([scaleDown, scaleUp])

        startGameButton.run(tapSequence) {
            completion()
        }
    }
}
