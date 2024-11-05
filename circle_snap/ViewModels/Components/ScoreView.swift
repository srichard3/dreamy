//
//  ScoreView.swift
//  circle_snap
//
//  Created by Duy Nguyen on 11/4/24.
//

import SwiftUI

struct ScoreView: View {
    @ObservedObject var viewModel: CSViewModel
    
    var body: some View {
        Text("Score: \(viewModel.gameState.score)")
    }
}
