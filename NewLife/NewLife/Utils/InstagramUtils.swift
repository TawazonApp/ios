//
//  InstagramUtils.swift
//  Tawazon
//
//  Created by Shadi on 15/05/2020.
//  Copyright © 2020 Inceptiontech. All rights reserved.
//

import UIKit

class InstagramUtils {
    static func shareInstagramStory(image: UIImage, link: String?, completion: ((Bool) -> Void)? = nil) {
        guard let urlScheme = URL(string: "instagram-stories://share"), UIApplication.shared.canOpenURL(urlScheme)
            else {
                completion?(false)
                return
        }
        
        let stickerImageData: Data = image.pngData()!
        var dictionary = [String: Any]()
        dictionary["com.instagram.sharedSticker.stickerImage"] = stickerImageData
        
        let backgroundImageData: Data =  UIImage(named: "InstagramStoryBG")!.pngData()!
        dictionary["com.instagram.sharedSticker.backgroundImage"] = backgroundImageData
        
        if let link = link {
            dictionary["com.instagram.sharedSticker.contentURL"] = link
        }
        let pasteboardOptions = [UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(60*5)]
        UIPasteboard.general.setItems([dictionary], options: pasteboardOptions)
        UIApplication.shared.open(urlScheme, options: [:], completionHandler: completion)
    }
}
