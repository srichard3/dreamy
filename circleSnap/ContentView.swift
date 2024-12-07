//
//  ContentView.swift
//  circle_snap
//
//  Created by Duy Nguyen on 12/6/24.
//

import SwiftUI
import SpriteKit

struct ContentView: UIViewRepresentable {
    func makeUIView(context: Context) -> SKView {
        let skView = SKView()

        // Initialize the GameScene
        let scene = CSGameScene(size: CGSize(width: 375, height: 812)) // Adjust size as needed
        scene.scaleMode = .resizeFill // Ensure the scene scales properly to fit the screen

        // Present the scene in the SKView
        skView.presentScene(scene)

        // Optional: Enable debug information
        skView.showsFPS = true
        skView.showsNodeCount = true

        return skView
    }
}
