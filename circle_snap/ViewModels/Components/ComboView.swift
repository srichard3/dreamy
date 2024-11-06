//
//  ComboView.swift
//  circle_snap
//
//  Created by Duy Nguyen on 11/4/24.
//

import SwiftUI

struct ComboView: View {
    let combo: Int
    
    var body: some View {
        Text("\(combo)")
            .font(.system(size: 30))
            .bold()
            .foregroundColor(Color.white)
    }
}
