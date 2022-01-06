//
//  PremiumFeaturesView.swift
//  NewLife
//
//  Created by Shadi on 19/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class PremiumFeaturesView: UIView {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    let cellHeight: CGFloat = 60
    
    var features: PremiumFeaturesVM! {
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
        tableView.backgroundColor = UIColor.clear
    }
    
    private func reloadData() {
        tableHeightConstraint.constant = CGFloat(features.tableArray.count) * cellHeight
        tableView.reloadData()
    }
}

extension PremiumFeaturesView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return features.tableArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PremiumFeatureCell.identifier) as! PremiumFeatureCell
        cell.cellData = features.tableArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
}
