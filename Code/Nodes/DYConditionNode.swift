//
//  DYConditionNode.swift
//  circle_snap
//
//  Created by Duy Nguyen on 12/7/24.
//

import SpriteKit

public enum DYConditionType: CaseIterable {
    case none
    case sand
    case ice
    case mud
    case fog

    var textureName: String? {
        switch self {
        case .none:
            return nil
        case .sand:
            return "dy_sand"
        case .ice:
            return "dy_ice"
        case .mud:
            return "dy_mud"
        case .fog:
            return "dy_fog"
        }
    }

    var tutorialTextureName: String? {
        switch self {
        case .none:
            return nil
        case .sand:
            return "dy_sand_tutorial"
        case .ice:
            return "dy_ice_tutorial"
        case .mud:
            return "dy_mud_tutorial"
        case .fog:
            return "dy_fog_tutorial"
        }
    }

    static func getRandomCondition() -> DYConditionType {
        let availableConditions = DYConditionType.allCases.filter { $0 != .none }
        return availableConditions.randomElement() ?? .none
    }
}

class DYConditionNode: SKNode {
    var layoutInfo: DYLayoutInfo
    var conditionType: DYConditionType
    var startAngle: CGFloat
    var radius: CGFloat
    var trackWidth: CGFloat
    var conditionPatchSize: CGFloat

    private var conditionSprite: SKSpriteNode!
    var angularSize: CGFloat = 0.0
    var scale: CGFloat = 0.0

    init(layoutInfo: DYLayoutInfo) {
        self.layoutInfo = layoutInfo
        self.conditionType = .none
        self.startAngle = CGFloat.random(in: 0..<360)
        self.radius = layoutInfo.circleTrackRadius * 0.94
        self.trackWidth = layoutInfo.circleTrackLineWidth
        self.conditionPatchSize = layoutInfo.conditionPatchSize

        super.init()

        updatePosition()
        setupConditionSprite()
    }
    
    private func updatePosition() {
        let angleRadians = startAngle * CGFloat.pi / 180
        let x = radius * cos(angleRadians - .pi / 2)
        let y = radius * sin(angleRadians - .pi / 2)
        self.position = CGPoint(x: x, y: y)
        self.zRotation = angleRadians
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConditionSprite() {
        guard let textureName = conditionType.textureName else { return }
        let texture = SKTexture(imageNamed: textureName)

        conditionSprite = SKSpriteNode(texture: texture)
        conditionSprite.zPosition = zPositionForCondition()
        conditionSprite.alpha = 0
        conditionSprite.setScale(0.0)
        addChild(conditionSprite)
        
        let textureWidth = texture.size().width
        scale = layoutInfo.conditionScaleReference / textureWidth
        
        angularSize = (textureWidth / (2 * CGFloat.pi * radius)) * 360
    }
    
    func updateConditionForCurrentWeather() {
        conditionSprite?.removeFromParent()
        guard let textureName = conditionType.textureName else { return }
        let texture = SKTexture(imageNamed: textureName)
        
        conditionSprite = SKSpriteNode(texture: texture)
        conditionSprite.zPosition = zPositionForCondition()
        conditionSprite.alpha = 1.0
        conditionSprite.setScale(1.0)
        addChild(conditionSprite)
        
        let textureWidth = texture.size().width
        scale = layoutInfo.conditionScaleReference / textureWidth
        
        angularSize = (textureWidth / (2 * CGFloat.pi * radius)) * 360
        
        self.startAngle = CGFloat.random(in: 0..<360)
        updateConditionSprite()
        updatePosition()
        animateConditionAppearance()
    }

    private func zPositionForCondition() -> CGFloat {
        switch conditionType {
        case .fog:
            return 5
        case .mud, .sand, .ice:
            return 0
        case .none:
            return 0
        }
    }

    private func updateConditionSprite() {
        conditionSprite?.removeFromParent()
        setupConditionSprite()
    }

    func randomizeAppearance() {
        self.startAngle = CGFloat.random(in: 0..<360)
        self.conditionType = DYConditionType.getRandomCondition()
        updateConditionSprite()
        updatePosition()
        animateConditionAppearance()
    }
    
    private func animateConditionAppearance() {
        guard conditionSprite != nil else { return }
        conditionSprite.setScale(0.0)
        conditionSprite.alpha = 0
        let fadeIn = SKAction.fadeIn(withDuration: 0.3)
        let scaleUp = SKAction.scale(to: scale, duration: 0.3)
        conditionSprite.run(SKAction.group([fadeIn, scaleUp]))
        
    }

    func applyConditionEffects(progress: Double) -> Double {
        var progressChange = progress

        switch conditionType {
        case .ice:
            progressChange *= DYLayoutInfo.iceSpeedMultiplier
        case .sand:
            progressChange *= DYLayoutInfo.sandSpeedMultiplier
        case .mud:
            let scaledShakeAmplitude = DYLayoutInfo.mudBaseShakeAmplitude + (DYLayoutInfo.mudShakeScalingFactor * progress)
            let shakeFactor = Double.random(in: -scaledShakeAmplitude...scaledShakeAmplitude)
            progressChange += shakeFactor
        case .fog:
            break
        case .none:
            break
        }

        return progressChange
    }

    func isAngleInRange(_ angle: Double, start: Double) -> Bool {
        let halfAngularSize = Double(angularSize / 2)
        let conditionStart = start - halfAngularSize
        let conditionEnd = start + halfAngularSize
        if conditionStart <= conditionEnd {
            return angle >= conditionStart && angle <= conditionEnd
        } else {
            return angle >= conditionStart || angle <= conditionEnd
        }
    }
}
