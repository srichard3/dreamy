//
//  CSView.swift
//  circle_snap
//
//  Created by Duy Nguyen on 11/4/24.
//
import SwiftUI

struct CSView: View {
    @ObservedObject var viewModel: CSViewModel
    
    var body: some View {
        ZStack {
            CircleTrackView()
            ComboView(combo: viewModel.gameState.combo)
            TargetNodeView(
                angle: viewModel.gameState.randomNodeAngle,
                scale: viewModel.gameState.scale,
                offset: viewModel.gameState.shakeOffset,
                isGlowing: viewModel.gameState.isGlowing,
                onTap: viewModel.handleTap
            )
            MovingIndicatorView(progress: viewModel.gameState.progress)
            
            // Uncomment for debugging
            // DebugOverlayView(viewModel: viewModel)
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}
