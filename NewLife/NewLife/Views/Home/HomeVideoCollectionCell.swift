//
//  HomeVideoCollectionCell.swift
//  NewLife
//
//  Created by Shadi on 27/02/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit
import SwiftVideoBackground

class HomeVideoCollectionCell: UICollectionViewCell {
    
    var data: HomeVideoCellVM? {
        didSet {
            play()
        }
    }
    
    var videoBackground: VideoBackground?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize() {
        backgroundColor = UIColor.clear
    }
    
    private func play() {
        guard let data = data else { return }
        if videoBackground == nil {
            videoBackground = VideoBackground()
        }
        try? videoBackground?.play(view: self, videoName: data.videoName, videoType: data.videoType, isMuted: true, darkness: 0, willLoopVideo: true, setAudioSessionAmbient: false, rate: 0.6)
    }
    
    func pause() {
        videoBackground?.pause()
        videoBackground = nil
    }
}
