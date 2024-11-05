//
//  GameTimerView.swift
//  circle_snap
//
//  Created by Duy Nguyen on 11/5/24.
//

import SwiftUI

struct GameTimerView: View {
    let gameTimer: Int
    
    var body: some View {
        Text("Time Remaining: \(gameTimer)")
            .font(.system(size: 25, weight: .bold))
            .foregroundColor(.white)
            .padding()
            .background(Color.black.opacity(0.7))
            .cornerRadius(10)
    }
}
