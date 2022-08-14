//
//  SeriesSessionTableViewCell.swift
//  Tawazon
//
//  Created by mac on 26/07/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

protocol SeriesSessionDelegate: class {
    func togglePlaySession(_ session: SessionVM)
    func setCompletedSession(session: SessionVM)
}

class SeriesSessionTableViewCell: UITableViewCell {

    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var playButton: CircularButton!
    @IBOutlet weak var sessionTitleLabel: UILabel!
    @IBOutlet weak var sessionSubtitleLabel: UILabel!
    @IBOutlet weak var sessionProgressView: PlayerProgressView!
    @IBOutlet weak var sessionProgressImageView: UIImageView!
    weak var delegate: SeriesSessionDelegate?
    
    var isPlaying: Bool = false {
        didSet {
            setSelectedStyle(selected: isPlaying)
            updatePlayButtonStyle(isPlaying: isPlaying)
        }
    }
    
    var session: SessionVM? {
        didSet {
            fillData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initialize()
    }

    private func initialize(){
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        contentView.backgroundColor = .clear
        
        detailsView.backgroundColor = .cherryPie
        detailsView.layer.cornerRadius = 42
        
        playButton.tintColor = UIColor.white
        updatePlayButtonStyle(isPlaying: isPlaying)
        
        sessionTitleLabel.font = .kohinoorSemiBold(ofSize: 16)
        sessionTitleLabel.textColor = .white
        
        sessionSubtitleLabel.font = .kohinoorSemiBold(ofSize: 12)
        sessionSubtitleLabel.textColor = .white
        sessionSubtitleLabel.layer.opacity = 0.6
        
        sessionProgressImageView.image = UIImage(named: "SeriesSessionDone")
        sessionProgressImageView.isHidden = true
        
        addCustomSeparator()
    }
    
    private func updatePlayButtonStyle(isPlaying: Bool) {
        var image: UIImage?
        if session?.session?.locked ?? true{
            image = UIImage(named: "PlayerLocked")
            playButton.setImage(image, for: .normal)
            playButton.isEnabled = false
            return
        }
         image = isPlaying ? UIImage(named: "PlayerPause") :  UIImage(named: "PlayerPlay")
        playButton.setImage(image, for: .normal)
        playButton.isEnabled = true
    }
    
    private func fillData(){
        sessionTitleLabel.text = session?.name
        sessionSubtitleLabel.text = session?.durationString
        
        sessionProgressView.progress = 0
        
        isPlaying = SessionPlayerMananger.shared.session?.id == session?.id ? true : false
        if isPlaying {
            sessionProgressView.progress = CGFloat(AudioPlayerManager.shared.currentTrack?.currentProgress() ?? 0)
            NotificationCenter.default.addObserver(self, selector: #selector(updateProgress(_:)), name: NSNotification.Name(rawValue: "UpdateProgress")
                , object: nil)
        }else{
            sessionProgressView.progress = 0
            NotificationCenter.default.removeObserver(self)
        }
        
            sessionProgressImageView.isHidden = !(session?.session?.completed ?? false)
        
        session?.isLock ?? true ? playButton.setImage(UIImage(named: "PlayerPremiumSession"), for: .normal) : updatePlayButtonStyle(isPlaying: isPlaying)
    }
    
    @objc func updateProgress(_ notification: Notification) {
        sessionProgressView.progress = CGFloat(AudioPlayerManager.shared.currentTrack?.currentProgress() ?? 0)
      
        let roundedDuration = round(Double((AudioPlayerManager.shared.currentTrack?.durationInSeconds() ?? 0.0)))
        let roundedcurrentTime = round(Double((AudioPlayerManager.shared.currentTrack?.currentTimeInSeconds() ?? 0.0)))
        
        if isPlaying && (roundedcurrentTime == roundedDuration) && roundedcurrentTime > 0 {
            sessionProgressImageView.isHidden = false
            setSessionCompleted()
            isPlaying = false
            AudioPlayerManager.shared.stop(clearQueue: true)
            SessionPlayerMananger.shared.session = nil
        }
    }
    
    private func addCustomSeparator(){
        let separatorView = UIView(frame: CGRect(x: 0, y: 0, width: 3, height: 24))
        separatorView.layer.cornerRadius = 1.5
        separatorView.backgroundColor = .gulfBlue
        self.contentView.addSubview(separatorView)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.topAnchor.constraint(equalTo: self.detailsView.bottomAnchor, constant: 8).isActive = true
        separatorView.widthAnchor.constraint(equalToConstant: 3).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        separatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }
    private func setSessionCompleted(){
        delegate?.setCompletedSession(session: session!)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setSelectedStyle(selected: Bool){
        if selected {
            detailsView.layer.borderColor = UIColor.irisTwo.cgColor
            detailsView.layer.borderWidth = 2
            detailsView.backgroundColor = .meteorite
        }else{
            detailsView.layer.borderColor = UIColor.clear.cgColor
            detailsView.layer.borderWidth = 0
            detailsView.backgroundColor = .cherryPie
        }
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        if session != nil {
            isPlaying = !isPlaying
            setSelectedStyle(selected: isPlaying)
            
        }
        if isPlaying {
            SessionPlayerMananger.shared.session = session
            delegate?.togglePlaySession(self.session!)
        }else{
            AudioPlayerManager.shared.stop(clearQueue: true)
        }
    }
    
    
}
