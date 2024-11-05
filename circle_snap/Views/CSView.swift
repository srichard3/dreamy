//
//  CSView.swift
//  circle_snap
//
//  Created by Duy Nguyen on 11/4/24.
//
import SwiftUI

struct CSView: View {
    @StateObject private var viewModel = CSViewModel()
    
    var body: some View {
        ZStack {
            CircleTrackView()
            TargetNodeView(
                angle: viewModel.gameState.randomNodeAngle,
                scale: viewModel.gameState.scale,
                offset: viewModel.gameState.shakeOffset,
                isGlowing: viewModel.gameState.isGlowing,
                onTap: viewModel.checkAlignmentAndAnimate
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
