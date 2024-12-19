//
//  DYTargetCircleNode.swift
//  circle_snap
//
//  Created by Duy Nguyen on 12/7/24.
//

import SpriteKit

class DYTargetCircleNode: SKShapeNode {
    private let minGlowWidth: CGFloat = 1.0
    private let maxGlowWidth: CGFloat = 8.0
    
    private let activeRed: UIColor = UIColor(hex: "#F3504C")
    private let inactiveYellow: UIColor = UIColor(hex: "#FFCF69")
    
    init(circleTrackRadius: CGFloat, circleTrackLineWidth: CGFloat) {
        super.init()
        
        let radius = circleTrackLineWidth * 0.9
        let offset = circleTrackRadius * 0.15
        self.path = CGPath(ellipseIn: CGRect(x: -offset, y: -offset, width: radius, height: radius), transform: nil)
        
        self.fillColor = inactiveYellow
        self.lineWidth = circleTrackRadius * 2/150
        self.strokeColor = .black
    }
    
    func setIsActive(_ isActive: Bool) {
        self.fillColor = isActive ? activeRed : inactiveYellow
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
