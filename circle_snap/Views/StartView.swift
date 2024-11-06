//
//  StartView.swift
//  circle_snap
//
//  Created by Duy Nguyen on 11/5/24.
//
import SwiftUI

struct StartView: View {
    @ObservedObject var viewModel: CSViewModel

    var body: some View {
        Button("Start Game") {
            viewModel.gameStatus = .inProgress
            viewModel.onAppear() // Initialize game-related functions
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(8)
    }
}
