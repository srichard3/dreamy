//
//  ContentView.swift
//  circle_snap
//
//  Created by Duy Nguyen on 10/24/24.
//

import SwiftUI
import Combine

struct ContentView: View {
    @StateObject private var viewModel = CSViewModel()

    var body: some View {
        if viewModel.gameState.isGameOver {
            VStack {
                GameOverView(viewModel: viewModel)
            }
        } else {
            VStack {
                GameInfoView(viewModel: viewModel)
                LastHitAccuracyView(lastHitAccuracy: viewModel.gameState.lastHitAccuracy)
                    .padding(.vertical, 20)
                CSView(viewModel: viewModel)
                Spacer()
                GameTimerView(gameTimer: viewModel.gameState.gameTimer)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // make VStack fill screen
            .contentShape(Rectangle()) // make entire area tappable
            .background(Color("MainBackground"))
            .onTapGesture {
                viewModel.handleTap()
            }
        }
    }
}

#Preview {
    ContentView()
}

