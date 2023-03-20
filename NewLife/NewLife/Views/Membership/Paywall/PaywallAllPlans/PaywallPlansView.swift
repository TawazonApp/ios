//
//  PaywallPlansView.swift
//  Tawazon
//
//  Created by mac on 11/12/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class PaywallPlansView: UIView {
    
    @IBOutlet weak var plansTableView: UITableView!
    
    
    var plans: [PremiumPurchaseCellVM]? {
        didSet {
            if let plansCount = plans?.count, plansCount > 0{
                plans!.sort(by: { $0.priority < $1.priority })
                reloadData()
            }
        }
    }
    
    var selectedPlan: Int = NSNotFound
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize(){
        self.backgroundColor = .clear
        
        plansTableView.backgroundColor = .clear
        plansTableView.separatorStyle = .none
        plansTableView.isScrollEnabled = false
    }
    private func setData() {
//        mostPopularLabel.font = UIFont.munaBoldFont(ofSize: 13.0)
//        mostPopularLabel.textColor = UIColor.lightSlateBlue
//        mostPopularLabel.text = "premium4mostPopularLabel".localized
    }
    
    private func reloadData() {
        selectedPlan = 0
        plans?[selectedPlan].isSelected = true
        plansTableView.reloadData()
        plansTableView.selectRow(at: IndexPath(row: selectedPlan, section: 0), animated: false, scrollPosition: .none)
//        setData()
//        plansCollectionView.reloadData()
//        plansCollectionView.selectItem(at: IndexPath(row: 1, section: 0), animated: false, scrollPosition: .centeredHorizontally)
        
    }
}
extension PaywallPlansView: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        plans?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PaywallPlanTableViewCell.identifier) as! PaywallPlanTableViewCell
        cell.plan = plans?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as! PaywallPlanTableViewCell
        
        if selectedPlan >= 0 && selectedPlan < tableView.numberOfRows(inSection: 0) {
            let oldSelectedCell = tableView.cellForRow(at: IndexPath(item: selectedPlan, section: 0)) as! PaywallPlanTableViewCell
            oldSelectedCell.setIsSelected(selected: false)
        }
        selectedPlan = indexPath.item
        selectedCell.setIsSelected(selected: true)
        
    }
}
