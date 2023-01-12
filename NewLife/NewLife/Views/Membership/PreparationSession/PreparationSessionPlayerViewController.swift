//
//  PreparationSessionPlayerViewController.swift
//  Tawazon
//
//  Created by mac on 02/11/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

enum fromViewController: String {
    case todayActivity
    case landing
    case other
}

class PreparationSessionPlayerViewController: SuperSessionPlayerViewController {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var closeButton: CircularButton!
    @IBOutlet weak var sessionSubtitleLabel: UILabel!
    @IBOutlet weak var sessionImageView: UIImageView!
    @IBOutlet weak var progressSlider: ProgressSlider!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var fullDurationLabel: UILabel!
    
    var subtitleStartsAt : Float = -1.0
    var presentedSubtitle: Bool = false
    var called = false
    var fromVC: fromViewController? = .landing
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isIdleTimerDisabled = true
        initialize()
        startPlayerLoadingIfNeeded()
        fillData()
    }
    
    private func initialize(){
        view.backgroundColor = .midnight
        
        backgroundImage.backgroundColor = .clear
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.image = UIImage(named: "PreparationSessionHeader")
        
        closeButton.roundCorners(corners: .allCorners, radius: 24)
        closeButton.backgroundColor = .black.withAlphaComponent(0.62)
        closeButton.setImage(UIImage(named: "Cancel"), for: .normal)
        closeButton.tintColor = .white
        
        sessionSubtitleLabel.font = .munaBoldFont(ofSize: 38)
        sessionSubtitleLabel.textColor = .white
        sessionSubtitleLabel.numberOfLines = 0
        sessionSubtitleLabel.lineBreakMode = .byWordWrapping
        sessionSubtitleLabel.textAlignment = .center
        sessionSubtitleLabel.text = "شــــــهيق"
        sessionSubtitleLabel.alpha = 0
        
        sessionImageView.backgroundColor = .clear
        sessionImageView.contentMode = .scaleAspectFill
        sessionImageView.clipsToBounds = true
        sessionImageView.image = UIImage(named: "_nightThumbnail")
        sessionImageView.layer.cornerRadius = Int(sessionImageView.frame.width) % 2 == 0 ? sessionImageView.frame.width / 2 : (sessionImageView.frame.height + 1.0) / 2
        sessionImageView.layer.borderColor = UIColor.mediumPurple.cgColor
        sessionImageView.layer.borderWidth = 1
        
        progressSlider.tintColor = .white
        progressSlider.value = 0
        
        fullDurationLabel.font = UIFont.munaFont(ofSize: 14.0)
        fullDurationLabel.textColor = .white
        
        durationLabel.font = UIFont.munaFont(ofSize: 14.0)
        durationLabel.textColor = .white
    }

    override func fillData(){
        super.fillData()
        
        fullDurationLabel.text = session?.durationString
        if let imageUrl = session?.session?.thumbnailUrl?.url {
            sessionImageView.af.setImage(withURL: imageUrl, completion:  { (_) in
            })
        }
    }
    
    private func updateSubtitleLabel(subtitle: Subtitle){
        sessionSubtitleLabel.text = subtitle.title
        
        let delay = TimeInterval((subtitle.end - subtitle.start))
        self.fadeViewInThenOut(view: sessionSubtitleLabel, delay: delay)
    }
    
    func fadeViewInThenOut(view : UIView, delay: TimeInterval) {
        let animationDuration = 1.0

        UIView.animate(withDuration: animationDuration, animations: { () -> Void in
            view.alpha = 1
            }) { (Bool) -> Void in

                UIView.animate(withDuration: animationDuration, delay: delay, options: .curveEaseInOut, animations: { () -> Void in
                    view.alpha = 0
                    },
                    completion: nil)
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        closePlayer(skipped: true)
    }
    
    private func openLandingFeelingsViewController(skipped: Bool, from: fromViewController){
        let viewController = LandingFeelingsViewController.instantiate(skipped: skipped, from: from)
        viewController.modalPresentationStyle = .currentContext
        self.show(viewController, sender: self)
    }
    
    @objc private func closePlayer(skipped: Bool) {
        UIApplication.shared.isIdleTimerDisabled = false
        
        if AudioPlayerManager.shared.isPlaying() == true {
            AudioPlayerManager.shared.stop(clearQueue: true)
            SessionPlayerMananger.shared.session = nil
        }
        if let session = session{
            if skipped{
                if fromVC == .todayActivity{
                    let values = ["sessionId": session.id ?? "", "sessionName": session.name ?? "", "time": Int(AudioPlayerManager.shared.getCurrentTrack()?.currentTimeInSeconds() ?? 0.0)] as [String : Any]
                    TrackerManager.shared.sendEvent(name: GeneralCustomEvents.dailyActivityPrepSessionClosed, payload: values)
                    
                }else{
                    TrackerManager.shared.sendPrepSessionSkipped(sessionId: session.id ?? "", sessionName: session.name ?? "", time: Int(AudioPlayerManager.shared.getCurrentTrack()?.currentTimeInSeconds() ?? 0.0))
                }
                
            }else{
                if fromVC == .todayActivity{
                    let values = ["sessionId": session.id ?? "", "sessionName": session.name ?? "", "time": session.session?.duration ?? 0] as [String : Any]
                    TrackerManager.shared.sendEvent(name: GeneralCustomEvents.dailyActivityPrepSessionFinished, payload: values)
                    
                }else{
                    TrackerManager.shared.sendPrepSessionSkipped(sessionId: session.id ?? "", sessionName: session.name ?? "", time: session.session?.duration ?? 0)
                }
                
            }
            
        }
        if fromVC == .todayActivity{
            self.dismiss(animated: true)
            return
        }
        openLandingFeelingsViewController(skipped: skipped, from: fromVC!)
    }
    
    @IBAction func sliderTapped(_ sender: Any) {
        TrackerManager.shared.sendPrepSessionProgressChangeAttempts()
    }
    
}


extension PreparationSessionPlayerViewController {
    
    private func initPlaybackTimeViews() {
        progressSlider.value = 0
    }
    
    override func updatePlaybackTime(_ track: AudioTrack?) {
        super.updatePlaybackTime(track)
        
        progressSlider.value = Float(CGFloat(track?.currentProgress() ?? 0))
        durationLabel.text = track?.displayablePlaybackTimeString()
        
        if (session?.getSessionPreferredVoiceAndDialect().dialect?.duration ?? 0) - 1 == Int(round(track?.currentTimeInSeconds() ?? 0.0)) && !called{
            called = true
            self.perform(#selector(closePlayer), with: false, afterDelay: 2)
        }
        if subtitleStartsAt != round(track?.currentTimeInSeconds() ?? 0.0){
            subtitleStartsAt = round(track?.currentTimeInSeconds() ?? 0.0)
            presentedSubtitle = false
        }else{
            presentedSubtitle = true
        }
        if let subtitles = session?.getSessionPreferredVoiceAndDialect().dialect?.subtitles, subtitles.count > 0, !presentedSubtitle{
            let filteredSubtitle = subtitles.filter{ subtitle in
                return subtitle.start == subtitleStartsAt
            }
            if filteredSubtitle.count == 1{
                updateSubtitleLabel(subtitle: filteredSubtitle.first!)
            }
        }
        
    }
    
    
    override func startPlayerLoadingIfNeeded() {
        if playingLoading == nil {
            playingLoading = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: view.frame.width/3, height: view.frame.height/3), type: NVActivityIndicatorType.circleStrokeSpin, color: UIColor.white, padding: nil)

            view.addSubview(playingLoading!)
            playingLoading?.translatesAutoresizingMaskIntoConstraints = false
            playingLoading?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            playingLoading?.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            playingLoading?.startAnimating()
        }
        playButton.alpha = 0.5
        playButton.isEnabled = false
        controlsView?.alpha = 0.5
        controlsView?.isUserInteractionEnabled = false
    }
    
    private func stopPlayerLoading() {
        if playingLoading != nil {
            playingLoading?.stopAnimating()
            playingLoading = nil
        }
        playButton.alpha = 1.0
        playButton.isEnabled = true
        controlsView?.alpha = 1.0
        controlsView?.isUserInteractionEnabled = true
    }
    
}

extension PreparationSessionPlayerViewController{
    class func instantiate(from: fromViewController = .landing) -> PreparationSessionPlayerViewController {
        let storyboard = UIStoryboard(name: "Membership", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: PreparationSessionPlayerViewController.identifier) as! PreparationSessionPlayerViewController
        viewController.modalPresentationStyle = .fullScreen
        viewController.fromVC = from
        return viewController
    }
}
