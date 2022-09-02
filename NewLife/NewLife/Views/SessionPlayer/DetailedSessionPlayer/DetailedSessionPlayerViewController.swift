//
//  DetailedSessionPlayerViewController.swift
//  Tawazon
//
//  Created by mac on 04/07/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit
import MediaPlayer
import NVActivityIndicatorView
import SwiftMessages





class DetailedSessionPlayerViewController: SuperSessionPlayerViewController {
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var rateButton: UIButton!
    
    @IBOutlet weak var progressSlider: ProgressSlider!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var fullDurationLabel: UILabel!
    @IBOutlet weak var footerControlsStack: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        startPlayerLoadingIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startGuidedTapping()
    }
    
    private func initialize() {
        
        if session?.audioSources?.count ?? 0 == 1 && session?.audioSources?.first?.dialects.count == 1{
            voiceAndDialectsButton.isHidden = true
            footerControlsStack.removeArrangedSubview(voiceAndDialectsButton)
        }
        
        fullDurationLabel.font = UIFont.munaFont(ofSize: 14.0)
        fullDurationLabel.textColor = .white
        
        durationLabel.font = UIFont.munaFont(ofSize: 14.0)
        durationLabel.textColor = .white
        
        voiceAndDialectsButton.setTitle("voiceAndDialectsTitle".localized, for: .normal)
        voiceAndDialectsButton.tintColor = .white
        voiceAndDialectsButton.roundCorners(corners: .allCorners, radius: 12.0)
        voiceAndDialectsButton.titleLabel?.font = UIFont.munaFont(ofSize: 18)
        voiceAndDialectsButton.setImage(#imageLiteral(resourceName: "VoiceAndDialect"), for: .normal)
        voiceAndDialectsButton.backgroundColor = .darkGray.withAlphaComponent(0.16)
        if #available(iOS 13.0, *) {
            voiceAndDialectsButton.addBlurEffect(style: .systemUltraThinMaterialDark)
        } else {
            // Fallback on earlier versions
            voiceAndDialectsButton.addBlurEffect(style: .dark)
        }
        favoriteButton.roundCorners(corners: .allCorners, radius: 0.0)
        favoriteButton.backgroundColor = .darkGray.withAlphaComponent(0.16)
        if #available(iOS 13.0, *) {
            favoriteButton.addBlurEffect(style: .systemUltraThinMaterialDark)
        } else {
            // Fallback on earlier versions
            favoriteButton.addBlurEffect(style: .dark)
        }
                
        progressSlider.tintColor = .white
        progressSlider.value = 0
        progressSlider.setThumbImage(UIImage(named: "ProgressTracker"), for: .normal)
        if #available(iOS 14.0, *) {
            progressSlider.setMaximumTrackImage(UIImage(named: "ProgressSliderTracker"), for: .normal)
        }
        
        
        initializeShareButton()
    }
    
    private func initializeShareButton() {
        let leftCorners : UIRectCorner = [[.bottomLeft, .topLeft]]
        let rightCorners : UIRectCorner = [.bottomRight, .topRight]
        shareButton.setImage(#imageLiteral(resourceName: "ShareSession.pdf"), for: .normal)
        shareButton.roundCorners(corners: Language.language == .english ? leftCorners : rightCorners, radius: 12.0)
        shareButton.backgroundColor = .darkGray.withAlphaComponent(0.26)
        shareButton.tintColor = .white
        if #available(iOS 13.0, *) {
            shareButton.addBlurEffect(style: .systemUltraThinMaterialDark)
        } else {
            // Fallback on earlier versions
            shareButton.addBlurEffect(style: .dark)
        }
        
        rateButton.setImage(#imageLiteral(resourceName: "EmptyRateStar.pdf"), for: .normal)
        rateButton.roundCorners(corners: Language.language == .english ? rightCorners : leftCorners, radius: 12.0)
        rateButton.backgroundColor = .darkGray.withAlphaComponent(0.16)
        rateButton.tintColor = .white
        if #available(iOS 13.0, *) {
            rateButton.addBlurEffect(style: .systemUltraThinMaterialDark)
        } else {
            // Fallback on earlier versions
            rateButton.addBlurEffect(style: .dark)
        }
        
    }
    
    override func fillData() {
        super.fillData()
        fullDurationLabel.text = session?.durationString
        
    }
    
    private func startGuidedTapping(){
        /*
         - first open
         1. session with button >> all steps
         2. session without button >> all steps except button step
         - other open
         1. session with button >> button step only
         */
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let tourView = GuidedTourView(frame: self.view.frame)
            tourView.backgroundColor = .darkBlueGrey.withAlphaComponent(0.62)
            tourView.screenName = "Session"
                        
            var sessionPlayerGuidedTourSteps : [StepInfo] = []
            if UserDefaults.isFirstGuidedSession(){
                self.view.addSubview(tourView)
                if !self.voiceAndDialectsButton.isHidden{
                    sessionPlayerGuidedTourSteps.append(StepInfo(view: self.voiceAndDialectsButton!,position: self.voiceAndDialectsButton.frame, textInfo: ("ovices_dialects","helpTextVoiceAndDialectsButton".localized), isBelow: false, isSameHierarchy: true))
                    UserDefaults.appSessionDialectButtonGuided()
                }
                
                sessionPlayerGuidedTourSteps.append(StepInfo(view: self.shareButton!,position: self.shareButton.frame, textInfo: ("share","helpTextShareButton".localized), isBelow: false, isSameHierarchy: true))
                sessionPlayerGuidedTourSteps.append(StepInfo(view: self.favoriteButton!,position: self.favoriteButton.frame, textInfo: ("favorite","helpTextFavoriteButton".localized), isBelow: false, isSameHierarchy: true))
                sessionPlayerGuidedTourSteps.append(StepInfo(view: self.rateButton!,position: self.rateButton.frame, textInfo: ("rate","helpTextRateButton".localized), isBelow: false, isSameHierarchy: true))
                sessionPlayerGuidedTourSteps.append(StepInfo(view: self.downloadButton!,position: self.downloadButton.frame, textInfo: ("download","helpTextDownloadButton".localized), isBelow: true, isSameHierarchy: true))
                sessionPlayerGuidedTourSteps.append(StepInfo(view: self.soundsButton!,position: self.rateButton.frame, textInfo: ("sound_effects","helpTextSoundsButton".localized), isBelow: true, isSameHierarchy: true))
                
                
                
                
                
                
                UserDefaults.appSessionGuided()
            }else if UserDefaults.isFirstGuidedSessionDialectButton() && !self.voiceAndDialectsButton.isHidden{
                self.view.addSubview(tourView)
                sessionPlayerGuidedTourSteps.append(StepInfo(view: self.voiceAndDialectsButton!,position: self.voiceAndDialectsButton.frame, textInfo: ("TITLE","helpTextVoiceAndDialectsButton".localized), isBelow: false, isSameHierarchy: true))
                UserDefaults.appSessionDialectButtonGuided()
            }
            
            if sessionPlayerGuidedTourSteps.count > 0 {
                tourView.steps = sessionPlayerGuidedTourSteps
                print("searchGuidedTourSteps: \(sessionPlayerGuidedTourSteps.count)\n \(sessionPlayerGuidedTourSteps)")
                TrackerManager.shared.sendGuidedTourStarted(viewName: "Session")
                tourView.showSteps()
            }
            
            
        })
        
        
    }
    
    @IBAction func progressSliderTapped(_ sender: UISlider) {
        if isPlaying {
            isPlaying = !AudioPlayerManager.shared.isPlaying()
            AudioPlayerManager.shared.togglePlayPause()
        }
    }
    @IBAction func progressSliderValueChanged(_ sender: UISlider) {
       
        let newTime = sender.value * (AudioPlayerManager.shared.currentTrack?.durationInSeconds() ?? 0)
        let seekTime = CMTimeMake(value: Int64(newTime), timescale: 1)
        AudioPlayerManager.shared.seek(toTime: seekTime)
        updateSongInformation(with: AudioPlayerManager.shared.currentTrack)
        if !isPlaying {
            isPlaying = !AudioPlayerManager.shared.isPlaying()
            AudioPlayerManager.shared.togglePlayPause()
        }
    }
}


extension DetailedSessionPlayerViewController {
    
    private func initPlaybackTimeViews() {
        progressSlider.value = 0
    }
    
    override func updatePlaybackTime(_ track: AudioTrack?) {
        super.updatePlaybackTime(track)
        progressSlider.value = Float(CGFloat(track?.currentProgress() ?? 0))
        durationLabel.text = track?.displayablePlaybackTimeString()
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
        controlsView.alpha = 0.5
        controlsView.isUserInteractionEnabled = false
    }
    
    private func stopPlayerLoading() {
        if playingLoading != nil {
            playingLoading?.stopAnimating()
            playingLoading = nil
        }
        playButton.alpha = 1.0
        playButton.isEnabled = true
        controlsView.alpha = 1.0
        controlsView.isUserInteractionEnabled = true
    }
    
}

extension DetailedSessionPlayerViewController {
    
    class func instantiate(session: SessionVM, delegate: SessionPlayerDelegate?) -> DetailedSessionPlayerViewController {
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: DetailedSessionPlayerViewController.identifier) as! DetailedSessionPlayerViewController
        viewController.delegate = delegate
        SessionPlayerMananger.shared.session = session
        return viewController
    }
    
}

extension UIButton {
    func addBlurEffect(style: UIBlurEffect.Style = .regular) {
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.isUserInteractionEnabled = false
        blurView.backgroundColor = .clear
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        blurView.layer.masksToBounds = true
        self.insertSubview(blurView, at: 0)
        if let imageView = self.imageView{
            imageView.backgroundColor = .clear
            self.bringSubviewToFront(imageView)
        }
    }
}
public class ProgressSlider : UISlider
{
    func addBlurEffect(style: UIBlurEffect.Style = .regular) {
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.isUserInteractionEnabled = false
        blurView.backgroundColor = .clear
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        blurView.layer.masksToBounds = true
        self.insertSubview(blurView, at: 0)
        
    }
}
