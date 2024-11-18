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
    @StateObject private var fpsTracker = FPSTracker()


    var body: some View {
        switch viewModel.gameStatus {
        case .notStarted:
            StartView(viewModel: viewModel)
            
        case .inProgress:
            VStack {
                GameInfoView(viewModel: viewModel)
                LastHitAccuracyView(lastHitAccuracy: viewModel.gameState.lastHitAccuracy)
                    .padding(.vertical, 20)
                CSView(viewModel: viewModel)
                Spacer()
                //GameTimerView(gameTimer: viewModel.gameState.gameTimer)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .background(Color("MainBackground"))
            .onTapGesture {
                viewModel.handleTap()
            }

        case .gameOver:
            GameOverView(viewModel: viewModel)
        }
    }
}

#Preview {
    ContentView()
}

