////
////  DebugOverlayView.swift
////  circle_snap
////
////  Created by Duy Nguyen on 11/4/24.
////
//
//import SwiftUI
//
//struct DebugOverlayView: View {
//    @ObservedObject var viewModel: CSViewModel
//    
//    var body: some View {
//        VStack {
//            Text("Current Progress: \(Int(viewModel.gameState.progress * 360))°")
//            Text("Last Click Progress: \(Int(viewModel.gameState.lastClickProgress * 360))°")
//            Text("Target Angle: \(viewModel.gameState.randomNodeAngle)°")
//            Text("Range Start: \(viewModel.debugStartAngle)°")
//            Text("Range End: \(viewModel.debugEndAngle)°")
//        }
//        .font(.caption)
//        .foregroundColor(.white)
//    }
//}
