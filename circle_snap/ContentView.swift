//
//  ContentView.swift
//  circle_snap
//
//  Created by Duy Nguyen on 10/24/24.
//

import SwiftUI
import Combine


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
    @State private var animationSpeed: Double = 5
    // Random angle for the node position
    @State private var randomNodeAngle: Double = Double.random(in: 0..<360)
    // Smooth the circle jumping round
    @State private var scale: CGFloat = 1.0
    @State private var timer: AnyCancellable?
    @State private var progress: Double = 0.0 // Progress of the animation cycle in percentage
 
    @State private var shakeOffset: CGFloat = 0
    @State private var isGlowing: Bool = false // New state variable for glowing effect
    
    @State private var angleTolerance: Double = 0.0 // how exact does the click need to  be
    
    // can be moved into the isInRange func but are here for testing
    @State private var redCircleStartAngle: Double = 0.0
    @State private var redCircleEndAngle: Double = 0.0
    
    // just for testing
    @State private var clickedOn: Double = 0.0 // Progress of the animation cycle in percentage
    @State private var lastSuccessNode: Double = 0
    @State private var lastSuccessRect: Double = 2


    let timerInterval: TimeInterval = 0.001 // Timer interval in seconds


    
    // Circle radius
       let circleRadius: CGFloat = 150.0
       let nodeRadius: CGFloat = 25.0  // Half of the red circle's width (50)


    var body: some View {
        ZStack {
            // main circle
            Circle()
                .stroke(Color.gray.opacity(0.5), lineWidth: 2)
                .frame(width: 300, height: 300)

            
            // random node on the circle path
            Circle()
                .fill(Color.red)
                .scaleEffect(scale)
                .frame(width: nodeRadius * 2, height: nodeRadius * 2)
                .offset(x: circleRadius * cos(randomNodeAngle * .pi / 180) + shakeOffset,
                        y: circleRadius * sin(randomNodeAngle * .pi / 180))
                .shadow(color: isGlowing ? Color.red.opacity(0.8) : Color.clear, radius: 10, x: 0, y: 0) // Glowing effect when click should work
                .onTapGesture {
                    checkAlignmentAndAnimate()
                }
            
            // looping bar
            Rectangle()
                .frame(width: 20, height: 10)
                .foregroundColor(.blue)
                .offset(x: circleRadius)
                .rotationEffect(.degrees(rotationAngle))
                .animation(
                    .linear(duration: animationSpeed)
                    .repeatForever(autoreverses: false),
                    value: rotationAngle
                )

//   // for testing
//            VStack {
//                Text("Current Progress: \(Int(progress * 360))%")
//                    .font(.headline)
//                    .foregroundColor(.black)
//                
//                Text("Progress at Last Click: \(Int(clickedOn * 360))%")
//                    .font(.headline)
//                    .foregroundColor(.black)
//                
//                Text("R Circle Angle (%): \(Double(randomNodeAngle))°")
//                    .font(.headline)
//                    .foregroundColor(.black)
//                
//                Text("R Circle Angle (norm): \(Double(redCircleStartAngle))")
//                    .font(.headline)
//                    .foregroundColor(.black)
//                
//                Text("LSucces Node Angle: \(Double(redCircleEndAngle))°")
//                    .font(.headline)
//                    .foregroundColor(.black)
//            }
            
        }
        .onAppear {
            // Recalculate angle tolerance at startup
            recalculateAngleTolerance()
            // start the animation for the looping bar
            startRotation()
        }
        
        
    }
    
    private func calculateAngleTolerance() -> Double {
            return ((Double(nodeRadius) / Double(circleRadius)) * 180 / .pi) * 1.5
        }

    // Recalculate angle tolerance when nodeRadius or circleRadius changes
    private func recalculateAngleTolerance() {
        angleTolerance = calculateAngleTolerance()
    }
    func normalizeAngle(_ angle: Double) -> Double {
        var normalized = angle.truncatingRemainder(dividingBy: 360)
        if normalized < 0 { normalized += 360 }
        return normalized
    }
    func isRectangleInRange() -> Bool {
        // Define the range of angles for the red circle
        redCircleStartAngle = randomNodeAngle - angleTolerance
        redCircleEndAngle = randomNodeAngle + angleTolerance

        // Normalize the angles to be within 0-360
        redCircleStartAngle = normalizeAngle(redCircleStartAngle)
        redCircleEndAngle = normalizeAngle(redCircleEndAngle)

        // Adjust rectangle angle and normalize it within 0-360
        let rectangleAngle = progress * 360
        let adjustedRectangleAngle = (rectangleAngle -25).truncatingRemainder(dividingBy: 360)
        let normalizedRectangleAngle = adjustedRectangleAngle < 0 ? adjustedRectangleAngle + 360 : adjustedRectangleAngle
            
        // Check if the rectangle angle is within the red circle's range
        let inRange: Bool
        if redCircleStartAngle < redCircleEndAngle {
            // Regular range check
            inRange = normalizedRectangleAngle >= redCircleStartAngle && normalizedRectangleAngle <= redCircleEndAngle
        } else {
            // Wraparound range check
            inRange = normalizedRectangleAngle >= redCircleStartAngle || normalizedRectangleAngle <= redCircleEndAngle
        }

        return inRange
    }
    
    func checkAlignmentAndAnimate() {
        // Calculate the angle tolerance based on the red circle's radius
       
        clickedOn = progress
        // Trigger animation if within range
        if isGlowing {
            lastSuccessRect = progress // Track the clicked position
            lastSuccessNode = randomNodeAngle

            // Trigger animation for red circle "collision"
            withAnimation(.easeIn(duration: 0.2)) {
                scale = 0.0
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                // Move the red circle to a new random position
                randomNodeAngle = Double.random(in: 0..<360)

                withAnimation(.easeOut(duration: 0.2)) {
                    scale = 1.0 // Reset the scale after movement
                }
            }
        }else{
            withAnimation(Animation.easeInOut(duration: 0.05).repeatCount(3, autoreverses: true)) {
                  scale = 0.95 // Slight shrink
                  shakeOffset = 10 // Move slightly to the right
              }
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                  withAnimation {
                      scale = 1.0 // Return to original size
                      shakeOffset = 0 // Center position
                  }
              }
        }
    }

    func startRotation() {
        let startTime = Date()
        rotationAngle = 360

        timer = Timer.publish(every: timerInterval, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                let elapsedTime = Date().timeIntervalSince(startTime)
                let cycleProgress = elapsedTime.truncatingRemainder(dividingBy: animationSpeed) / animationSpeed
                progress = cycleProgress
                let inRange = isRectangleInRange();
                if(inRange){
                    isGlowing = true;
                }else{
                    isGlowing = false;
                }
        }
    }
}
