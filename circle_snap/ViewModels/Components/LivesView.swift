//
//  LivesView.swift
//  circle_snap
//
//  Created by Duy Nguyen on 11/4/24.
//

import SwiftUI

struct LivesView: View {
    @ObservedObject var viewModel: CSViewModel
    
    var body: some View {
        Text("Lives: \(viewModel.gameState.lives)")
    }
}
