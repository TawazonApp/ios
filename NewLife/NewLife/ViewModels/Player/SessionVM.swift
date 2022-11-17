//
//  SessionVM.swift
//  NewLife
//
//  Created by Shadi on 04/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class SessionVM: BaseLibrarySessionVM {
        
  
    var id: String? {
        return session?.id
    }
    
    var audioSources: [AudioSourceModel]?{
        return session?.audioSources
    }
    
    var author: String? {
        return session?.author
    }
    
    
    var audioUrl: URL? {
       return session?.audioUrl.url
    }
    
    var localAudioUrl: URL? {
        if let localAudioUrl = session?.localAudioPath, localAudioUrl.isEmptyWithTrim == false {
            return URL(fileURLWithPath: FileUtils.getFilePath(fileName: localAudioUrl))
        }
        return nil
    }
    
    var shareUrl: String? {
        return session?.shareLink
    }

    override var durationString: String?{
        if let selectedSessionDialect = getSessionPreferredVoiceAndDialect().dialect {
            return selectedSessionDialect.duration.seconds2Duration
        }
        return super.durationString
    }
    
    override func download() {
        guard let session = session else { return }
        LocalSessionsManager.shared.downloadSession(session: session, sessionURL: getSessionAudioSource()) {(error) in
            
        }
        sendDownloadSessionEvent(id: session.id, name: session.name)
    }
    
    private func sendDownloadSessionEvent(id: String, name: String) {
        TrackerManager.shared.sendDownloadSessionEvent(id: id, name: name)
    }
    
    func getSessionPreferredVoiceAndDialect() -> (voice: AudioSourceModel?, dialect: Dialect?){
        let userPreferredVoice = UserDefaults.selectedVoice()
        let userPreferredDialect = UserDefaults.selectedDialect()
        
        if userPreferredVoice == nil || userPreferredDialect == nil{
            return (nil,self.session?.defaultDialect)
        }
        let selectedSessionVoice = self.audioSources?.filter{$0.code == userPreferredVoice}.first
        var selectedSessionDialect = selectedSessionVoice?.dialects.filter{$0.code == userPreferredDialect}.first
        if selectedSessionDialect == nil{
            selectedSessionDialect = session?.defaultDialect
        }
        return (selectedSessionVoice, selectedSessionDialect)
    }
    
    func getSessionAudioSource() -> URL?{
        let selectedSessionDialect = getSessionPreferredVoiceAndDialect().dialect
        
        if !(selectedSessionDialect?.stream.isEmptyWithTrim ?? true) {
            return selectedSessionDialect!.stream.url
        }
        return self.audioUrl
    }
}
