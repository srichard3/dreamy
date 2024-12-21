//
//  DYScoreNode.swift
//  circle_snap
//
//  Created by Duy Nguyen on 12/7/24.
//

import SpriteKit

class DYScoreNode: SKNode {
    private let label: SKLabelNode

    init(score: Int, fontSize: CGFloat) {
        label = SKLabelNode(fontNamed: "Baloo2-ExtraBold")
        super.init()

        label.fontSize = fontSize
        label.fontColor = UIColor(hex: "#FAFAFA")
        label.text = "\(score)"
        label.verticalAlignmentMode = .center
//        addStroke() // buggy with Baloo font

        addChild(label)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addStroke() {
        let strokeWidth: CGFloat = -(label.fontSize * 2/70)
        let strokeColor: UIColor = .black

        let attributedText = NSMutableAttributedString(
            string: label.text ?? "",
            attributes: [
                .strokeColor: strokeColor,
                .strokeWidth: strokeWidth,
                .foregroundColor: label.fontColor ?? .white,
                .font: UIFont(name: label.fontName ?? "Baloo2-ExtraBold", size: label.fontSize) ?? UIFont.systemFont(ofSize: label.fontSize)
            ]
        )
        label.attributedText = attributedText
    }

    func updateScore(to newScore: Int) {
        let oldScore = Int(label.text ?? "0") ?? 0

        label.text = "\(newScore)"
//        addStroke() // buggy with Baloo font

        if newScore > oldScore {
            animateScoreIncrease()
        }
    }

    private func animateScoreIncrease() {
        let scaleUp = SKAction.scale(to: 0.8, duration: 0.1)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.1)
        let bounce = SKAction.sequence([scaleUp, scaleDown])
        self.run(bounce)
    }
}
