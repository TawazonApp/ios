//
//  CategorySessionVM.swift
//  NewLife
//
//  Created by Shadi on 27/02/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class CategorySessionVM: BaseSessionVM {
    
    init(session: SessionModel) {
        super.init()
        self.session = session
    }
    
    var name: String? {
        return session?.name
    }
    
    var durationString: String? {
        guard let duration = session?.duration else { return nil }
        return durationString(seconds: duration)
    }
    
    var imageUrl: String? {
       return session?.thumbnailUrl
    }
    
    var isLock: Bool {
        guard let session = session else { return true }
        return (session.isFree() == false && UserDefaults.isPremium() == false)
    }
    
    private func durationString(seconds: Int) -> String {
        return seconds.seconds2Duration
    }
    
}
