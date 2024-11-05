//
//  ScoreView.swift
//  circle_snap
//
//  Created by Duy Nguyen on 11/4/24.
//

import SwiftUI

struct ScoreView: View {
    let score: Int
    var body: some View {
        Text("Score: " + String(score))
    }
}
