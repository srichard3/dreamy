import SwiftUI

struct WeatherView: View {
    let weather: WeatherType
    let startAngle: Double
    let size: Double = GameConstants.weatherPatchSize
    let trackWidth: Double = 45
    
    var body: some View {
        ZStack {
            // Weather zone background
            Arc(
                startAngle: startAngle,
                size: size,
                radius: GameConstants.circleRadius
            )
            .stroke(weatherColor.opacity(0.8), lineWidth: trackWidth)
            .overlay(
                Arc(
                    startAngle: startAngle,
                    size: size,
                    radius: GameConstants.circleRadius
                )
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

// Modified Arc shape to accept radius parameter
struct Arc: Shape {
    let startAngle: Double
    let size: Double
    let radius: Double
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
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

// TrackArc shape for the filled track segment
struct TrackArc: Shape {
    let startAngle: Double
    let size: Double
    let radius: Double
    let trackWidth: Double
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let start = startAngle * .pi / 180
        let end = (startAngle + size) * .pi / 180
        
        var path = Path()
        
        // Outer arc
        path.addArc(
            center: center,
            radius: radius + (trackWidth / 2),
            startAngle: .radians(start),
            endAngle: .radians(end),
            clockwise: false
        )
        
        // Inner arc
        path.addArc(
            center: center,
            radius: radius - (trackWidth / 2),
            startAngle: .radians(end),
            endAngle: .radians(start),
            clockwise: true
        )
        
        path.closeSubpath()
        return path
    }
}

