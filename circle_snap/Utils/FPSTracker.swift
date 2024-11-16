//
//  FPSTracker.swift
//  circle_snap
//
//  Created by Duy Nguyen on 11/16/24.
//

import SwiftUI

class FPSTracker: ObservableObject {
    @Published var fps: Int = 0
    
    private var displayLink: CADisplayLink?
    private var lastUpdate: CFTimeInterval = 0
    private var frameCount: Int = 0

    init() {
        startTracking()
    }

    private func startTracking() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateFPS))
        displayLink?.add(to: .main, forMode: .common)
    }

    @objc private func updateFPS() {
        guard let displayLink = displayLink else { return }
        
        if lastUpdate == 0 {
            lastUpdate = displayLink.timestamp
            return
        }
        
        frameCount += 1
        let elapsed = displayLink.timestamp - lastUpdate
        
        if elapsed >= 1.0 {
            fps = frameCount
            frameCount = 0
            lastUpdate = displayLink.timestamp
        }
    }

    deinit {
        displayLink?.invalidate()
    }
}
