//
//  CircleTrackView.swift
//  circle_snap
//
//  Created by Duy Nguyen on 11/4/24.
//

import SwiftUI

struct CircleTrackView: View {
    var body: some View {
        Circle()
            .stroke(.white.opacity(0.8), lineWidth: 45)
            .frame(width: 310, height: 310)
    }
}
