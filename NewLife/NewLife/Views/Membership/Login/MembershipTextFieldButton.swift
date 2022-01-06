//
//  MembershipTextFieldButton.swift
//  NewLife
//
//  Created by Shadi on 08/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class MembershipTextFieldButton: UIButton {
    
    var status: MembershipFormTextFieldCellVM.Status = .none {
        didSet {
            updateStyle()
        }
    }
    
    private func updateStyle() {
        self.isHidden = false
        if status == .valid {
            setImage(#imageLiteral(resourceName: "TextFieldButtonValid.pdf"), for: .normal)
        } else if status == .error {
            setImage(#imageLiteral(resourceName: "TextFieldButtonError.pdf"), for: .normal)
        } else {
            self.isHidden = true
        }
    }

}
