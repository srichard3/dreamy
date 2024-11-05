//
//  HighestComboView.swift
//  circle_snap
//
//  Created by Duy Nguyen on 11/4/24.
//

import SwiftUI

struct HighestComboView: View {
    let highestCombo: Int
    
    var body: some View {
        Text("Highest: \(highestCombo)")
            .font(.system(size: 25, weight: .bold))
            .foregroundColor(.white)

    }
}
