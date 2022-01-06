//
//  AudioPlayer.swift
//  NewLife
//
//  Created by Shadi on 16/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

import UIKit
import AVFoundation

/// AudioPlayer provides playback of audio data from a file or memory.
///
///  Using an audio player you can:
///
///  Play sounds of any duration
///
///  Play sounds from files or memory buffers
///
///  Loop sounds
///
///  Play multiple sounds simultaneously, one sound per audio player, with precise synchronization
///
///  Control relative playback level, stereo positioning, and playback rate for each sound you are playing
///
///  Seek to a particular point in a sound file, which supports such application features as fast forward and rewind
///
///  Obtain data you can use for playback-level metering
class AudioPlayer: NSObject, AVAudioPlayerDelegate {
    internal var player: AVAudioPlayer!
    
    var filename: String!
    
    /// Initializes a new audio player from a given file name
    /// ````
    /// let ap = AudioPlayer("audioTrackFileName")
    /// ````
    init?(_ name: String) {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: .default, options: .defaultToSpeaker)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Couldn't set up AVAudioSession")
        }
        
        super.init()
        
        guard let url = Bundle.main.url(forResource: name, withExtension: nil) else {
            print("Could not retrieve url for \(name)")
            return nil
        }
        
        guard let player = try? AVAudioPlayer(contentsOf: url) else {
            print("Could not create player from contents of : \(url)")
            return nil
        }
        
        self.player = player
        player.delegate = self
        self.filename = name
    }
    
    convenience init?(copy original: AudioPlayer) {
        self.init(original.filename)
    }
    
    /// Plays a sound asynchronously.
    func play() {
        player.play()
    }
    
    /// Pauses playback; sound remains ready to resume playback from where it left off.
    /// Calling pause leaves the audio player prepared to play; it does not release the audio hardware that was acquired upon
    /// calling play or prepareToPlay.
    func pause() {
        player.pause()
    }
    
    /// Stops playback and undoes the setup needed for playback.
    /// Calling this method, or allowing a sound to finish playing, undoes the setup performed upon calling the play or
    /// prepareToPlay methods.
    /// The stop method does not reset the value of the currentTime property to 0. In other words, if you call stop during
    /// playback and then call play, playback resumes at the point where it left off.
    func stop() {
        player.stop()
    }
    
    /// Returns the total duration, in seconds, of the sound associated with the audio player. (read-only)
    var duration: Double {
        return Double(player.duration)
    }
    
    /// Returns true if the receiver's current playback rate > 0. Otherwise returns false.
    var playing: Bool {
        return player.isPlaying
    }
    
    /// The audio player’s stereo pan position.
    /// By setting this property you can position a sound in the stereo field. A value of –1.0 is full left, 0.0 is center, and
    /// 1.0 is full right.
    var pan: Double {
        get {
            return Double(player.pan)
        } set(val) {
            player.pan = clamp(Float(val), min: -1.0, max: 1.0)
        }
    }
    
    /// The playback volume for the audio player, ranging from 0.0 through 1.0 on a linear scale.
    /// A value of 0.0 indicates silence; a value of 1.0 (the default) indicates full volume for the audio player instance.
    /// Use this property to control an audio player’s volume relative to other audio output.
    /// To provide UI in iOS for adjusting system audio playback volume, use the MPVolumeView class, which provides media
    /// playback controls that users expect and whose appearance you can customize.
    var volume: Double {
        get {
            return Double(player.volume)
        } set(val) {
            player.volume = Float(val)
        }
    }
    
    /// The playback point, in seconds, within the timeline of the sound associated with the audio player.
    /// If the sound is playing, currentTime is the offset of the current playback position, measured in seconds from the start
    /// of the sound. If the sound is not playing, currentTime is the offset of where playing starts upon calling the play
    /// method, measured in seconds from the start of the sound.
    /// By setting this property you can seek to a specific point in a sound file or implement audio fast-forward and rewind
    /// functions.
    var currentTime: Double {
        get {
            return player.currentTime
        } set(val) {
            player.currentTime = TimeInterval(val)
        }
    }
    
    /// The audio player’s playback rate.
    /// This property’s default value of 1.0 provides normal playback rate. The available range is from 0.5 for half-speed
    /// playback through 2.0 for double-speed playback.
    /// To set an audio player’s playback rate, you must first enable rate adjustment as described in the enableRate property
    /// description.
    /// ````
    /// let ap = AudioPlayer("audioTrackFileName")
    /// ap.enableRate = true
    /// ap.rate = 0.5
    /// ap.play()
    /// ````
    var rate: Double {
        get {
            return Double(player.rate)
        } set {
            player.rate = Float(newValue)
        }
    }
    
    /// The number of times a sound will return to the beginning, upon reaching the end, to repeat playback.
    /// A value of 0, which is the default, means to play the sound once. Set a positive integer value to specify the number of
    /// times to return to the start and play again. For example, specifying a value of 1 results in a total of two plays of the
    /// sound. Set any negative integer value to loop the sound indefinitely until you call the stop method.
    /// Defaults to 1000000.
    var loops: Bool {
        get {
            return player.numberOfLoops > 0 ? true : false
        }
        set(val) {
            if val {
                player.numberOfLoops = 1000000
            } else {
                player.numberOfLoops = 0
            }
        }
    }
    
    /// A Boolean value that specifies the audio-level metering on/off state for the audio player.
    /// The default value for the meteringEnabled property is off (Boolean false). Before using metering for an audio player, you need to enable it by setting this
    /// property to true. If player is an audio player instance variable of your controller class, you enable metering as shown here:
    /// ````
    /// let ap = AudioPlayer("audioTrackFileName")
    /// ap.meteringEnabled = true
    /// ````
    var meteringEnabled: Bool {
        get {
            return player.isMeteringEnabled
        } set(v) {
            player.isMeteringEnabled = v
        }
    }
    
    /// A Boolean value that specifies whether playback rate adjustment is enabled for an audio player.
    /// To enable adjustable playback rate for an audio player, set this property to true after you initialize the player and before you call the prepareToPlay
    /// instance method for the player.
    var enableRate: Bool {
        get {
            return player.enableRate
        } set(v) {
            player.enableRate = v
        }
    }
    
    /// Refreshes the average and peak power values for all channels of an audio player.
    /// To obtain current audio power values, you must call this method before calling averagePowerForChannel: or peakPowerForChannel:.
    /// ````
    /// let t = NSTimer.scheduledTimerWithTimeInterval(1.0/60.0,
    ///                                        target: self,
    ///                                      selector: "update",
    ///                                      userInfo: nil,
    ///                                       repeats: true)
    /// let ap = AudioPlayer("audioTrackFileName")
    /// ap.meteringEnabled = true
    /// func update() {
    ///     ap.updateMeters()
    /// }
    /// ````
    func updateMeters() {
        player.updateMeters()
    }
    
    /// Returns the average power for a given channel, in decibels, for the sound being played.
    /// ````
    /// func update() {
    ///     let av = player.averagePower(channel: 0)
    /// }
    /// ````
    /// - parameter channel: The audio channel whose average power value you want to obtain.
    /// - returns: A floating-point representation, in decibels, of a given audio channel’s current average power.
    func averagePower(_ channel: Int) -> Double {
        return Double(player.averagePower(forChannel: channel))
    }
    
    /// Returns the peak power for a given channel, in decibels, for the sound being played.
    /// ````
    /// func update() {
    ///     let pk = player.peakPower(channel: 0)
    /// }
    /// - parameter channel: The audio channel whose peak power value you want to obtain.
    /// - returns: A floating-point representation, in decibels, of a given audio channel’s current peak power.
    func peakPower(_ channel: Int) -> Double {
        return Double(player.peakPower(forChannel: channel))
    }
    
     func clamp<T: Comparable>(_ val: T, min: T, max: T) -> T {
        assert(min < max, "min has to be less than max")
        if val < min { return min }
        if val > max { return max }
        return val
    }
}
