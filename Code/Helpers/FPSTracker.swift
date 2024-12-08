//
//  FPSTracker.swift
//  circle_snap
//
//  Created by Mario Lopez on 12/6/24.
//

import SpriteKit

class FPSTracker {
    private var lastUpdateTime: TimeInterval = 0
    private var frameCount: Int = 0
    private(set) var fps: Int = 0

    func update(currentTime: TimeInterval) {
        // If this is the first frame, initialize the timer
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime
            return
        }

        frameCount += 1
        let elapsed = currentTime - lastUpdateTime

        if elapsed >= 1.0 {
            // Calculate FPS and reset counters
            fps = frameCount
            frameCount = 0
            lastUpdateTime = currentTime
        }
    }
}
