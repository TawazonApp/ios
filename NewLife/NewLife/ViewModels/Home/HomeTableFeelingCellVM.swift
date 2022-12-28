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
        return (subfeelings.first{ $0.isSelected } != nil)
    }
    var feelings: [FeelCellModel] = []
    
    var subfeelings: [SubfeelingCellModel] = []
    
    var sessionsSection: HomeSectionVM?
    
    init(homeService: HomeService) {
        self.homeService = homeService
    }
    
    func unselectFeelings() {
        for feel in subfeelings {
            feel.isSelected = false
        }
    }
    func getFeelingSessions(completion: @escaping (_ error: CustomError?) -> Void) {
        homeService.getFeelingSessions { [weak self] (feelingsSessions, error) in
            if let feelingsSessions = feelingsSessions {
                let feelingsString = feelingsSessions.feelings?.compactMap({ $0.title }).joined(separator: "، ")
                let title = "homeFeelingSubtitle".localized.replacingOccurrences(of: "{feel}", with: feelingsString ?? "")
                //FIXME: need backend to sent the related tawazon talk for feeling
                self?.sessionsSection = HomeSectionVM(id: "0", title: title, subTitle: nil, iconUrl: nil, sessions: feelingsSessions.items, items: [], style: .largeList, type: 0, buttonLabel: "", moreLabel: "")
            }
            completion(error)
        }
    }
    
    func getFeelings(completion: @escaping (_ error: CustomError?) -> Void) {
        homeService.getFeelings { [weak self] (feelingsList, error) in
            if let feelingsList = feelingsList {
                
                self?.feelings = feelingsList.items.map({ FeelCellModel(id: $0.id, name: $0.title, priority: $0.priority, subFeelings: $0.subFeelings?.sorted(by: { return $0.priority < $1.priority}), isSelected: ($0.selected != 0) ) })
                self?.feelings.sorted(by: { return $0.priority < $1.priority}).forEach{
                    if let subfeelingItems = $0.subFeelings{
                        self?.subfeelings.append(contentsOf: subfeelingItems.map({SubfeelingCellModel(id: $0.id, name: $0.title, isSelected: ($0.selected != 0), priority: $0.priority)}))
                    }
                    
                }
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
