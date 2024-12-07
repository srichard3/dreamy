//
//  StartNode.swift
//  circle_snap
//
//  Created by Duy Nguyen on 12/7/24.
//

import SpriteKit

class StartNode: SKNode {
    let viewModel: CSViewModel

    init(viewModel: CSViewModel) {
        self.viewModel = viewModel
        super.init()

        // Create Start Game label
        let startGameLabel = SKLabelNode(text: "Start Game")
        startGameLabel.fontSize = 40
        startGameLabel.fontColor = .white
        startGameLabel.position = CGPoint(x: 0, y: 0)  // Adjust position as needed
        startGameLabel.name = "startGameButton"  // Set name for touch detection
        self.addChild(startGameLabel)

        // Style the label like a button (background, corner radius, etc.)
        startGameLabel.zPosition = 1  // Bring the label to the front
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Handle start game action
    func startGame() {
        viewModel.gameStatus = .inProgress
        viewModel.onAppear() // Initialize game-related functions
    }

    // Detect touch events on the Start Game button
    func handleTouch(at point: CGPoint) {
        if let startGameLabel = self.childNode(withName: "startGameButton") as? SKLabelNode,
           startGameLabel.frame.contains(point) {
            startGame()
        }
    }
}
