//
//  HomeVideoCellVM.swift
//  NewLife
//
//  Created by Shadi on 27/02/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class HomeVideoCellVM: NSObject {
    let videoName: String!
    let videoType: String!
    
    init(videoName: String, videoType: String) {
        self.videoName = videoName
        self.videoType = videoType
    }
    
}
