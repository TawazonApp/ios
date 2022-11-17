//
//  GoalTableViewCell.swift
//  Tawazon
//
//  Created by mac on 17/10/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

protocol GoalTableViewCellDelegate: class {
    func selectGoal(goal: GoalVM)
}
class GoalTableViewCell: UITableViewCell {

    @IBOutlet weak var goalButton: UIButton!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var selectedIcon: UIImageView!
    
        var delegate : GoalTableViewCellDelegate?
        var goal : GoalVM?{
            didSet{
                fillData()
            }
        }
        override func awakeFromNib() {
            super.awakeFromNib()
            Initialize()
        }

        func Initialize(){
            self.backgroundColor = .clear
            self.selectionStyle = .none
            
            self.contentView.backgroundColor = .white
            self.contentView.layer.cornerRadius = 18
            
            goalButton.backgroundColor = .white
            goalButton.layer.cornerRadius = 18
            goalButton.tintColor = .black
            goalButton.titleLabel?.font = .munaFont(ofSize: 20)
//            goalButton.isHidden = true
            
            goalLabel.font = .munaFont(ofSize: 20)
            goalLabel.textColor = .black
            goalLabel.backgroundColor = .white
            goalLabel.layer.cornerRadius = 18
            goalLabel.textAlignment = .natural
            
            selectedIcon.image = UIImage(named: "DiscountCheckIcon")
            selectedIcon.backgroundColor = .clear
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()

            contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
        }
    
        func fillData(){
            goalButton.setTitle("", for: .normal)
            goalLabel.text = goal?.name
        }
        
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

            selectedIcon.isHidden = !selected
        }

        @IBAction func goalButtonTapped(_ sender: Any) {
            guard let goal = goal else{
                return
            }
            goal.isSelected.toggle()
            self.setSelected(goal.isSelected, animated: true)
            
            delegate?.selectGoal(goal: goal)
        }
    }
