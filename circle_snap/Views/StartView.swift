//
//  StartView.swift
//  circle_snap
//
//  Created by Duy Nguyen on 11/5/24.
//
import SwiftUI

struct StartView: View {
    @StateObject private var viewModel = CSViewModel()

    var body: some View {
        if viewModel.gameState.isGameStarted {
            // Show game view after Start Game button is pressed
            VStack {
                GameInfoView(viewModel: viewModel)
                LastHitAccuracyView(lastHitAccuracy: viewModel.gameState.lastHitAccuracy)
                    .padding(.vertical, 20)
                CSView(viewModel: viewModel)
                Spacer()
                GameTimerView(gameTimer: viewModel.gameState.gameTimer)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Make VStack fill screen
            .contentShape(Rectangle()) // Make entire area tappable
            .background(Color("MainBackground"))
            .onTapGesture {
                viewModel.handleTap()
            }
        } else {
            // Show Start Game button initially
            Button("Start Game") {
                viewModel.gameState.isGameStarted = true // Update state to show game view
                viewModel.onAppear() // Start game-related processes (e.g., rotation, countdown)
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
    }
}
