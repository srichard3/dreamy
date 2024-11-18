//
//  WeatherView.swift
//  circle_snap
//
//  Created by Duy Nguyen on 11/17/24.
//
import SwiftUI

struct WeatherView: View {
    let weather: WeatherType
    let startAngle: Double
    let size: Double = GameConstants.weatherPatchSize
    
    var body: some View {
        ZStack {
            // Weather zone background
            Arc(startAngle: startAngle, size: size)
                .stroke(weatherColor.opacity(0.3), lineWidth: 8)
                .overlay(
                    Arc(startAngle: startAngle, size: size)
                        .stroke(weatherColor, lineWidth: 2)
                )
        }
    }
    
    private var weatherColor: Color {
        switch weather {
        case .wind:
            return .green
        case .none:
            return .clear
        }
    }
}


struct Arc: Shape {
    let startAngle: Double
    let size: Double
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let start = startAngle * .pi / 180
        let end = (startAngle + size) * .pi / 180
        
        var path = Path()
        path.addArc(
            center: center,
            radius: radius,
            startAngle: .radians(start),
            endAngle: .radians(end),
            clockwise: false
        )
        return path
    }
}
