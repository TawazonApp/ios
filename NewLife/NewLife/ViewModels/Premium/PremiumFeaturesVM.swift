//
//  PremiumFeaturesVM.swift
//  NewLife
//
//  Created by Shadi on 19/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class PremiumFeaturesVM: NSObject {

    var tableArray: [PremiumFeatureCellVM] = []
    
    override init() {
        super.init()
        tableArray = initializeFeatures()
    }
    
    private func initializeFeatures() -> [PremiumFeatureCellVM] {
        
        let monthlyMeditation = PremiumFeatureCellVM(title: "premiumMonthlyMeditationTitle".localized, iconAEName: "MonthlyMeditation")
        
        let meditationTraining = PremiumFeatureCellVM(title: "premiumMeditationTrainingTitle".localized, iconAEName: "MeditationTraining")
        
        let childrenMeditation = PremiumFeatureCellVM(title: "premiumChildrenMeditationTitle".localized, iconAEName: "ChildrenMeditation")
        
        let foodBodyMeditation = PremiumFeatureCellVM(title: "premiumFoodBodyMeditationTitle".localized, iconAEName: "BodyMeditation")
        
        return [monthlyMeditation, meditationTraining, childrenMeditation, foodBodyMeditation]
    }
}
