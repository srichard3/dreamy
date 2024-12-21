//
//  DYBackgroundNode.swift
//  circle_snap
//
//  Created by Sam Richard on 12/18/24.
//


import SpriteKit

class DYBackgroundNode: SKNode {
    
    private let cycleDuration: TimeInterval = 20.0
    
    private var moonNode: SKSpriteNode?
    private var sunNode: SKSpriteNode?
    private var layoutInfo: DYLayoutInfo!
    
    private var movementRange: CGFloat = 0.0
    
    init(size: CGSize, layoutInfo: DYLayoutInfo) {
        self.layoutInfo = layoutInfo
        super.init()
        movementRange = size.height / 2
        setupBackground(size: size)
        addAssets(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBackground(size: CGSize) {
        let nightColors = [
            UIColor(hex: "#353A46").cgColor, // Dark Blue
            UIColor(hex: "#313E5F").cgColor, // Medium Blue
            UIColor(hex: "#7487B9").cgColor  // Light Blue
        ]
        
        let dayColors = [
            UIColor(hex: "#87CEFA").cgColor, // Light Sky Blue
            UIColor(hex: "#B0E0E6").cgColor, // Powder Blue
            UIColor(hex: "#ADD8E6").cgColor  // Light Blue
        ]
        
        let nightGradientTexture = createGradientTexture(colors: nightColors, size: size)
        let dayGradientTexture = createGradientTexture(colors: dayColors, size: size)
        
        let nightGradientNode = SKSpriteNode(texture: nightGradientTexture)
        nightGradientNode.size = size
        nightGradientNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        nightGradientNode.zPosition = -2
        nightGradientNode.alpha = 1.0
        nightGradientNode.name = "NightGradient"
        addChild(nightGradientNode)
        
        let dayGradientNode = SKSpriteNode(texture: dayGradientTexture)
        dayGradientNode.size = size
        dayGradientNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        dayGradientNode.zPosition = -2
        dayGradientNode.alpha = 0.0
        dayGradientNode.name = "DayGradient"
        addChild(dayGradientNode)
        
        let fadeToDay = SKAction.fadeAlpha(to: 1.0, duration: cycleDuration / 2)
        fadeToDay.timingMode = .easeInEaseOut
        
        let fadeToNight = SKAction.fadeAlpha(to: 0.0, duration: cycleDuration / 2)
        fadeToNight.timingMode = .easeInEaseOut
        
        let switchToDay = SKAction.run {        }
        let switchToNight = SKAction.run {        }
        
        let animateMoonDownAndSunUp = SKAction.run { [weak self] in
            guard let self = self, let moon = self.moonNode, let sun = self.sunNode else { return }
            
            let floatDuration = 2.0
            
            let moonFloatDown = SKAction.moveBy(x: 0, y: -self.movementRange, duration: floatDuration)
            moonFloatDown.timingMode = .easeInEaseOut
            let moonFadeIn = SKAction.fadeAlpha(to: 1.0, duration: floatDuration)
            let moonGroup = SKAction.group([moonFloatDown, moonFadeIn])
            
            let sunFloatUp = SKAction.moveBy(x: 0, y: self.movementRange, duration: floatDuration)
            sunFloatUp.timingMode = .easeInEaseOut
            let sunFadeOut = SKAction.fadeAlpha(to: 0.0, duration: floatDuration)
            let sunGroup = SKAction.group([sunFloatUp, sunFadeOut])
            
            moon.run(moonGroup)
            sun.run(sunGroup)
        }
        
        let animateSunDownAndMoonUp = SKAction.run { [weak self] in
            guard let self = self, let moon = self.moonNode, let sun = self.sunNode else { return }
            
            let floatDuration = 2.0
            
            let sunFloatDown = SKAction.moveBy(x: 0, y: -self.movementRange, duration: floatDuration)
            sunFloatDown.timingMode = .easeInEaseOut
            let sunFadeIn = SKAction.fadeAlpha(to: 1.0, duration: floatDuration)
            let sunGroup = SKAction.group([sunFloatDown, sunFadeIn])
            
            let moonFloatUp = SKAction.moveBy(x: 0, y: self.movementRange, duration: floatDuration)
            moonFloatUp.timingMode = .easeInEaseOut
            let moonFadeOut = SKAction.fadeAlpha(to: 0.0, duration: floatDuration)
            let moonGroup = SKAction.group([moonFloatUp, moonFadeOut])
            
            sun.run(sunGroup)
            moon.run(moonGroup)
        }
        
        let halfFadeDuration = cycleDuration / 4
        
        let fadeToDaySequence = SKAction.group([
            fadeToDay,
            SKAction.sequence([
                SKAction.wait(forDuration: halfFadeDuration),
                animateMoonDownAndSunUp
            ])
        ])
        
        let fadeToNightSequence = SKAction.group([
            fadeToNight,
            SKAction.sequence([
                SKAction.wait(forDuration: halfFadeDuration),
                animateSunDownAndMoonUp
            ])
        ])
        
        let cycleSequence = SKAction.sequence([
            switchToDay,
            fadeToDaySequence,
            switchToNight,
            fadeToNightSequence
        ])
        
        let cycleForever = SKAction.repeatForever(cycleSequence)
        
        dayGradientNode.run(cycleForever)
    }
    
    /// Creates a gradient texture with specified colors and size.
    /// - Parameters:
    ///   - colors: An array of `CGColor` representing the gradient stops.
    ///   - size: The size of the gradient texture.
    /// - Returns: An `SKTexture` representing the gradient.
    private func createGradientTexture(colors: [CGColor], size: CGSize) -> SKTexture {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.locations = (0..<colors.count).map { NSNumber(value: Double($0) / Double(colors.count - 1)) }
        gradientLayer.frame = CGRect(origin: .zero, size: size)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return SKTexture() }
        gradientLayer.render(in: context)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return SKTexture() }
        UIGraphicsEndImageContext()
        
        return SKTexture(image: image)
    }
    

    private func addAssets(size: CGSize) {
        let assetPositions: [String: CGPoint] = [
            "dy_cloud_1": CGPoint(x: size.width * 0.25, y: size.height * 0.82),
            "dy_cloud_2": CGPoint(x: size.width * 0.7, y: size.height * 0.68),
            "dy_cloud_3": CGPoint(x: size.width * 0.4, y: size.height * 0.08),
            "dy_star_1": CGPoint(x: size.width * 0.59, y: size.height * 0.78),
            "dy_star_2": CGPoint(x: size.width * 0.15, y: size.height * 0.7),
            "dy_star_3": CGPoint(x: size.width * 0.1, y: size.height * 0.2),
            "dy_star_4": CGPoint(x: size.width * 0.85, y: size.height * 0.12),
            "dy_moon": CGPoint(x: size.width * 0.8, y: size.height * 0.875),
            "dy_sun": CGPoint(x: size.width * 0.8, y: size.height * 0.875 + movementRange), // Initially off-screen above
            "dy_twinkle_1": CGPoint(x: size.width * 0.36, y: size.height * 0.71),
            "dy_twinkle_2": CGPoint(x: size.width * 0.2, y: size.height * 0.62),
            "dy_twinkle_3": CGPoint(x: size.width * 0.9, y: size.height * 0.25),
            "dy_twinkle_4": CGPoint(x: size.width * 0.62, y: size.height * 0.15)
        ]
        
        let baseScale: CGFloat = size.width / 440.0

        for (assetName, position) in assetPositions {
            let assetNode = SKSpriteNode(imageNamed: assetName)
            
            if assetName.contains("sun") {
                assetNode.position = CGPoint(x: size.width * 0.8, y: size.height * 0.875)
                assetNode.alpha = 1.0
                sunNode = assetNode
            } else if assetName.contains("moon") {
                assetNode.position = CGPoint(x: size.width * 0.8, y: size.height * 0.875 + movementRange)
                assetNode.alpha = 0.0
                moonNode = assetNode
            } else {
                assetNode.position = position
            }
            
            assetNode.setScale(baseScale)
            addChild(assetNode)
            
            if assetName.contains("cloud") {
                applyFloatingAndScaling(to: assetNode, movementRange: layoutInfo.cloudMovementRange, scaleRange: 0.05)
            } else if assetName.contains("star") || assetName.contains("twinkle") {
                applyTwinkling(to: assetNode)
            } else if assetName.contains("moon") || assetName.contains("sun") {
                applyPulsing(to: assetNode)
            }
        }
    }
    
    private func applyFloatingAndScaling(to node: SKSpriteNode, movementRange: CGFloat, scaleRange: CGFloat) {
        let duration = CGFloat.random(in: 6.0...10.0)
        let movementAmplitude = movementRange
        let scaleAmplitude = scaleRange
        let direction: CGFloat = CGFloat.random(in: 0...1) < 0.5 ? -1.0 : 1.0
        
        let moveBy = SKAction.moveBy(x: direction * movementAmplitude, y: 0, duration: duration / 2)
        moveBy.timingMode = .easeInEaseOut
        let moveBack = moveBy.reversed()
        moveBack.timingMode = .easeInEaseOut
        let floatingSequence = SKAction.sequence([moveBy, moveBack])
        let floatingForever = SKAction.repeatForever(floatingSequence)
        
        let scaleUp = SKAction.scale(by: 1.0 + scaleAmplitude, duration: duration / 2)
        scaleUp.timingMode = .easeInEaseOut
        let scaleDown = SKAction.scale(by: 1.0 - scaleAmplitude, duration: duration / 2)
        scaleDown.timingMode = .easeInEaseOut
        let scalingSequence = SKAction.sequence([scaleUp, scaleDown])
        let scalingForever = SKAction.repeatForever(scalingSequence)
        
        let group = SKAction.group([floatingForever, scalingForever])
        node.run(group)
    }
    
    private func applyTwinkling(to node: SKSpriteNode) {
        let duration = CGFloat.random(in: 3.0...5.0)
        let scaleRange: CGFloat = 0.1
        
        let scaleUp = SKAction.scale(to: 1.0 + scaleRange, duration: duration / 2)
        scaleUp.timingMode = .easeInEaseOut
        let scaleDown = SKAction.scale(to: 1.0, duration: duration / 2)
        scaleDown.timingMode = .easeInEaseOut
        let twinkleSequence = SKAction.sequence([scaleUp, scaleDown])
        let twinkleForever = SKAction.repeatForever(twinkleSequence)
        
        node.run(twinkleForever)
    }
    
    private func applyPulsing(to node: SKSpriteNode) {
        let duration = CGFloat.random(in: 2.0...4.0)
        let scaleRange: CGFloat = 0.1
        
        let scaleUp = SKAction.scale(to: 1.0 + scaleRange, duration: duration / 2)
        scaleUp.timingMode = .easeInEaseOut
        let scaleDown = SKAction.scale(to: 1.0, duration: duration / 2)
        scaleDown.timingMode = .easeInEaseOut
        let pulsingSequence = SKAction.sequence([scaleUp, scaleDown])
        let pulsingForever = SKAction.repeatForever(pulsingSequence)
        
        node.run(pulsingForever)
    }
}

// Extension to initialize UIColor with hex string
extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.hasPrefix("#") ? String(hexSanitized.dropFirst()) : hexSanitized
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
