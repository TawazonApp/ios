//
//  BackgroundAudioManager.swift
//  NewLife
//
//  Created by Shadi on 04/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit
import MediaPlayer

class BackgroundAudioManager: NSObject {
    
    static let shared = BackgroundAudioManager()
    var audios: [BackgroundAudioVM]!
    var mainBackgroundAudio: BackgroundAudioVM!
    
    var volume: Double = 0.5 {
        didSet {
            setVolume()
        }
    }
    
    private override init() {
        super.init()
        buildAudiosArray()
        mainBackgroundAudio = BackgroundAudioVM(type: nil, fileName: "MainBackgroundMusic.mp3", imageName: "", volume: volume)
        initializeNotification()
    }
    
    deinit {
          NotificationCenter.default.removeObserver(self)
    }
    
    private func initializeNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(enterForeground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(enterBackground(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    @objc private func enterForeground(_ notification: Notification) {
        playPauseBackgroundSounds()
    }
    
    @objc private func enterBackground(_ notification: Notification) {
        if AudioPlayerManager.shared.isPlaying() == false {
             pauseBackgroundSounds()
        }
    }
    
    private func buildAudiosArray() {
        let  calmnessWater = BackgroundAudioVM(type: .calmnessWater, fileName: "SeaWaves.wav", imageName: "CalmnessWater", volume: volume)
        
        let firewoodBurning = BackgroundAudioVM(type: .firewoodBurning, fileName: "Fire.mp3", imageName: "FirewoodBurning", volume: volume)
        
        let pouringRain = BackgroundAudioVM(type: .pouringRain, fileName: "Rain.mp3", imageName: "PouringRain", volume: volume)
        
        let birdsSinging = BackgroundAudioVM(type: .birdsSinging, fileName: "Birds.mp3", imageName: "BirdsSinging", volume: volume)
        
        let natureBeauty = BackgroundAudioVM(type: .natureBeauty, fileName: "Nature.mp3", imageName: "NatureBeauty", volume: volume)
        
        audios = [calmnessWater, firewoodBurning, pouringRain, birdsSinging, natureBeauty ]
        
    }
    
   private func setVolume() {
        for audio in audios {
            audio.volume = volume
        }
        mainBackgroundAudio.volume = volume
    }
    
    func stopSoundEffectsSounds() {
        for audio in audios {
            audio.stop()
        }
    }
    
   
    func pauseBackgroundSounds() {
        for audio in audios {
            if audio.playingStatus == .playing {
                audio.pause()
            }
        }
        if mainBackgroundAudio.playingStatus == .playing {
            mainBackgroundAudio.pause()
        }
    }
    
    func playPauseBackgroundSounds() {
        for audio in audios {
            if audio.playingStatus == .pause {
               audio.play()
            }
        }
        
        if mainBackgroundAudio.playingStatus == .pause {
            mainBackgroundAudio.play()
        }
       
    }
    
    func togglePlayPausePauseBackgroundSounds() {
        if mainBackgroundAudio.playingStatus == .playing {
            pauseBackgroundSounds()
        } else {
            playPauseBackgroundSounds()
        }
    }
    
    func playBackgroundSound() {
        if mainBackgroundAudio.playingStatus != .playing {
            mainBackgroundAudio.play()
        }
        NotificationCenter.default.post(name: .backgroundSoundStatusChanged, object: nil)
    }
    
    func stopBackgroundSound() {
        mainBackgroundAudio.stop()
        NotificationCenter.default.post(name: .backgroundSoundStatusChanged, object: nil)
    }
}

extension BackgroundAudioManager {
    
    func remoteControlReceivedWithEvent(_ event: UIEvent?) {
        if let _event = event {
            switch _event.subtype {
            case UIEvent.EventSubtype.remoteControlPlay:
                playPauseBackgroundSounds()
                break
            case UIEvent.EventSubtype.remoteControlPause:
                pauseBackgroundSounds()
                break
            case UIEvent.EventSubtype.remoteControlTogglePlayPause:
                self.togglePlayPausePauseBackgroundSounds()
                break
            default:
                break
            }
        }
    }
}
