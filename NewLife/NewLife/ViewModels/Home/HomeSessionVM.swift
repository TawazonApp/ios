//
//  HomeSessionVM.swift
//  NewLife
//
//  Created by Shadi on 16/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class HomeSessionVM: BaseSessionVM {
    
    init(session: SessionModel) {
        super.init()
        self.session = session
    }
    
    var name: String? {
        return session?.name
    }
    
    var imageUrl: String? {
        return session?.thumbnailUrl
    }
    
    var audioSources: [AudioSourceModel]?{
        return session?.audioSources
    }
    
    var descriptionString: String? {
        return session?.descriptionString
    }
    
    var durationString: String? {
        if let selectedSessionDialect = getSessionPreferredVoiceAndDialect().dialect {
            return durationString(seconds: selectedSessionDialect.duration)
        }
        
        guard let duration = session?.duration else { return nil }
        return durationString(seconds: duration)
    }
    
    private func durationString(seconds: Int) -> String {
        return "\(seconds.seconds2Minutes) \("mintues".localized)"
    }
    
    var isLock: Bool {
        return session?.isLock ?? true
    }
    
    func getSessionPreferredVoiceAndDialect() -> (voice: AudioSourceModel?, dialect: Dialect?){
        let userPreferredVoice = UserDefaults.selectedVoice()
        let userPreferredDialect = UserDefaults.selectedDialect()
        
        if userPreferredVoice == nil || userPreferredDialect == nil {
            return (nil,nil)
        }
        let selectedSessionVoice = self.audioSources?.filter{$0.code == userPreferredVoice}.first
        let selectedSessionDialect = selectedSessionVoice?.dialects.filter{$0.code == userPreferredDialect}.first
        
        return (selectedSessionVoice, selectedSessionDialect)
    }
}
