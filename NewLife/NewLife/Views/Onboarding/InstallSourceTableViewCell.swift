//
//  InstallSourceTableViewCell.swift
//  Tawazon
//
//  Created by mac on 08/09/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

protocol InstallSourceDelegate: class {
    func selectInstallSource(source: InstallSourceVM)
}
class InstallSourceTableViewCell: UITableViewCell {

    @IBOutlet weak var installSourceButton: UIButton!
    var delegate : InstallSourceDelegate?
    var source : InstallSourceVM?{
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
        installSourceButton.backgroundColor = .white
//        installSourceButton.roundCorners(corners: .allCorners, radius: 18)
        installSourceButton.layer.cornerRadius = 18
        installSourceButton.tintColor = .black
        installSourceButton.titleLabel?.font = .munaFont(ofSize: 20)
    }
    
    func fillData(){
        installSourceButton.setTitle(source?.name, for: .normal)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func installSourceButtonTapped(_ sender: Any) {
        guard let source = source else{
            return
        }
        delegate?.selectInstallSource(source: source)
    }
}
