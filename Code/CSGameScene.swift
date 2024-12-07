//
//  CSGameScene.swift
//  circle_snap
//
//  Created by Duy Nguyen on 10/24/24.
//

import SpriteKit
import GameplayKit

class CSGameScene: SKScene {
    weak var context: CSGameContext?

    // nodes
    private var circleTrackNode: CircleTrackNode!
    private var comboLabelNode: SKLabelNode!
    private var conditionNode: ConditionNode?
    private var targetNode: TargetNode!
    private var movingIndicatorNode: MovingIndicatorNode!

    override func didMove(to view: SKView) {
        guard let context else { return }
        
        // Initialize and add the circular track
        circleTrackNode = CircleTrackNode(radius: 155, lineWidth: 45, color: .white)
        circleTrackNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(circleTrackNode)

        // Initialize and add the combo score label
        comboLabelNode = SKLabelNode(text: "Score: \(context.gameState.score)")
        comboLabelNode.fontSize = 24
        comboLabelNode.fontColor = .white
        comboLabelNode.position = CGPoint(x: size.width / 2, y: size.height - 50)
        addChild(comboLabelNode)

        // Initialize and add the target node
        targetNode = TargetNode()
        targetNode.position = circleTrackNode.position // Center it on the track
        addChild(targetNode)

        // Initialize and add the moving indicator
        movingIndicatorNode = MovingIndicatorNode()
        movingIndicatorNode.position = circleTrackNode.position
        addChild(movingIndicatorNode)
    }

    override func update(_ currentTime: TimeInterval) {
        guard let context else { return }
        
        // Update nodes dynamically based on game state
        comboLabelNode.text = "Score: \(context.gameState.score)"
        
        // Handle condition node visibility
        if context.gameState.currentCondition != .none, conditionNode == nil {
            conditionNode = ConditionNode(
                weather: context.gameState.currentCondition,
                startAngle: context.gameState.conditionPatchStartAngle
            )
            conditionNode?.position = circleTrackNode.position
            addChild(conditionNode!)
        } else if context.gameState.currentCondition == .none, conditionNode != nil {
            conditionNode?.removeFromParent()
            conditionNode = nil
        }
        
        // Update other nodes based on game state
        targetNode.update(
            angle: context.gameState.randomNodeAngle,
            scale: context.gameState.scale,
            offset: context.gameState.shakeOffset,
            isGlowing: context.gameState.isGlowing
        )
        movingIndicatorNode.update(progress: context.gameState.progress, isVisible: context.gameState.isBarVisible)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let context else { return }
        context.handleTap() // Forward tap handling to GameContext
    }
}
