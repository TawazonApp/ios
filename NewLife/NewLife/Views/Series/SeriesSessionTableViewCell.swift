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
    func setSessionDuration(session: SessionVM, duration: Int)
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
        playButton.backgroundColor = .white.withAlphaComponent(0.12)
        playButton.roundCorners(corners: .allCorners, radius: playButton.frame.height/2)
        updatePlayButtonStyle(isPlaying: isPlaying)
        
        sessionTitleLabel.font = .kohinoorSemiBold(ofSize: 16)
        sessionTitleLabel.textColor = .white
        sessionTitleLabel.numberOfLines = 0
        sessionTitleLabel.lineBreakMode = .byWordWrapping
        
        sessionSubtitleLabel.font = .kohinoorSemiBold(ofSize: 12)
        sessionSubtitleLabel.textColor = .white
        sessionSubtitleLabel.layer.opacity = 0.6
        
        sessionProgressView.withBase = true
        
        sessionProgressImageView.image = UIImage(named: "SeriesSessionDone")
        sessionProgressImageView.isHidden = true
        
        addCustomSeparator()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        sessionProgressView.progress = 0
    }
    
    private func updatePlayButtonStyle(isPlaying: Bool) {
        var image: UIImage?
        if session?.session?.locked ?? true{
            image = UIImage(named: "SeriesPlayerLocked")
            playButton.setImage(image, for: .normal)
            playButton.isEnabled = false
            playButton.backgroundColor = .white.withAlphaComponent(0.12)
            return
        }
         image = isPlaying ? UIImage(named: "SeriesPlayerStop") :  UIImage(named: "SeriesPlayerPlay")
        playButton.setImage(image, for: .normal)
        playButton.backgroundColor = isPlaying ? .irisTwo : .white.withAlphaComponent(0.12)
        playButton.isEnabled = true
    }
    
    private func fillData(){
        sessionTitleLabel.text = session?.name
        sessionSubtitleLabel.text = session?.durationString
        
        
        isPlaying = SessionPlayerMananger.shared.session?.id == session?.id ? true : false
        
        if isPlaying {
            sessionProgressView.progress = CGFloat(AudioPlayerManager.shared.currentTrack?.currentProgress() ?? 0)
            NotificationCenter.default.addObserver(self, selector: #selector(updateProgress(_:)), name: NSNotification.Name.updatePlayerProgress
                , object: nil)
        }else{
            sessionProgressView.progress = session?.session?.completed ?? false ?  1 : 0
            NotificationCenter.default.removeObserver(self)
        }
        
        sessionProgressImageView.isHidden = !(session?.session?.completed ?? false)
        
        session?.isLock ?? true ? playButton.setImage(UIImage(named: "SeriesPlayerPremiumSession"), for: .normal) : updatePlayButtonStyle(isPlaying: isPlaying)
    }
    
    @objc func updateProgress(_ notification: Notification) {
        sessionProgressView.progress = CGFloat(AudioPlayerManager.shared.currentTrack?.currentProgress() ?? 0)
      
        let roundedDuration = round(Double((AudioPlayerManager.shared.currentTrack?.durationInSeconds() ?? 0.0)))
        let roundedcurrentTime = round(Double((AudioPlayerManager.shared.currentTrack?.currentTimeInSeconds() ?? 0.0)))
        
        if isPlaying && (roundedcurrentTime == roundedDuration) && roundedcurrentTime > 0 {
            sessionProgressImageView.isHidden = false
            setSessionDuration()
            isPlaying = false
        }
    }
    
    private func postSessionDuration(session: SessionModel){
        
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
    private func setSessionDuration(){
        delegate?.setSessionDuration(session: session!, duration: Int(AudioPlayerManager.shared.currentTrack?.currentTimeInSeconds() ?? 0.0))
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
            updatePlayButtonStyle(isPlaying: isPlaying)
        }
        if isPlaying {
            SessionPlayerMananger.shared.session = session
            delegate?.togglePlaySession(self.session!)
        }else{
            self.setSessionDuration()
            let reloadView = false
            NotificationCenter.default.post(name: NSNotification.Name.hideSessionPlayerBar, object: reloadView)
        }
    }
    
    
}
