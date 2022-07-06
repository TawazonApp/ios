//
//  SuperSessionPlayerViewController.swift
//  Tawazon
//
//  Created by mac on 06/07/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import MediaPlayer
import SwiftMessages

protocol SessionPlayerDelegate: class {
    func sessionStoped(_ session: SessionVM)
}

class SuperSessionPlayerViewController: SoundEffectsPresenterViewController {

    
    
    
    @IBOutlet weak var voiceAndDialectsButton: GradientButton!
    @IBOutlet weak var backgroundImageView: ParallaxImageView!
    @IBOutlet weak var overlayView: GradientView!
    @IBOutlet weak var downloadButton: DownloadSessionButton!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var favoriteButton: SessionFavoriteButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var controlsView: PlayerControlsView!
    
    
    weak var delegate: SessionPlayerDelegate?
    var playingLoading: NVActivityIndicatorView?
    var didAppeared: Bool = false
    var initialDownloadStatus: SessionDownloadStatus = .none
    
    var isPlaying: Bool = true {
        didSet {
            updatePlayButtonStyle()
        }
    }
    
    var session: SessionVM? {
        return SessionPlayerMananger.shared.session
    }
    
    var count: CGFloat = 0
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        initializeNotificationCenter()
        fillData()
        setupAudioManager()
//        startPlayerLoadingIfNeeded()
        updateButtonStates()
        hideSessionPlayerBar()
        stopBackgroundMusicIfNeeded()
        reduceVoulme(volume: 0.25)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if didAppeared == false {
            let sessionURL = session?.getSessionAudioSource()
            self.playSession(sessoinAudioSource: sessionURL)
            backgroundImageView.animate()
            didAppeared = true
        }
    }
    
    deinit {
        // Stop listening to the callbacks
        AudioPlayerManager.shared.removePlayStateChangeCallback(self)
        AudioPlayerManager.shared.removePlaybackTimeChangeCallback(self)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    private func reduceVoulme(volume: Double) {
        BackgroundAudioManager.shared.volume = volume
    }
    
    private func initialize() {
        
        self.view.layer.masksToBounds = true
        controlsView.delegate = self
        backgroundImageView.backgroundColor = UIColor.black
        
        dismissButton.setImage(#imageLiteral(resourceName: "SwipeDismiss.pdf"), for: .normal)
        dismissButton.tintColor = UIColor.white
        
        downloadButton.setImage(#imageLiteral(resourceName: "Download.pdf"), for: .normal)
        downloadButton.tintColor = UIColor.white
        downloadButton.layer.cornerRadius = downloadButton.frame.height/2
        downloadButton.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        titleLabel.font = UIFont.lbcBold(ofSize: 28, language: .arabic)
        titleLabel.textColor = UIColor.white
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        
        subTitleLabel.font = UIFont.munaFont(ofSize: 16, language: .arabic)
        subTitleLabel.textColor = UIColor.white.withAlphaComponent(0.86)
        subTitleLabel.textAlignment = .center
        subTitleLabel.numberOfLines = 0
        subTitleLabel.lineBreakMode = .byWordWrapping
        
        overlayView.applyGradientColor(colors: [UIColor.darkBlueGreyTwo.withAlphaComponent(0.4).cgColor, UIColor.darkFour.withAlphaComponent(0.4).cgColor], startPoint: .top, endPoint: .bottom)
        
        playButton.tintColor = UIColor.white
        
        updatePlayButtonStyle()
    }
    
    private func initializeNotificationCenter() {
        NotificationCenter.default.addObserver(self,  selector: #selector(downloadSessionsProgressChanged(_:)),  name: Notification.Name.downloadSessionsProgressChanged, object: nil)
        NotificationCenter.default.addObserver(self,  selector: #selector(remoteAudioControlDidReceived(_:)),  name: Notification.Name.remoteAudioControlDidReceived, object: nil)
    }
    private func stopBackgroundMusicIfNeeded(){
        if !(session?.session?.playBackgroundSound ?? true) {
            BackgroundAudioManager.shared.stopBackgroundSound()
        }
    }
    private func hideSessionPlayerBar() {
        NotificationCenter.default.post(name: NSNotification.Name.hideSessionPlayerBar, object: nil)
    }
    
    @objc private func showSessionPlayerBar() {
        NotificationCenter.default.post(name: NSNotification.Name.showSessionPlayerBar, object: nil)
    }
    
    private func updatePlayButtonStyle() {
        let image: UIImage? = isPlaying ? UIImage(named: "PlayerPause") :  UIImage(named: "PlayerPlay")
        playButton.setImage(image, for: .normal)
    }
    
     @objc func fillData() {
        titleLabel.text = session?.name
        subTitleLabel.text = session?.author
        
        backgroundImageView.image = nil
        if let localiImageUrl = session?.localImageUrl {
            backgroundImageView.image = UIImage(contentsOfFile: localiImageUrl.path)
        } else if let imageUrl = session?.imageUrl {
            backgroundImageView.af.setImage(withURL: imageUrl)
        }
        
        controlsView.duration = session?.durationString
        downloadButton.downloadStatus = session?.downloadStatus
        initialDownloadStatus = session?.downloadStatus ?? .none
        setFavoriteButtonData()
    }
    
    private func setFavoriteButtonData() {
        favoriteButton.isFavorite = session?.isFavorite ?? false
    }
    
    private func  changeFavoriteStatus(favorite: Bool) {
        
        if favorite {
            session?.addToFavorite { [weak self] (error) in
                self?.setFavoriteButtonData()
            }
        } else {
            session?.removeFromFavorites { [weak self] (error) in
                self?.setFavoriteButtonData()
                
            }
        }
    }
    
    @objc private func downloadSessionsProgressChanged(_ notification: Notification) {
        downloadButton.downloadStatus = session?.downloadStatus
        if initialDownloadStatus != session?.downloadStatus &&  session?.downloadStatus == .downloaded {
            initialDownloadStatus = .downloaded
            showSessionDownloadedSuccessMessage()
        }
    }
    
    @objc private func remoteAudioControlDidReceived(_ notification: Notification) {
        isPlaying = AudioPlayerManager.shared.isPlaying()
    }
    
    private func dimiss() {
        let session = self.session
        if AudioPlayerManager.shared.isPlaying() == false {
            AudioPlayerManager.shared.stop(clearQueue: true)
            SessionPlayerMananger.shared.session = nil
            self.dismiss(animated: true) {
                if session != nil {
                    self.delegate?.sessionStoped(session!)
                }
            }
        } else {
            showSessionPlayerBar()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func openLoginViewController() {
        SystemSoundID.play(sound: .Sound1)
        
        let viewController = MembershipViewController.instantiate(viewType: .login)
        
        let navigationController = NavigationController.init(rootViewController: viewController)
        navigationController.modalPresentationStyle = .overCurrentContext
        self.present(navigationController, animated: false, completion: nil)
    }
    
    private func showLoginPermissionAlert() {
        PermissionAlert.shared.show(type: PermissionAlertView.AlertType.login, animated: true, actionHandler: {
            PermissionAlert.shared.hide(animated: true, completion: { [weak self] in
                self?.openLoginViewController()
            })
        }, cancelHandler: {
            PermissionAlert.shared.hide(animated: true)
        })
    }
    
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        dimiss()
    }
    
    @IBAction func downloadButtonTapped(_ sender: UIButton) {
        UserDefaults.isAnonymousUser() ? showLoginPermissionAlert() :  session?.download()
        
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        isPlaying = !AudioPlayerManager.shared.isPlaying()
        AudioPlayerManager.shared.togglePlayPause()
    }
    
    @IBAction func favoriteButtonTapped(_ sender: SessionFavoriteButton) {
        
        sender.isFavorite = !sender.isFavorite
        
        if sender.isFavorite {
            sender.animate()
        }
        
        changeFavoriteStatus(favorite: sender.isFavorite)
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        showShareSessionView()
    }
    
    @IBAction func rateButtonTapped(_ sender: UIButton) {
        showRateSessionView()
    }
    
    @IBAction func voicesAndDialectsButtonTapped(_ sender: UIButton) {
        showVoicesAndDialectsView()
    }
    
    func showSessionDownloadedSuccessMessage() {
        
        if swiftMessages != nil {
            swiftMessages?.hide()
            swiftMessages = nil
        }
        
        swiftMessages = SwiftMessages()
        
        guard let swiftMessages = swiftMessages else { return }
        
        let errorView = MessageView.viewFromNib(layout: .messageView)
        errorView.configureTheme(backgroundColor: UIColor.paleTeal, foregroundColor: UIColor.white, buttonBackgroundColor: UIColor.white.withAlphaComponent(0.3), iconImage: nil, iconText: nil, titleFont: UIFont.kacstPen(ofSize: 18), bodyFont: UIFont.kacstPen(ofSize: 16), buttonFont: UIFont.kacstPen(ofSize: 16))
        
        errorView.button?.isHidden = false
        let hideImage = UIImage(named: "AlertDismiss")
        let message =  "sessionDownloadedSuccessfullyMessage".localized
        errorView.configureContent(title: nil, body: message, iconImage: UIImage(named: "SuccessIconAlert") , iconText: nil, buttonImage: hideImage, buttonTitle: nil) { (button) in
            swiftMessages.hide()
        }
        
        var config = swiftMessages.defaultConfig
        
        config.presentationStyle = .top
        config.presentationContext = .view(self.view)
        config.duration = .seconds(seconds: 3)
        config.dimMode = .none
        config.interactiveHide = true
        config.preferredStatusBarStyle = .lightContent
        if let hideImage = hideImage {
            errorView.button?.contentEdgeInsets = UIEdgeInsets.zero
            errorView.button?.layer.cornerRadius = hideImage.size.height/2
        }
        swiftMessages.show(config: config, view: errorView)
    }
    
    private func showShareSessionView() {
        guard let session = session else {
            return
        }
        
        let shareViewController = SessionShareViewController.instantiate(session: session)
        shareViewController.modalPresentationStyle = .custom
        shareViewController.transitioningDelegate = self
        self.present(shareViewController, animated: true, completion: nil)
    }
    
    private func showRateSessionView() {
        guard let session = session else {
            return
        }
        SessionRateViewController.show(session: session, from: self, force: true)
    }
    
    private func showVoicesAndDialectsView() {
        guard let session = session else {
            return
        }
        didAppeared = false
        let voicesAndDialectsViewController = VoicesAndDialectsViewController.instantiate(session: session)
        voicesAndDialectsViewController.modalPresentationStyle = .custom
        voicesAndDialectsViewController.transitioningDelegate = self
        voicesAndDialectsViewController.delegate = self
        self.present(voicesAndDialectsViewController, animated: true, completion: nil)
    }
}

extension SuperSessionPlayerViewController: PlayerControlsViewDelegate {
    
    func backwardButtonTapped() {print("TAAAAAAAPPED")
        guard AudioPlayerManager.shared.canRewind() else {
            return
        }
        if let currentTimeInSeconds = AudioPlayerManager.shared.currentTrack?.currentTimeInSeconds() {
            let newTime = currentTimeInSeconds - 10
            let seekTime = CMTimeMake(value: Int64(newTime), timescale: 1)
            AudioPlayerManager.shared.seek(toTime: seekTime)
            updateSongInformation(with: AudioPlayerManager.shared.currentTrack)
        }
        
    }
    
    func forwardButtonTapped() {
        
        if let currentTimeInSeconds = AudioPlayerManager.shared.currentTrack?.currentTimeInSeconds() {
            let newTime = currentTimeInSeconds + 10
            let seekTime = CMTimeMake(value: Int64(newTime), timescale: 1)
            AudioPlayerManager.shared.seek(toTime: seekTime)
            updateSongInformation(with: AudioPlayerManager.shared.currentTrack)
        }
    }
}

extension SuperSessionPlayerViewController{
    private func playSession(sessoinAudioSource: URL?) {
        if AudioPlayerManager.shared.isPlaying(url: sessoinAudioSource) == true {
            return
        }
        
        guard let soundUrl =  session?.localAudioUrl ?? sessoinAudioSource ?? session?.audioUrl else {
            return
        }
        
        if AudioPlayerManager.shared.isCurrentTrack(url: soundUrl) {
            updateButtonStates()
            updateSongInformation(with: AudioPlayerManager.shared.currentTrack)
        } else {
            AudioPlayerManager.shared.stop(clearQueue: true)
            AudioPlayerManager.shared.play(url: soundUrl, session: session!.session)
            sendPlaySessionEvent(id: session?.id ?? "", name: session?.name ?? "")
        }
    }
    
    private func setupAudioManager() {
        
         // Listen to the player state updates. This state is updated if the play, pause or queue state changed.
         AudioPlayerManager.shared.addPlayStateChangeCallback(self, callback: { [weak self] (track: AudioTrack?) in
             
             self?.updateButtonStates()
             self?.updateSongInformation(with: track)
         })
        var finishEventDidSent = false
        var eventDidSent = false
         // Listen to the playback time changed. Thirs event occurs every `AudioPlayerManager.PlayingTimeRefreshRate` seconds.
         AudioPlayerManager.shared.addPlaybackTimeChangeCallback(self, callback: { [weak self] (track: AudioTrack?) in
             if let session = AudioPlayerManager.shared.currentSession, session.isLock,
                let seconds = track?.currentTimeInSeconds(){
                 if TimeInterval(seconds) >= Constants.lockFreeDuration {
                     AudioPlayerManager.shared.stop()
                     if let self = self {
                         self.openPremiumViewController()
                     }
                 }
             }
             if let seconds = track?.currentTimeInSeconds(){
                 let roundedSeconds = round(seconds)
                 let roundedDuration = round(Double((track?.durationInSeconds() ?? 0.0)))
                 
                 if ((TimeInterval(roundedSeconds) == Constants.listenForDuration) &&
                     TimeInterval(roundedSeconds) > 0.0 && !eventDidSent) {
                     eventDidSent = true
                     if let session = AudioPlayerManager.shared.currentSession{
                         TrackerManager.shared.sendSessionListenForPeriodEvent(period: TimeInterval(roundedSeconds), sessionId: session.id)
                     }
                     
                 }else if  (TimeInterval(roundedSeconds) == roundedDuration) &&
                             TimeInterval(roundedSeconds) > 0.0 && !finishEventDidSent{
                     finishEventDidSent = true
                     if let session = AudioPlayerManager.shared.currentSession{
                         TrackerManager.shared.sendSessionListenForPeriodEvent(period: TimeInterval(roundedSeconds), sessionId: session.id)
                     }
                 }
             }
             self?.updatePlaybackTime(track)
         })
     }
    
    private func openPremiumViewController() {
        guard self.presentedViewController == nil else {
            return
        }
        let viewcontroller = GeneralPremiumViewController.instantiate(nextView: .dimiss, fromView: .session)
        
        let navigationController = NavigationController.init(rootViewController: viewcontroller)
        navigationController.modalPresentationStyle = .custom
        navigationController.transitioningDelegate = self
        self.present(navigationController, animated: true, completion: nil)
    }
    
    private func updateButtonStates() {
        isPlaying = AudioPlayerManager.shared.isPlaying()
        self.playButton?.isEnabled = AudioPlayerManager.shared.canPlay()
    }
    
     func updateSongInformation(with track: AudioTrack?) {
        self.updatePlaybackTime(track)
    }
    
     @objc func updatePlaybackTime(_ track: AudioTrack?) {
//        progressView.progress = CGFloat(track?.currentProgress() ?? 0)
        showAndHideLoadingIndicator(track: track)
        controlsView.duration = track?.displayableTimeLeftString()
    }
    
    private func showAndHideLoadingIndicator(track: AudioTrack?) {
        if track != nil && track!.currentTimeInSeconds() == 0 && AudioPlayerManager.shared.isPlaying() {
            startPlayerLoadingIfNeeded()
        } else {
            stopPlayerLoading()
        }
    }
    
    @objc func startPlayerLoadingIfNeeded() {
//        if playingLoading == nil {
////            playingLoading = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: progressView.frame.width, height: progressView.frame.height), type: NVActivityIndicatorType.circleStrokeSpin, color: UIColor.white, padding: nil)
////
////            progressView.addSubview(playingLoading!)
//            playingLoading?.startAnimating()
//        }
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
    
    private func sendPlaySessionEvent(id: String, name: String) {
        TrackerManager.shared.sendPlaySessionEvent(id: id, name: name)
    }
}
extension AudioPlayerManager {
    func isCurrentTrack(url: URL) -> Bool {
        return currentTrack?.identifier() == url.absoluteString
    }
}

extension SuperSessionPlayerViewController: VoicesAndDialectsDelegate{
    func sessionStreamLinkChanged(audioSource: String) {
        playSession(sessoinAudioSource: audioSource.url)
    }
    func changeInterfaceLanguage(language: Language) {
        changeLanguage(language: language)
        session?.service.fetchSessionInfo(sessionId: (session?.id)!){ (sessionModel, error) in
            if let sessionModel = sessionModel {
                SessionPlayerMananger.shared.session = SessionVM(service: SessionServiceFactory.service(), session: sessionModel)
            }
        }
        self.perform(#selector(showSessionPlayerBar), with: nil, afterDelay: 4)
        
    }
    
    private func changeLanguage(language: Language) {
        guard language != Language.language else {
            return
        }
        Language.language = language
        NotificationCenter.default.post(name: .languageChanged, object: nil)
        (UIApplication.shared.delegate as? AppDelegate)?.resetApp()
    }
}