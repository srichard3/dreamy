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
            StartView()
        }
    }
}

#Preview {
    ContentView()
}

