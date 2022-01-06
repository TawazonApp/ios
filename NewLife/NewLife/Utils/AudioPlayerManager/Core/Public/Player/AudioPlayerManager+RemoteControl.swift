//
//  AudioPlayerManager+RemoteControl.swift
//  AudioPlayerManager
//
//  Created by Hans Seiffert on 02.08.16.
//  Copyright © 2016 Hans Seiffert. All rights reserved.
//

import UIKit

extension AudioPlayerManager {

	public func remoteControlReceivedWithEvent(_ event: UIEvent?) {
		if let _event = event {
			switch _event.subtype {
            case UIEvent.EventSubtype.remoteControlPlay:
				self.play()
            case UIEvent.EventSubtype.remoteControlPause:
				self.pause()
//            case UIEventSubtype.remoteControlNextTrack:
//                //self.forward()
//            case UIEventSubtype.remoteControlPreviousTrack:
//                //self.rewind()
            case UIEvent.EventSubtype.remoteControlTogglePlayPause:
				self.togglePlayPause()
			default:
				break
			}
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "remoteAudioControlDidReceived"), object: event)
		}
	}
}
