//
//  GoalCircleCollectionCell.swift
//  NewLife
//
//  Created by Shadi on 10/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit
import AudioToolbox

class GoalCircleView: GradientView {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var selectedColors: [UIColor]!
    var colors: [UIColor] = [UIColor.black.withAlphaComponent(0.5), UIColor.black.withAlphaComponent(0.5)]
    var borderColor: UIColor!
    
    var goal: GoalVM? {
        didSet {
            fillData()
        }
    }
    
    var index: Int! {
        didSet {
            initializeColors()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize() {
        self.backgroundColor = UIColor.clear
        self.layer.masksToBounds = true
        nameLabel.font = UIFont.kacstPen(ofSize: 18)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:))))
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        if goal?.isSelected == false {
             SystemSoundID.play(sound: .selectGoal)
        }
        goal?.isSelected.toggle()
        updateSelectedStyle()
    }
    
    private func initializeColors() {
        if index == 0 {
            selectedColors = [UIColor.liliacTwo, UIColor.periwinkleBlueTwo]
            borderColor = UIColor.periwinkleBlueTwo
        } else if index == 1 {
            selectedColors = [UIColor.salmon, UIColor.bubbleGumPink]
            borderColor = UIColor.carnation
        } else if index == 2 {
            selectedColors = [UIColor.lightUrple, UIColor.pastelPurple]
            borderColor = UIColor.periwinkle
        } else if index == 3 {
            selectedColors = [UIColor.paleMauve, UIColor.palePurple]
            borderColor = UIColor.lavender
        } else if index == 4 {
            selectedColors = [UIColor.salmon, UIColor.bubbleGumPink]
            borderColor = UIColor.carnationTwo
        }  else if index == 5 {
            selectedColors = [UIColor.salmon, UIColor.bubbleGumPink]
            borderColor = UIColor.carnationThree
        } else if index == 6 {
            selectedColors = [UIColor.bubblegum, UIColor.lightPurple]
            borderColor = UIColor.lavenderPink
        } else if index == 7 {
            selectedColors = [UIColor.pastelPurpleTwo, UIColor.purpley]
            borderColor = UIColor.liliac
        } else if index == 8 {
            selectedColors = [UIColor.cornflower, UIColor.periwinkleTwo]
            borderColor = UIColor.lavenderBlue
        }
    }
    
    private func fillData() {
        updateLayout()
        updateSelectedStyle()
        nameLabel.text = goal?.name
    }
    
    func updateSelectedStyle() {
        
        let isSelected = goal?.isSelected ?? false
        
        if isSelected {
            applyGradientColor(colors: selectedColors.map({return $0.cgColor}), startPoint: .top, endPoint: .bottom)
            layer.borderWidth = 0.0
            layer.borderColor = UIColor.clear.cgColor
            nameLabel.textColor = UIColor.darkIndigo
        } else {
            applyGradientColor(colors: colors.map({return $0.cgColor}), startPoint: .top, endPoint: .bottom)
            layer.borderWidth = 1.0
            layer.borderColor = borderColor.cgColor
            nameLabel.textColor = UIColor.white
        }
    }
    
    func updateLayout() {
         self.layer.cornerRadius = self.frame.size.height/2
    }
}
