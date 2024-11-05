//
//  GameOverView.swift
//  circle_snap
//
//  Created by Duy Nguyen on 11/5/24.
//
import SwiftUI

struct GameOverView: View {
    @ObservedObject var viewModel: CSViewModel

    var body: some View {
        Text("Game Over")
            .font(.largeTitle)
            .foregroundColor(.red)
        // reset all game state variables
        Button("Play Again") {
            viewModel.gameState.isGameOver = false
            viewModel.gameState.score = 0
            viewModel.gameState.combo = 0
            viewModel.gameState.highestCombo = 0
            viewModel.gameState.lastHitAccuracy = ""
            viewModel.gameState.lives = 3
        }
    }
}
