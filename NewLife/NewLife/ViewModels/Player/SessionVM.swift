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

    override func download() {
        super.download()
        guard let session = session else { return }
        sendDownloadSessionEvent(id: session.id, name: session.name)
    }
    
    private func sendDownloadSessionEvent(id: String, name: String) {
        TrackerManager.shared.sendDownloadSessionEvent(id: id, name: name)
    }
    func getSessionAudioSource() -> String{
        let userPreferredVoice = UserDefaults.selectedVoice()
        let userPreferredDialect = UserDefaults.selectedDialect()
        
        let selectedSessionVoice = self.audioSources?.filter{$0.title == userPreferredVoice}.first
        let selectedSessionDialect = selectedSessionVoice?.dialects.filter{$0.title == userPreferredDialect}.first
        
        if !(selectedSessionDialect?.stream.isEmptyWithTrim ?? true) {
            return selectedSessionDialect!.stream
        }
        //TODO: return fall-back link
        return ""
    }
}
