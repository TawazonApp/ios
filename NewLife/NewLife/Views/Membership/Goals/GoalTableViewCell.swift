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
            
            self.contentView.backgroundColor = .clear
//            self.contentView.layer.cornerRadius = 18
            
//            goalButton.backgroundColor = .white
//            goalButton.layer.cornerRadius = 18
//            goalButton.tintColor = .black
//            goalButton.titleLabel?.font = .munaFont(ofSize: 20)
            
            goalButton.tintColor = .white
            goalButton.backgroundColor = .white.withAlphaComponent(0.08)
            goalButton.layer.cornerRadius = 20
            goalButton.layer.sublayers?.first(where: {$0.name == UIView.kLayerNameGradientBorder})?.removeFromSuperlayer()
            goalButton.titleLabel?.font = UIFont.munaFont(ofSize: 26)
            
            
            goalLabel.font = .munaFont(ofSize: 20)
            goalLabel.textColor = .white
            goalLabel.backgroundColor = .clear
            goalLabel.layer.cornerRadius = 20
            goalLabel.textAlignment = .natural
            
            selectedIcon.image = UIImage(named: "SelectedGoal")
            selectedIcon.backgroundColor = .clear
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()

//            contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
        }
    
        func fillData(){
            goalButton.setTitle("", for: .normal)
            goalLabel.text = goal?.name
            setSelectedStyle(goal?.isSelected ?? false)
            
        }
        
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
        }

    private func setSelectedStyle(_ selected: Bool) {
        selectedIcon.isHidden = !selected
        if selected{
            goalButton.tintColor = .white
            goalButton.layer.cornerRadius = 20
            goalButton.backgroundColor = .lightSkyBlue.withAlphaComponent(0.4)
            goalButton.gradientBorder(width: 1, colors:  [.mayaBlue, .mauve, .white.withAlphaComponent(0)], startPoint: .right, endPoint: .left, andRoundCornersWithRadius: 17)
            goalButton.titleLabel?.font = UIFont.munaBoldFont(ofSize: 20)
            
            goalLabel.font = UIFont.munaBoldFont(ofSize: 20)
        }else{
            goalButton.tintColor = .white
            goalButton.backgroundColor = .white.withAlphaComponent(0.08)
            goalButton.layer.cornerRadius = 20
            goalButton.layer.sublayers?.first(where: {$0.name == UIView.kLayerNameGradientBorder})?.removeFromSuperlayer()
            goalButton.titleLabel?.font = UIFont.munaFont(ofSize: 20)
            
            goalLabel.font = UIFont.munaFont(ofSize: 20)
        }
    }
    
        @IBAction func goalButtonTapped(_ sender: Any) {
            guard let goal = goal else{
                return
            }
            goal.isSelected.toggle()
            self.setSelectedStyle(goal.isSelected)
            delegate?.selectGoal(goal: goal)
        }
    }
