//
//  LastHitAccuracy.swift
//  circle_snap
//
//  Created by Duy Nguyen on 11/4/24.
//

import SwiftUI

struct LastHitAccuracyView: View {
    @ObservedObject var viewModel: CSViewModel
    
    var body: some View {
        Text("\(viewModel.gameState.lastHitAccuracy)")
    }
}
