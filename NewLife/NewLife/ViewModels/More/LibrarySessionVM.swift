//
//  LibrarySessionVM.swift
//  NewLife
//
//  Created by Shadi on 05/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit
enum SessionDownloadStatus {
    case downloading
    case downloaded
    case none
}

class LibrarySessionVM: BaseLibrarySessionVM {
    
    var descriptionString: String? {
        return session?.descriptionString
    }
    
    override var imageUrl: URL? {
        return session?.thumbnailUrl?.url
    }
    
    override var localImageUrl: URL? {
        if let localImageUrl = session?.localThumbnailPath, localImageUrl.isEmptyWithTrim == false {
            return URL(fileURLWithPath: FileUtils.getFilePath(fileName: localImageUrl))
        }
        return nil
    }
 
    
    func deleteSession(completion: @escaping (CustomError?) -> Void) {
        guard let session = session else { return }
        LocalSessionsManager.shared.deleteSessionFromDownload(session: session) {(error) in
            completion(error)
        }
        
    }
    
}
