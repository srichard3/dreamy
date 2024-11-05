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
            GameInfoView(viewModel: viewModel)
            LastHitAccuracyView(viewModel: viewModel)
                .padding(.vertical, 20)
            CSView(viewModel: viewModel)
            Spacer()
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
