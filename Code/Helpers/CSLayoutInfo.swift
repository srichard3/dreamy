//
//  CSLayoutInfo.swift
//  circle_snap
//
//  Created by Duy Nguyen on 10/24/24.
//
//import SpriteKit
//
//class MovingIndicatorNode: SKNode {
//    private let circleRadius: CGFloat
//    private let indicator: SKShapeNode
//
//    init(circleRadius: CGFloat) {
//        self.circleRadius = circleRadius
//        self.indicator = SKShapeNode(rectOf: CGSize(width: 10, height: 50), cornerRadius: 5)
//        super.init()
//        
//        indicator.fillColor = .blue
//        indicator.lineWidth = 0
//        addChild(indicator)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func update(progress: Double) {
//        let angle = progress * 2 * .pi - .pi / 2
//        let x = circleRadius * cos(angle)
//        let y = circleRadius * sin(angle)
//        indicator.position = CGPoint(x: x, y: y)
//        indicator.zRotation = CGFloat(angle)
//    }
//}
//
