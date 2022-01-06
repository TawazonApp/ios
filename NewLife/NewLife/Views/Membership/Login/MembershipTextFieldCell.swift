//
//  MembershipTextFieldCell.swift
//  NewLife
//
//  Created by Shadi on 07/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit
protocol MembershipTextFieldCellDelegate: class {
    func triggerSubmitButton()
}

class MembershipTextFieldCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var textFeild: UITextField!
    @IBOutlet weak var textFieldButton: MembershipTextFieldButton!
    @IBOutlet weak var coloredView: UIView!
    @IBOutlet weak var separatorView: MembershipTextFieldSeparatorView!

    weak var delegate: MembershipTextFieldCellDelegate?
    
    var data: MembershipFormTextFieldCellVM! {
        didSet {
            fillData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize() {
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        
        textFeild.textColor = UIColor.white
        textFeild.font = UIFont.kacstPen(ofSize: 16)
        textFeild.tintColor = UIColor.brightLilac
        textFeild.keyboardAppearance = UIKeyboardAppearance.dark
        
        textFeild.textAlignment = UIApplication.isRTL() ? .right : .left
        coloredView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    private func fillData() {
        textFeild.attributedPlaceholder = NSAttributedString(string: data.placeholder, attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.64)])
        textFeild.text = data.value
        textFeild.isSecureTextEntry = data.isSecure
        textFeild.keyboardType = data.keyboardType
        textFeild.isEnabled = data.isEnabled
        if let textContentType = data.textContentType {
            textFeild.textContentType = textContentType
        }
        textFeild.autocorrectionType = .yes
        textFeild.textColor = (data.isEnabled) ? UIColor.white : UIColor.white.withAlphaComponent(0.3)
        iconImageView.image = UIImage(named: data.iconName)
        updateStatusStyle(status: (textFeild.isEditing ? .active : .none))
    }
    
    func updateValidationStatus() {
        updateStatusStyle(status: data.isValid() ? .valid : .error)
    }
    
    private func updateStatusStyle(status: MembershipFormTextFieldCellVM.Status) {
        
        data.validationStatus = status
        
        let separatorStatus = (status == .error) ? MembershipFormTextFieldCellVM.Status.error : (textFeild.isEditing ? MembershipFormTextFieldCellVM.Status.active : MembershipFormTextFieldCellVM.Status.none)
        
        separatorView.status = separatorStatus
        updateTextFieldButtonStyle(status: status)
    }
    
    private func updateTextFieldButtonStyle(status: MembershipFormTextFieldCellVM.Status) {
        
        textFeild.tintColor = (status == .error) ? UIColor.orangePink : UIColor.brightLilac
        textFieldButton.status = status
    }
    
}

extension MembershipTextFieldCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateStatusStyle(status: data.isValid() ? .valid : .active)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            data.value = updatedText
        }
        
        updateStatusStyle(status: data.isValid() ? .valid : .error)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        data.value = textField.text
        updateStatusStyle(status: data.isValid() ? .valid : .error)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let nextTextField = self.superview?.viewWithTag(textField.tag+1) as? UITextField {
            nextTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            delegate?.triggerSubmitButton()
        }
        return true
    }
}
