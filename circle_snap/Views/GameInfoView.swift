//
//  GameInfoView.swift
//  circle_snap
//
//  Created by Duy Nguyen on 11/4/24.
//

import SwiftUI

struct GameInfoView: View {
    @ObservedObject var viewModel: CSViewModel
    
    var body: some View {
        VStack(spacing: 10) {
            ScoreView(score: viewModel.gameState.score)
                .padding(.vertical, 20)
            
            HStack {
                LivesView(lives: viewModel.gameState.lives)
                    
                Spacer()
                HighestComboView(highestCombo: viewModel.gameState.highestCombo)
                    
            }
            .padding(.horizontal, 20)
        }
        .padding()
        .background(Color("Background")) // Custom color or defined in assets
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color("Accent"), lineWidth: 2) // Accent color for the border
        )
        .shadow(color: Color("Shadow").opacity(0.3), radius: 10, x: 0, y: 5) // Subtle shadow
        .padding(.horizontal, 20)
    }
}
