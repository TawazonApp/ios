//
//  SoundEffectsViewController.swift
//  NewLife
//
//  Created by Shadi on 03/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit
import AudioToolbox

protocol SoundEffectsViewControllerDelegate: class {
    func beginLoadAnimation()
    func beginDismissAnimation()
}

class SoundEffectsViewController: BaseViewController {
    
    static let duration: TimeInterval = 0.25
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var soundsButton: UIButton!
    @IBOutlet weak var backgroundSoundButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var volumeView: SoundEffectsVolumeView!
    
    weak var delegate: SoundEffectsViewControllerDelegate?
    var audios: [BackgroundAudioVM] = []
    var needAnimation = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        audios = BackgroundAudioManager.shared.audios
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.animateWhenLoad()
    }
    
    private func initialize() {
        view.backgroundColor = UIColor.clear
        
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.64)
        backgroundView.layer.cornerRadius = 24
        backgroundView.layer.masksToBounds = true
        backgroundView.alpha = 0.0
        
        self.blurView.effect =  nil
        self.blurView.layer.cornerRadius = 24
        self.blurView.layer.masksToBounds = true
        
        soundsButton.alpha = 0.0
        soundsButton.tintColor = UIColor.white
        soundsButton.layer.cornerRadius = soundsButton.frame.height/2
        soundsButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        soundsButton.setImage(UIImage(named: "Cancel"), for: .normal)
        collectionView.alpha = 0.0
        
        volumeView.setVolume(volume: BackgroundAudioManager.shared.volume)
        volumeView.delegate = self
        
        backgroundSoundButton.tintColor = UIColor.white
        backgroundSoundButton.titleLabel?.font = UIFont.kacstPen(ofSize: 16)
        backgroundSoundButton.alpha = 0.0
        backgroundSoundButton.layer.cornerRadius = backgroundSoundButton.frame.height/2
        backgroundSoundButton.backgroundColor = UIColor.black.withAlphaComponent(0.24)
        updateBackgroundSoundStyle()
    }
    
    private func reloadData(animated: Bool) {
        collectionView.performBatchUpdates({ [weak self] in
            self?.collectionView.reloadData()
            if animated {
                self?.animateCollectionWhenLoad()
            }
        }) { (finish) in }
        
    }
    
    private func togglePlay(indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! SoundEffectsCollectionCell
        
        
        if  cell.audio.playingStatus != BackgroundAudioVM.PlayingStatus.playing {
            cell.startPlayingAnimation()
            cell.audio.play()
            sendPlaySoundEffectEvent(name: cell.audio.title)
        } else {
            cell.stopPlayingAnimation(animated: true)
            cell.audio.stop()
        }
    }
    
    private func animateWhenLoad() {
        guard blurView.effect == nil else { return }
        
        delegate?.beginLoadAnimation()
        reloadData(animated: true)
        animateBackgroundWhenLoad()
    }
    
    private func animateBackgroundWhenLoad() {
         UIView.animate(withDuration: SoundEffectsViewController.duration) { [weak self] in
            self?.backgroundView.alpha = 1.0
            self?.backgroundSoundButton.alpha = 1.0
            self?.soundsButton.alpha = 1.0
            self?.collectionView.alpha = 1.0
            self?.blurView.effect = UIBlurEffect(style: .dark)
        }
    }
    
    private func animateWhenDismiss() {
        
        delegate?.beginDismissAnimation()
        animateCollectionWhenDismiss()
        animateBackgroundWhenDismiss()
    }
    
    private func animateBackgroundWhenDismiss() {
        UIView.animate(withDuration: SoundEffectsViewController.duration, animations: {
            [weak self] in
            self?.backgroundView.alpha = 0.0
            self?.volumeView.alpha = 0.0
            self?.backgroundSoundButton.alpha = 0.0
            self?.soundsButton.alpha = 0.0
            self?.collectionView.alpha = 0.0
            self?.blurView.effect = nil
        }) { [weak self] (finish) in
            self?.dismiss(animated: false, completion: nil)
        }
    }
    
    private func animateCollectionWhenLoad() {
        
        let indexPathes = collectionView.indexPathsForVisibleItems
        
        for indexPath in indexPathes {
            if let cell = collectionView.cellForItem(at: indexPath) {
                if needAnimation {
                    let translationX = (indexPath.item % 2 == 0) ? -cell.frame.width/2 : collectionView.frame.width - cell.frame.width/2
                    
                    cell.transform = CGAffineTransform(translationX: translationX, y: 0)
                    
                    UIView.animate(WithDuration: SoundEffectsViewController.duration, timing: CAMediaTimingFunction.easeOutQuart, animations: {
                        cell.transform = CGAffineTransform.identity
                    }, completion: nil)
                }
            }
        }
    }
    
    private func animateCollectionWhenDismiss() {
        
        let indexPathes = collectionView.indexPathsForVisibleItems
        
        for indexPath in indexPathes {
            if let cell = collectionView.cellForItem(at: indexPath) {
               
                if needAnimation {
                    let translationX = (indexPath.item % 2 == 0) ? -cell.frame.width/2 : collectionView.frame.width - cell.frame.width/2
                    UIView.animate(WithDuration: SoundEffectsViewController.duration, timing: CAMediaTimingFunction.easeOutQuart, animations: {
                        cell.transform = CGAffineTransform(translationX: translationX, y: 0)
                    }, completion: nil)
                }
               
            }
        }
    }
    
    private func updateBackgroundSoundStyle() {
        let image = (BackgroundAudioManager.shared.mainBackgroundAudio.playingStatus == .playing) ?  UIImage(named: "BackgroundMusicOn") :  UIImage(named: "BackgroundMusicOff")
        
        backgroundSoundButton.setImage(image, for: .normal)
    }
    
    @IBAction func soundsButtonTapped(_ sender: UIButton) {
        SystemSoundID.play(sound: .Sound2)
        animateWhenDismiss()
    }
    
    @IBAction func backgroundSoundButton(_ sender: UIButton) {
        if BackgroundAudioManager.shared.mainBackgroundAudio.playingStatus == .playing {
            BackgroundAudioManager.shared.stopBackgroundSound()
            UserDefaults.saveUserAppBackgroundSound(status: false)
        } else {
            BackgroundAudioManager.shared.playBackgroundSound()
            UserDefaults.saveUserAppBackgroundSound(status: true)
        }
        updateBackgroundSoundStyle()
    }
    
    private func sendPlaySoundEffectEvent(name: String) {
        TrackerManager.shared.sendPlaySoundEffectEvent(name: name)
    }
}

extension SoundEffectsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return audios.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SoundEffectsCollectionCell.identifier, for: indexPath) as! SoundEffectsCollectionCell
        cell.audio = audios[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - (2*20), height: 96)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.main.async { [weak self] in
            self?.togglePlay(indexPath: indexPath)
        }
    }
}

extension SoundEffectsViewController: SoundEffectsVolumeViewDelegate {
    
    func voulmeChanged(volume: Double) {
        BackgroundAudioManager.shared.volume = volume
    }
}

extension SoundEffectsViewController {
    
    class func instantiate() -> SoundEffectsViewController {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: SoundEffectsViewController.identifier) as! SoundEffectsViewController
        return viewController
    }
    
}
