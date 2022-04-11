//
//  UIFontExt.swift
//  NewLife
//
//  Created by Shadi on 25/02/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

extension UIFont {
    //"SFProRounded-Bold", "SFProRounded-Regular", "SFProRounded-Light", "SFProRounded-Medium"
    //["SFProText-Black", "SFProText-Bold", "SFProText-Light", "SFProText-Regular"]
    static let englishSizeOffset: CGFloat = -3
    class func kacstPen(ofSize: CGFloat, language: Language = Language.language) -> UIFont {
        if language == .arabic {
            return UIFont.init(name: "KacstPen", size: ofSize)!
        }
        return UIFont.init(name: "SFProRounded-Regular", size: ofSize + englishSizeOffset)!
    }
    
    class func lbc(ofSize: CGFloat, language: Language = Language.language) -> UIFont {
        if language == .arabic {
            return UIFont.init(name: "lbc", size: ofSize)!
        }
        return UIFont.init(name: "SFProRounded-Regular", size: ofSize + englishSizeOffset)!
    }
    
    class func lbcBold(ofSize: CGFloat, language: Language = Language.language)-> UIFont {
        if language == .arabic {
            return UIFont.init(name: "lbc-bold", size: ofSize)!
        }
        return UIFont.init(name: "SFProRounded-Bold", size: ofSize + englishSizeOffset)!
    }
    
    class func kohinoorRegular(ofSize: CGFloat, language: Language = Language.language)-> UIFont {
        if language == .arabic {
            return UIFont.init(name: "KohinoorArabic-Regular", size: ofSize)!
        }
        return UIFont.init(name: "SFProText-Regular", size: ofSize + englishSizeOffset)!
    }
    
    class func kohinoorBold(ofSize: CGFloat, language: Language = Language.language)-> UIFont {
        if language == .arabic {
            return UIFont.init(name: "KohinoorArabic-Bold", size: ofSize)!
        }
        return UIFont.init(name: "SFProText-Bold", size: ofSize + englishSizeOffset)!
    }
    class func kohinoorSemiBold(ofSize: CGFloat, language: Language = Language.language)-> UIFont {
        if language == .arabic {
            return UIFont.init(name: "KohinoorArabic-Semibold", size: ofSize)!
        }
        return UIFont.init(name: "SFProText-Semibold", size: ofSize + englishSizeOffset)!
        
    }
    
    class func sanaFont(ofSize: CGFloat, language: Language = Language.language) -> UIFont {
        if language == .arabic {
            return UIFont.init(name: "Sana", size: ofSize)!
        }
        return UIFont.init(name: "SFProRounded-Regular", size: ofSize + englishSizeOffset)!
    }
    
    class func munaFont(ofSize: CGFloat, language: Language = Language.language) -> UIFont {
        if language == .arabic {
            return UIFont.init(name: "Muna", size: ofSize)!
        }
        return UIFont.init(name: "SFProRounded-Regular", size: ofSize + englishSizeOffset)!
    }
    
    class func munaBoldFont(ofSize: CGFloat, language: Language = Language.language)-> UIFont {
        if language == .arabic {
            return UIFont.init(name: "MunaBold", size: ofSize)!
        }
        return UIFont.init(name: "SFProRounded-Bold", size: ofSize + englishSizeOffset)!
    }
}

