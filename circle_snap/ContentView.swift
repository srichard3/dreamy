//
//  ContentView.swift
//  circle_snap
//
//  Created by Duy Nguyen on 10/24/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Score: ")
                .font(.system(size: 25, weight: .bold))
                
            CircleLoopView()
        }
    }
}

#Preview {
    ContentView()
}

struct CircleLoopView: View {
    @State private var rotationAngle: Double = 0
    @State private var animationSpeed: Double = 2
    // Random angle for the node position
    @State private var randomNodeAngle: Double = Double.random(in: 0..<360)

    var body: some View {
        ZStack {
            // main circle
            Circle()
                .stroke(Color.gray.opacity(0.5), lineWidth: 2)
                .frame(width: 300, height: 300)

            
            // random node on the circle path
            Circle()
                .fill(Color.red)
                .frame(width: 50, height: 50)
                .offset(x: 150 * cos(randomNodeAngle * .pi / 180),
                        y: 150 * sin(randomNodeAngle * .pi / 180))

            
            // looping bar
            Rectangle()
                .frame(width: 20, height: 10)
                .foregroundColor(.blue)
                .offset(x: 150)
                .rotationEffect(.degrees(rotationAngle))
                .animation(
                    .linear(duration: animationSpeed)
                    .repeatForever(autoreverses: false),
                    value: rotationAngle
                )
                    }
        .onAppear {
            // start the animation for the looping bar
            rotationAngle = 360
        }
        .onTapGesture {
            // reposition the node to a new random angle on tap
            randomNodeAngle = Double.random(in: 0..<360)
        }
    }
}
