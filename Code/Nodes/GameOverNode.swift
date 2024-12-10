//
//  GameOverNode.swift
//  circle_snap
//
//  Created by Duy Nguyen on 12/7/24.
//

import SpriteKit

class GameOverNode: SKNode {
    let viewModel: CSGameScene
    
    init(viewModel: CSGameScene) {
        self.viewModel = viewModel
        super.init()
        
        // Game Over label
        let gameOverLabel = SKLabelNode(text: "Game Over")
        gameOverLabel.fontSize = 40
        gameOverLabel.fontColor = .red
        gameOverLabel.position = CGPoint(x: 0, y: 100)  // Adjust position as needed
        self.addChild(gameOverLabel)
        
        // Play Again button
        let playAgainButton = SKLabelNode(text: "Play Again")
        playAgainButton.fontSize = 30
        playAgainButton.fontColor = .white
        playAgainButton.position = CGPoint(x: 0, y: -50)  // Adjust position as needed
        playAgainButton.name = "playAgainButton"  // Set name for touch detection
        self.addChild(playAgainButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handlePlayAgainTapped() {
        viewModel.gameContext.currentGameStatus = .inProgress
        viewModel.gameContext.reset()
        viewModel.removeAllChildren()
        viewModel.setupScene()
    }
    
    // Detect touch events on the Play Again button
    func handleTouch(at point: CGPoint) {
        // Convert touch location to local coordinates
        let localPoint = self.convert(point, from: self.scene!)
        
        if let playAgainButton = self.childNode(withName: "playAgainButton") as? SKLabelNode {
            let expandedFrame = playAgainButton.frame.insetBy(dx: -10, dy: -10)
            
            if expandedFrame.contains(localPoint) {
                handlePlayAgainTapped()
            }
        }
    }
}
