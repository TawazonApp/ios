//
//  HomeTableFeelingCellVM.swift
//  Tawazon
//
//  Created by Shadi on 15/11/2020.
//  Copyright © 2020 Inceptiontech. All rights reserved.
//

import UIKit

enum DayTime {
    case morning
    case evening
    case afternoon
    
    var dradientColors: [UIColor] {
        switch self {
        case .morning:
            return [.pale, .paleRose, .lightBlueGreyThree]
        case .evening, .afternoon:
            return [.darkIndigoFive, .metallicBlue]
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .morning:
            return .dark
        case .evening, .afternoon:
            return .white
        }
    }
    
    var title: String {
        switch self {
        case .morning:
            return "homeFeelingMorningTitle".localized
        case .evening:
            return "homeFeelingEveningTitle".localized
        case .afternoon:
            return "homeFeelingAfterNoonTitle".localized
        }
    }
    
    var image: UIImage? {
        switch self {
        case .morning:
            return UIImage(named: "FeelingMorning")
        case .evening, .afternoon:
            return UIImage(named: "FeelingEvening")
        }
    }
}

class HomeTableFeelingCellVM {
    
    let homeService: HomeService!
    var dayTime: DayTime  {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 12 {
            return .morning
        } else if hour >= 12, hour < 16 {
            return .afternoon
        } else {
            return .evening
        }
    }
    var userName: String {
        let name = (UserInfoManager.shared.getUserInfo()?.name ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        return String(name.split(separator: " ").first ?? "")
    }
    var feelingSelected: Bool {
        return (feelings.first{ $0.isSelected } != nil)
    }
    var feelings: [FeelCellModel] = []
    
    var sessionsSection: HomeSectionVM?
    
    init(homeService: HomeService) {
        self.homeService = homeService
    }
    
    func unselectFeelings() {
        for feel in feelings {
            feel.isSelected = false
        }
    }
    func getFeelingSessions(completion: @escaping (_ error: CustomError?) -> Void) {
        homeService.getFeelingSessions { [weak self] (feelingsSessions, error) in
            if let feelingsSessions = feelingsSessions {
                let feelingsString = feelingsSessions.feelings?.compactMap({ $0.title }).joined(separator: "، ")
                let title = "homeFeelingSubtitle".localized.replacingOccurrences(of: "{feel}", with: feelingsString ?? "")
                self?.sessionsSection = HomeSectionVM(id: "0", title: title, subTitle: nil, iconUrl: nil, sessions: feelingsSessions.items, style: .largeList, buttonLabel: "", moreLabel: "")
            }
            completion(error)
        }
    }
    
    func getFeelings(completion: @escaping (_ error: CustomError?) -> Void) {
        homeService.getFeelings { [weak self] (feelingsList, error) in
            if let feelingsList = feelingsList {
                self?.feelings = feelingsList.items.map({ FeelCellModel(id: $0.id, name: $0.title, isSelected: ($0.selected != 0) ) })
            } else {
                self?.feelings = []
            }
            completion(error)
        }
    }
    
    func updateFeelings(feelingIds: [String], completion: @escaping (_ error: CustomError?) -> Void) {
        homeService.updateFeelings(feelingIds: feelingIds) { (error) in
            if error == nil {
                for feel in self.feelings {
                    feel.isSelected = feelingIds.contains(feel.id)
                }
            }
            completion(error)
        }
    }

}
