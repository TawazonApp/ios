//
//  GerneralExt.swift
//  NewLife
//
//  Created by Shadi on 25/02/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox

extension CGFloat {
    var deg2rad: CGFloat {
        return self * .pi / 180
    }
    
}


extension Encodable {
    func jsonDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}

extension Collection {
    public subscript(safe index: Index) -> Element? {
        return startIndex <= index && index < endIndex ? self[index] : nil
    }
}

extension Array where Element: Equatable{
    mutating func remove (element: Element) {
        if let i = self.index(of: element) {
            self.remove(at: i)
        }
    }
}


extension NSNotification.Name {
    static let downloadSessionsProgressChanged = NSNotification.Name(rawValue: "DownloadSessionsProgressChanged")
    
    static let sessionModelFavoriteStatusChanged = NSNotification.Name(rawValue: "SessionModelFavoriteStatusChanged")
    
    static let sessionModelDownloadValuesChanged = NSNotification.Name(rawValue: "SessionModelDownloaded")
    
    static let showSessionPlayerBar = NSNotification.Name(rawValue: "showSessionPlayerBar")
    
    static let hideSessionPlayerBar = NSNotification.Name(rawValue: "hideSessionPlayerBar")
    
    static let didReceiveRemoteNotification = NSNotification.Name(rawValue: "didReceiveRemoteNotification")
    
    static let remoteAudioControlDidReceived = NSNotification.Name(rawValue: "remoteAudioControlDidReceived")
    
    
      static let userPremiumStatusChanged = NSNotification.Name(rawValue: "userPremiumStatusChanged")
    
    static let backgroundSoundStatusChanged = NSNotification.Name(rawValue: "backgroundSoundStatusChanged")
    
    static let languageChanged = NSNotification.Name(rawValue: "LanguageDidChange")
    
}

extension SystemSoundID {
    enum AppSounds {
        case CancelLoginSignup
        case LaunchToHome
        case goals
        case selectGoal
        case switchOnOff
        case Sound1
        case Sound2
        case Sound3
        
    }
    
    static func play(sound: AppSounds) {
       // let soundFile = SystemSoundID.soundFile(sound: sound)
       // playFileNamed(fileName: soundFile.fileName, withExtenstion: soundFile.fileExtension)
    }
    
    static func playFileNamed(fileName: String, withExtenstion fileExtension: String) {
        var sound: SystemSoundID = 0
        if let soundURL = Bundle.main.url(forResource: fileName, withExtension: fileExtension) {
            AudioServicesCreateSystemSoundID(soundURL as CFURL, &sound)
            AudioServicesPlaySystemSound(sound)
        }
    }
    
    private static func soundFile(sound: AppSounds) -> (fileName: String, fileExtension: String) {
        switch sound {
        case .CancelLoginSignup:
            return (fileName: "CancelLoginSignup", fileExtension: "wav")
        case .LaunchToHome:
            return (fileName: "LaunchToHome", fileExtension: "wav")
        case .goals:
            return (fileName: "Goals", fileExtension: "wav")
        case .selectGoal:
            return (fileName: "SelectGoal", fileExtension: "wav")
        case .switchOnOff:
            return (fileName: "SwitchOnOff", fileExtension: "wav")
        case .Sound1:
            return (fileName: "Sound1", fileExtension: "wav")
        case .Sound2:
            return (fileName: "Sound2", fileExtension: "wav")
        case .Sound3:
            return (fileName: "Sound3", fileExtension: "wav")
            
        }
    }
}

extension DateFormatter {
    
    class var serverFormat: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone(identifier:"GMT")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }
    
    class var todayDate: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone(identifier:"GMT")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }
}

extension RangeExpression where Bound == String.Index  {
    func nsRange<S: StringProtocol>(in string: S) -> NSRange { .init(self, in: string) }
}
