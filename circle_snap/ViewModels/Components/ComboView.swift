//
//  ComboView.swift
//  circle_snap
//
//  Created by Duy Nguyen on 11/4/24.
//

import SwiftUI

struct ComboView: View {
    @ObservedObject var viewModel: CSViewModel
    
    var body: some View {
        Text("\(viewModel.gameState.combo)")
            .font(.system(size: 25, weight: .bold))
    }
}
