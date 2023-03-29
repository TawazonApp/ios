//
//  GoalsVM.swift
//  NewLife
//
//  Created by Shadi on 10/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class GoalsVM: NSObject {
    
    let service: MembershipService!
    var goalsModel: GoalsModel? {
        didSet {
            buildGoalsArray()
        }
    }
    
    var goals: [GoalVM] = []
    
    init(service: MembershipService) {
        self.service = service
    }
    
    private func buildGoalsArray() {
        goals = goalsModel?.goals?.map({ return GoalVM(id: $0.id, name: $0.name , isSelected: $0.isSelected())}) ?? []
    }
   
    func fetchGoals(completion: @escaping (_ error: CustomError?) -> Void) {
        if let goalsModel = UserInfoManager.shared.getGoals() , goalsModel.goals?.count ?? 0 > 0{
            self.goalsModel = goalsModel
            completion(nil)
        } else {
            fetchGoalsFromService { [weak self] (error) in
                self?.goalsModel = UserInfoManager.shared.getGoals()
                completion(error)
            }
        }
    }
    
    func fetchGoalsFromService(completion: @escaping (_ error: CustomError?) -> Void) {
        service.fetchUserGoals { (goals, error) in
            if error == nil {
                UserInfoManager.shared.setGoals(goals: goals)
            }
            completion(error)
        }
    }
    
    func updateSelectAll(selected: Bool) {
        for goal in goals {
            goal.isSelected = selected
        }
    }
    
    func sendSelectedGoalsFromService(completion: @escaping (_ error: CustomError?) -> Void) {
        
        guard let goalsModel = goalsModel else {
            completion(CustomError(message: "goalsSubmitEmptyGoalsError".localized, statusCode: nil))
            return
        }
        
        let selectedIds = goals.filter({$0.isSelected}).map({ return $0.id }) as? [String]
        
        guard selectedIds != nil else {
            completion(CustomError(message: "goalsSubmitEmptyGoalsError".localized, statusCode: nil))
            return
        }
        
        let selectedGoalsIds = GoalsIdsModel.init(goals: selectedIds!)
        service.setUserGoals(selectedGoalsIds: selectedGoalsIds) { (error) in
            
            //Update cache values if success
            if error == nil {
                for var goal in goalsModel.goals ?? [] {
                    let isSelected = (selectedIds!.contains(goal.id)) ? true : false
                    goal.setSelected(isSelected: isSelected)
                }
                UserInfoManager.shared.setGoals(goals: goalsModel)
            }
            completion(error)
        }
        sendSetGoalEvent()
    }
    
    private func sendSetGoalEvent() {
        for goal in goals.filter({$0.isSelected}) {
            TrackerManager.shared.sendSetGoalEvent(id: goal.id, name: goal.name)
            TrackerManager.shared.sendEvent(name: GeneralCustomEvents.goalsScreenSubmit, payload: [goal.id : goal.name])
        }
    }
}
