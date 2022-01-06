//
//  GoalsTitleView.swift
//  NewLife
//
//  Created by Shadi on 09/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

protocol GoalsTitleViewDelegate: class {
    func selectAllTapped(_ sender: GoalsTitleView)
}

class GoalsTitleView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectAllButton: UIButton!
    weak var delegate: GoalsTitleViewDelegate?
    var isSelectedAll = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize() {
        titleLabel.font = UIFont.lbc(ofSize: 24)
        titleLabel.textColor = UIColor.white
        titleLabel.text = "goalsViewTitle".localized
        selectAllButton.setTitle("selectAllGoalsButtonTitle".localized, for: .normal)
        selectAllButton.tintColor = UIColor.white
        selectAllButton.titleLabel?.font = UIFont.kacstPen(ofSize: 16)
        if UIApplication.isRTL() {
            selectAllButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        } else {
            selectAllButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        }
        updateSelectAllButtonStyle()
    }
    
    @IBAction func selectAllButtonTapped(_ sender: UIButton) {
        isSelectedAll.toggle()
        updateSelectAllButtonStyle()
        delegate?.selectAllTapped(self)
    }
    
    private func updateSelectAllButtonStyle() {
        let image = isSelectedAll ? UIImage(named: "Selected") : UIImage(named: "Unselected")
        selectAllButton.setImage(image, for: .normal)
    }
}
