import SpriteKit


struct GameState {
    // Game progress and properties
    var progress: Double = 0.0
    var randomNodeAngle: Double = Double.random(in: 0..<360)
    var scale: CGFloat = 1.0
    var shakeOffset: CGFloat = 0.0
    var isGlowing: Bool = false
    var lastClickProgress: Double = 0.0
        
    // Animation modifiers
    var animationSpeed: Double = 3.5
    
    // Condition system
    var currentCondition: ConditionType = .none
    var conditionPatchStartAngle: Double = 0
    var isInConditionPatch: Bool = false
    
    // UI-related properties
    var isBarVisible: Bool = true
}


public enum ConditionType {
    case none
    case sand
    case ice
    case wind
    case fog
}


public enum GameStatus {
    case gameOver
    case inProgress
    case notStarted
}
