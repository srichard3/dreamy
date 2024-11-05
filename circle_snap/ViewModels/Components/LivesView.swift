//
//  LivesView.swift
//  circle_snap
//
//  Created by Duy Nguyen on 11/4/24.
//

import SwiftUI

struct LivesView: View {
    let lives: Int
    
    var body: some View {
        Text("Lives: \(lives)")
            .font(.system(size: 25, weight: .bold))
            .foregroundColor(.white)
    }
}
