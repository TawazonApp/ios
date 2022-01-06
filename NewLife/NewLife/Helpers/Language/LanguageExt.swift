//
//  Language.swift
//  POS
//
//  Created by Shadi Awwad on 7/21/19.
//  Copyright © 2019 Shadi Awwad. All rights reserved.
//

import Foundation

extension Language {
    static func getLanguageString() -> String {
        return self.language.getLanguageString()
    }
    
    func getLanguageString() -> String {
        switch self {
        case .arabic:
            return "العربية"
        case .english:
            return "English"
        case .default:
            return "English"
        }
    }
    
    static func getSupportedLanguages() -> [Language] {
        return L102Localizer.supportedLanguages
    }
}
