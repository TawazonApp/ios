//
//  ForgetPasswordFormView.swift
//  NewLife
//
//  Created by Shadi on 12/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

protocol ForgetPasswordFormViewDelegate: class {
    func showErrorMessageView(title: String?, message: String)
    func forgetPasswordSent(email: String)
    func resetPasswordSucceeded()
}

class ForgetPasswordFormView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    
    weak var delegate: ForgetPasswordFormViewDelegate?
    
    let cellHeight: CGFloat = (UIScreen.main.bounds.height <= 568.0) ? 50 : 60

    var data: ForgetPasswordVM! {
        didSet {
            reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize() {
        backgroundColor = UIColor.clear
        
        titleLabel.font = UIFont.kacstPen(ofSize: 22)
        titleLabel.textColor = UIColor.white
    
        subTitleLabel.font = UIFont.kacstPen(ofSize: 14)
        subTitleLabel.textColor = UIColor.white
        
        tableView.backgroundColor = UIColor.clear
        tableView.layer.cornerRadius = 18
        tableView.layer.masksToBounds = true
        
    }
    
    private func reloadData() {
        titleLabel.text = data.title
        subTitleLabel.text = data.subTitle
        tableView.reloadData()
        updateLayout()
        
    }
    
    private func sumbitButtonTapped() {
        
        self.endEditing(true)
        
        for cell in tableView.visibleCells {
            if let textfieldCell = cell as? MembershipTextFieldCell {
                textfieldCell.updateValidationStatus()
            }
        }
        
        LoadingHud.shared.show(animated: true)
        data.submit { [weak self] (email, error) in
            LoadingHud.shared.hide(animated: true)
            if let error = error {
                self?.delegate?.showErrorMessageView(title: nil, message: error.message ?? "generalErrorMessage".localized)
            } else {
                if self?.data is ForgetPasswordFormVM {
                    self?.delegate?.forgetPasswordSent(email: email ?? "")
                } else {
                    self?.delegate?.resetPasswordSucceeded()
                }
               
            }
        }
    }
    
    private func updateLayout() {
        let tableHeight = CGFloat(data.items.count) * cellHeight
        tableHeightConstraint.constant = tableHeight
        self.layoutIfNeeded()
        
    }
    
}

extension ForgetPasswordFormView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        if let cellData = data.items[indexPath.row] as? MembershipFormTextFieldCellVM {
            let textFieldCell = tableView.dequeueReusableCell(withIdentifier: MembershipTextFieldCell.identifier) as! MembershipTextFieldCell
            textFieldCell.data = cellData
            textFieldCell.textFeild.tag = indexPath.row
            textFieldCell.delegate = self
            cell = textFieldCell
            
        } else if let cellData = data.items[indexPath.row] as? MembershipFormButtonCellVM {
            let buttonCell = tableView.dequeueReusableCell(withIdentifier: MembershipButtonCell.identifier) as! MembershipButtonCell
            buttonCell.data = cellData
            cell = buttonCell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if data.items[indexPath.row] is MembershipFormButtonCellVM {
            sumbitButtonTapped()
        }
    }
}

extension ForgetPasswordFormView: MembershipTextFieldCellDelegate {
    
    func triggerSubmitButton() {
        sumbitButtonTapped()
    }
}
