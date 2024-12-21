//
//  DYSoundManager.swift
//  circle_snap
//
//  Created by Sam Richard on 12/21/24.
//

import AVFoundation

class DYSoundManager {
    static let shared = DYSoundManager()
    
    private var musicPlayer: AVAudioPlayer?

    private init() {}

    // MARK: - Play Background Music
    func playBackgroundMusic(named fileName: String, withExtension fileExtension: String = "mp3", loop: Bool = true) {
        if let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension) {
            do {
                musicPlayer = try AVAudioPlayer(contentsOf: url)
                musicPlayer?.numberOfLoops = loop ? -1 : 0
                musicPlayer?.volume = 0.5
                musicPlayer?.prepareToPlay()
                musicPlayer?.play()
            } catch {
                print("Failed to play background music: \(fileName). Error: \(error)")
            }
        }
    }

    // MARK: - Stop Background Music
    func stopBackgroundMusic() {
        musicPlayer?.stop()
    }
    
    // MARK: - Pause and Resume Background Music
    func pauseBackgroundMusic() {
        musicPlayer?.pause()
    }
    
    func resumeBackgroundMusic() {
        musicPlayer?.play()
    }
    
    // MARK: - Adjust Volume
    func setBackgroundMusicVolume(_ volume: Float) {
        musicPlayer?.volume = volume
    }
    
}
