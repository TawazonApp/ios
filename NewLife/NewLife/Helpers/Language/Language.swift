//
//  L102Language.swift
//  Localization102
//
//  Created by Moath_Othman on 2/24/16.
//  Copyright © 2016 Moath_Othman. All rights reserved.
//

import UIKit


private let appleLanguagesKey = "AppleLanguages"

public enum Language: String {
    
    case `default` = "_"
    case english = "en"
    case arabic = "ar"
    
    public var semantic: UISemanticContentAttribute {
        switch self {
        case .default:
            return .unspecified
        case .arabic:
            return .forceRightToLeft
        default:
            return .forceLeftToRight
        }
    }
    
    public var isRTL: Bool {
        switch self {
        case .arabic:
            return true
        default:
            return false
        }
    }
    
    public static var language: Language {
        get {
            if let languageCode = UserDefaults.standard.string(forKey: appleLanguagesKey),
                let language = Language(rawValue: languageCode) {
                return language
                
            } else {
                
                let preferredLanguage = NSLocale.preferredLanguages[0]
                let index = preferredLanguage.index(preferredLanguage.startIndex, offsetBy: 2)
                if let localization = Language(rawValue: preferredLanguage), L102Localizer.supportedLanguages.contains(localization) {
                    return localization
                    
                } else if let localization = Language(rawValue: String(preferredLanguage[..<index])), L102Localizer.supportedLanguages.contains(localization) {
                    return localization
                    
                } else {
                    return Language.english
                }
            }
        }
        
        set {
            guard language != newValue else {
                return
            }
            
            if newValue == .default {
                UserDefaults.standard.removeObject(forKey: appleLanguagesKey)

            } else {
                UserDefaults.standard.set([newValue.rawValue], forKey: appleLanguagesKey)                
            }
            UIView.appearance().semanticContentAttribute = Language.language.semantic
            L102Localizer.configure()
        }
    }

    public static func languageCode() -> String {
        return self.language.rawValue
    }
}


//public extension String {
//
//    var localized: String {
//        return NSLocalizedString(self, comment: "")
//    }
//}


public extension UIImage {
    static func mirrorImage(named: String) -> UIImage? {
        guard let image = UIImage(named: named), let cgImage = image.cgImage else {
            return nil
        }
        if UIApplication.isRTL() {
             return UIImage(cgImage: cgImage, scale: image.scale, orientation: .upMirrored)
        } else {
            return image
        }
    }
}
