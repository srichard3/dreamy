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
            .stroke(Color.gray.opacity(0.5), lineWidth: 2)
            .frame(width: 300, height: 300)
    }
}
