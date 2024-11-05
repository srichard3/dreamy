//
//  MovingIndicator.swift
//  circle_snap
//
//  Created by Duy Nguyen on 11/4/24.
//
import SwiftUI

struct MovingIndicatorView: View {
    let progress: Double
    
    var body: some View {
        Rectangle()
            .frame(width: 15, height: 15)
            .foregroundColor(.blue)
            .offset(
                x: GameConstants.circleRadius * cos((progress * 360) * .pi / 180),
                y: GameConstants.circleRadius * sin((progress * 360) * .pi / 180)
            )
    }
}
