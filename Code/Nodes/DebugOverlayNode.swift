//
//  DebugOverlayNode.swift
//  circle_snap
//
//  Created by Duy Nguyen on 12/7/24.
//

import SpriteKit

class DebugOverlayNode: SKNode {
    private let labels: [SKLabelNode]

    init(debugInfo: [String]) {
        self.labels = debugInfo.map { info in
            let label = SKLabelNode(text: info)
            label.fontName = "Arial"
            label.fontSize = 12
            label.fontColor = .white
            return label
        }
        super.init()
        for (index, label) in labels.enumerated() {
            label.position = CGPoint(x: 0, y: -CGFloat(index * 20))
            addChild(label)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateInfo(with debugInfo: [String]) {
        for (index, info) in debugInfo.enumerated() {
            labels[index].text = info
        }
    }
}
