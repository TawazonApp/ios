//
//  CategorySectionsViewController.swift
//  Tawazon
//
//  Created by mac on 21/02/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit
protocol CategorySectionsViewDelegate: class{
    func updateHeader(offset: CGPoint)
    func openSectionView(_ section: HomeSectionVM)
    func playSession(_ session: HomeSessionVM)
    func openSeriesView(seriesId: String)
}
class CategorySectionsView: UIView {
    @IBOutlet weak var sectionsTableView: UITableView!
    var sections: [HomeSectionVM]!{
        didSet{
            fillData()
        }
    }
    weak var delegate: CategorySectionsViewDelegate?
    func fillData() {
        sectionsTableView.delegate = self
        sectionsTableView.dataSource = self
        sectionsTableView.reloadData()
    }

}
extension CategorySectionsView : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        let section = sections?[indexPath.row]
        if section?.style == .card {
                let sectionCell = tableView.dequeueReusableCell(withIdentifier: HomeTableCardSectionCell.identifier) as! HomeTableCardSectionCell
                sectionCell.delegate = self
                sectionCell.data = section
                cell = sectionCell
            } else {
                let sectionCell = tableView.dequeueReusableCell(withIdentifier: HomeTableHorizontalSectionCell.identifier) as! HomeTableHorizontalSectionCell
                sectionCell.delegate = self
                           sectionCell.data = section
                           cell = sectionCell
            }

        cell.layer.masksToBounds = false
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.updateHeader(offset: scrollView.contentOffset)
    }
    
}
extension CategorySectionsView: HomeTableCardSectionCellDelegate, HomeTableHorizontalSectionCellDelegate{
    func openSeriesView(seriesId: String) {
        delegate?.openSeriesView(seriesId: seriesId)
    }
    
    
    func sectionTapped(_ sender: HomeTableCardSectionCell, section: HomeSectionVM?) {
        guard let section = section else {
            return
        }
        delegate?.openSectionView(section)
    }
    
    func playSession(_ sender: HomeTableHorizontalSectionCell, session: HomeSessionVM) {
        delegate?.playSession(session)
    }
    
    func sectionTapped(_ sender: HomeTableHorizontalSectionCell, section: HomeSectionVM?) {
        guard let section = section else {
            return
        }
        delegate?.openSectionView(section)
    }
    
}
