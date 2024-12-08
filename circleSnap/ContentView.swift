//
//  ContentView.swift
//  circle_snap
//
//  Created by Duy Nguyen on 12/7/24.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    @StateObject private var gameContext = CSGameContext()
    @StateObject private var conditionManager = GameConditionManager()
    
    var scene: SKScene {
        let scene = CSGameScene(gameContext: gameContext,
                                conditionManager: conditionManager)
        scene.size = CGSize(width: UIScreen.main.bounds.width,
                             height: UIScreen.main.bounds.height)
        scene.scaleMode = .aspectFill
        return scene
    }
    
    var body: some View {
        SpriteView(scene: scene)
            .ignoresSafeArea()
    }
}
