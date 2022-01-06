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
    
    var descriptionString: String? {
        return session?.descriptionString
    }
    
    var durationString: String? {
        guard let duration = session?.duration else { return nil }
        return durationString(seconds: duration)
    }
    
    private func durationString(seconds: Int) -> String {
        return "\(seconds.seconds2Minutes) \("mintues".localized)"
    }
    
    var isLock: Bool {
        return session?.isLock ?? true
    }
}
