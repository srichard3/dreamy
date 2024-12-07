////
////  MovingIndicator.swift
////  circle_snap
////
////  Created by Duy Nguyen on 11/4/24.
////
//import SwiftUI
//
//struct MovingIndicatorView: View {
//    let progress: Double
//    let circleRadius: CGFloat = GameConstants.circleRadius
//    let isBarVisible: Bool
//    
//    var body: some View {
//        GeometryReader { geometry in
//            ZStack {
//                IndicatorShape(progress: progress, circleRadius: circleRadius)
//                    .fill(LinearGradient(
//                        gradient: Gradient(colors: [.blue, .purple]),
//                        startPoint: .leading,
//                        endPoint: .trailing
//                    ))
//                    .frame(width: 10, height: 50)
//                    .rotationEffect(Angle(degrees: (progress * 360) - 90))
//                    .position(
//                        x: geometry.size.width / 2 + circleRadius * cos((progress * 360) * .pi / 180),
//                        y: geometry.size.height / 2 + circleRadius * sin((progress * 360) * .pi / 180)
//                    )
//                    .cornerRadius(50)
//                    .opacity(isBarVisible ? 1.0 : 0.1)            }
//        }
//    }
//}
//
//struct IndicatorShape: Shape {
//    let progress: Double
//    let circleRadius: CGFloat
//    
//    func path(in rect: CGRect) -> Path {
//        var path = Path()
//        
//        let width: CGFloat = 8
//        let height: CGFloat = 45
//        let cornerRadius: CGFloat = 10
//        
//        let startX = rect.midX - width / 2
//        let startY = rect.midY - height / 2
//        
//        path.move(to: CGPoint(x: startX, y: startY))
//        path.addLine(to: CGPoint(x: startX + width, y: startY))
//        path.addLine(to: CGPoint(x: startX + width, y: startY + height))
//        path.addLine(to: CGPoint(x: startX, y: startY + height))
//        path.addLine(to: CGPoint(x: startX, y: startY))
//        path.addRoundedRect(in: CGRect(x: startX, y: startY, width: width, height: height), cornerSize: CGSize(width: cornerRadius, height: cornerRadius))
//        
//        return path
//    }
//}
