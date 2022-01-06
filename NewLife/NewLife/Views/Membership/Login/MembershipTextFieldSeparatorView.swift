//
//  MembershipTextFieldSeparatorView.swift
//  NewLife
//
//  Created by Shadi on 07/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class MembershipTextFieldSeparatorView: UIView {
  
    var status: MembershipFormTextFieldCellVM.Status = .none {
        didSet {
            updateStyle()
        }
    }
    
    private func updateStyle() {
        self.isHidden = (status == .none)
        self.backgroundColor = (status == .error) ? UIColor.orangePink : UIColor.brightLilac
    }
}
