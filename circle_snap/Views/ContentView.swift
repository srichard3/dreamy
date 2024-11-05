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
        VStack {
            ScoreView(viewModel: viewModel)
                .padding(50)
            CSView(viewModel: viewModel)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Make VStack fill screen
        .contentShape(Rectangle()) // Make entire area tappable

        .onTapGesture {
            viewModel.handleTap()
        }
    }
}

#Preview {
    ContentView()
}
