//
//  LastHitAccuracy.swift
//  circle_snap
//
//  Created by Duy Nguyen on 11/4/24.
//

import SwiftUI

struct LastHitAccuracyView: View {
    let lastHitAccuracy: String
    
    var body: some View {
        Text(lastHitAccuracy)
            .font(.system(size: 25, weight: .bold))
            .foregroundColor(.white)

    }
}
