//
//  StringExt.swift
//  NewLife
//
//  Created by Shadi on 25/02/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    var url:URL? {
        var url:URL? = nil
        url = URL.init(string: self)
        if(url == nil) {
            let encodeString =  self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            if(encodeString != nil) {
                url = URL.init(string: encodeString!)
            }
        }
        return url
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    var localized: String {
        return Bundle.main.localizedString(forKey: self, value: nil, table: nil)
    }
    
    func isValid(regularExpression: String) -> Bool {
        let preidcate = NSPredicate(format:"SELF MATCHES %@", regularExpression)
        return preidcate.evaluate(with: self)
    }
    
    var isEmptyWithTrim: Bool {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty
    }
}

extension Int {
    var seconds2Duration: String {
        let hours = (self % 86400) / 3600
        let minutes = (self % 3600) / 60
        let seconds = (self % 3600) % 60
        if hours != 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    var seconds2Minutes: Int {
        return (self % 3600) / 60
    }
    
}

extension String {
    
    var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }
    var pathExtension: String {
        return (self as NSString).pathExtension
    }
    var stringByDeletingLastPathComponent: String {
        return (self as NSString).deletingLastPathComponent
    }
    var stringByDeletingPathExtension: String {
        return (self as NSString).deletingPathExtension
    }
    var pathComponents: [String] {
        return (self as NSString).pathComponents
    }
    func stringByAppendingPathComponent(path: String) -> String {
        let nsSt = self as NSString
        return nsSt.appendingPathComponent(path)
    }
    func stringByAppendingPathExtension(ext: String) -> String? {
        let nsSt = self as NSString
        return nsSt.appendingPathExtension(ext)
    }
}
