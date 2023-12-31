//
//  MainPlayerBarView.swift
//  NewLife
//
//  Created by Shadi on 20/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

protocol MainPlayerBarViewDelegate: class {
    func playerTapped()
    func openPremiumView(_ sender: MainPlayerBarView)
}

class MainPlayerBarView: UIView, NibInstantiatable {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressView: MainPlayerBarProgressView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    weak var delegate: MainPlayerBarViewDelegate?
    
    var session: SessionVM? {
        return SessionPlayerMananger.shared.session
    }
    
    var isPlaying: Bool = true {
        didSet {
            updatePlayButtonStyle()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
        setupAudioManager()
        updateButtonStates()
        fillData()
        initializeNotificationCenter()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:))))
    }
    
    deinit {
        // Stop listening to the callbacks
        AudioPlayerManager.shared.removePlayStateChangeCallback(self)
        AudioPlayerManager.shared.removePlaybackTimeChangeCallback(self)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    private func initialize() {
        
        self.backgroundColor = UIColor.lightPink
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
            
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8
        
        titleLabel.textColor = UIColor.charcoalGrey
        titleLabel.font = UIFont.kacstPen(ofSize: 16)
        
        playButton.tintColor = UIColor.charcoalGrey
        
        cancelButton.tintColor = UIColor.charcoalGrey
        cancelButton.setImage(#imageLiteral(resourceName: "Cancel.pdf"), for: .normal)
        
        initPlaybackTimeViews()
        
    }
    
    private func initializeNotificationCenter() {
        NotificationCenter.default.addObserver(self,  selector: #selector(remoteAudioControlDidReceived(_:)),  name: Notification.Name.remoteAudioControlDidReceived, object: nil)
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        delegate?.playerTapped()
    }
    
    private func fillData() {
        
        imageView.image = nil
        if let localiImageUrl = session?.localImageUrl {
            imageView.image = UIImage(contentsOfFile: localiImageUrl.path)
        } else if let imageUrl = session?.imageUrl {
            imageView.af.setImage(withURL: imageUrl)
        }
        
        titleLabel.text = session?.name
        
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        isPlaying = !AudioPlayerManager.shared.isPlaying()
        AudioPlayerManager.shared.togglePlayPause()
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        let session = SessionPlayerMananger.shared.session
        AudioPlayerManager.shared.stop(clearQueue: true)
        SessionPlayerMananger.shared.session = nil
        NotificationCenter.default.post(name: NSNotification.Name.hideSessionPlayerBar, object: session)
    }
    
   
    private func updatePlayButtonStyle() {
        let image: UIImage? = isPlaying ? UIImage(named: "PlayerBarPause") :  UIImage(named: "PlayerBarPlay")
        playButton.setImage(image, for: .normal)
    }
    
    @objc private func remoteAudioControlDidReceived(_ notification: Notification) {
        isPlaying = AudioPlayerManager.shared.isPlaying()
    }
   
}

extension MainPlayerBarView {
    
    func playSession() {
        fillData()
        if AudioPlayerManager.shared.isPlaying(url: session?.audioUrl) == true {
            return
        }
        let soundUrl = session?.localAudioUrl ?? session?.audioUrl
        if let soundUrl = soundUrl, AudioPlayerManager.shared.isPlaying(url: soundUrl) == false {
            AudioPlayerManager.shared.stop(clearQueue: true)
            AudioPlayerManager.shared.play(url: soundUrl, session: session!.session)
        }
    }
    
    private func setupAudioManager() {
        
        // Listen to the player state updates. This state is updated if the play, pause or queue state changed.
        AudioPlayerManager.shared.addPlayStateChangeCallback(self, callback: { [weak self] (track: AudioTrack?) in
            
            self?.updateButtonStates()
            self?.updateSongInformation(with: track)
        })
        // Listen to the playback time changed. Thirs event occurs every `AudioPlayerManager.PlayingTimeRefreshRate` seconds.
        AudioPlayerManager.shared.addPlaybackTimeChangeCallback(self, callback: { [weak self] (track: AudioTrack?) in
            
            if let session = AudioPlayerManager.shared.currentSession, session.isLock,
               let seconds = track?.currentTimeInSeconds(){
                if TimeInterval(seconds) >= Constants.lockFreeDuration {
                    AudioPlayerManager.shared.stop()
                    if let self = self {
                        self.delegate?.openPremiumView(self)
                    }
                }
            }
            self?.updatePlaybackTime(track)
        })
    }
    
    private func initPlaybackTimeViews() {
        progressView.progress = 0
        progressView.currentTime = nil
        progressView.remainingTime = nil
    }
    
    private func updateButtonStates() {
        isPlaying = AudioPlayerManager.shared.isPlaying()
        self.playButton?.isEnabled = AudioPlayerManager.shared.canPlay()
    }
    
    private func updateSongInformation(with track: AudioTrack?) {
        self.updatePlaybackTime(track)
    }
    
    private func updatePlaybackTime(_ track: AudioTrack?) {
        progressView.progress = Float(track?.currentProgress() ?? 0)
        progressView.currentTime = track?.displayablePlaybackTimeString()
        let remainingTime =
        progressView.remainingTime = "-\(track?.displayableTimeLeftString() ?? "")"
    }
    
    
}
