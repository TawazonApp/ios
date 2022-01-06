//
//  BackgroundAudioVM.swift
//  NewLife
//
//  Created by Shadi on 04/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

enum BackgroundAudioType: String, CaseIterable {
    case calmnessWater = "calmnessWaterAudioTitle"
    case firewoodBurning = "firewoodBurningAudioTitle"
    case pouringRain =  "pouringRainAudioTitle"
    case birdsSinging = "birdsSingingAudioTitle"
    case natureBeauty = "natureBeautyAudioTitle"
    
    var title: String {
        return self.rawValue.localized
    }
}

class BackgroundAudioVM: NSObject {
    
    enum PlayingStatus {
        case playing
        case pause
        case stop
    }
    let type: BackgroundAudioType?
    let fileName: String!
    let imageName: String!
    var playingStatus: PlayingStatus = .stop
    var player: AudioPlayer?
    let maxVolumePercentage: Double = 0.7
    var volume: Double = 0.4 {
        didSet {
            setVolume()
        }
    }
    
    var title: String {
        return type?.title ?? ""
    }

    init(type: BackgroundAudioType?, fileName: String, imageName: String, volume: Double) {
        self.type = type
        self.fileName = fileName
        self.imageName = imageName
        self.volume = volume
    }
    
    func play() {
        
        if player == nil {
            player = AudioPlayer(fileName)
            player?.loops = true
        }
        
        if player != nil {
            player?.play()
        }
        playingStatus = .playing
        setVolume()
    }
    
    func stop() {
        player?.stop()
        player = nil
        playingStatus = .stop
    }
    
    func pause() {
        player?.pause()
        playingStatus = .pause
    }
    
    private func setVolume() {
        player?.volume =  volume * maxVolumePercentage
    }
}
