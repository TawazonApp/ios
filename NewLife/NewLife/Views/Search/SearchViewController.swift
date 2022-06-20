//
//  SearchViewController.swift
//  Tawazon
//
//  Created by mac on 13/06/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class SearchViewController: BaseViewController {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var dividerImage: UIImageView!
    @IBOutlet weak var sessionsTableView: UITableView!
    
    @IBOutlet weak var mostListenedView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }
    

    func initialize(){
        view.backgroundColor = UIColor.cyprus
        
        mostListenedView.backgroundColor = .clear
        
        closeButton.setTitle("close".localized, for: .normal)
        closeButton.titleLabel?.font = .lbc(ofSize: 15.0)
        closeButton.tintColor = .white
        
        searchBar.backgroundColor = .black.withAlphaComponent(0.32)
        searchBar.roundCorners(corners: .allCorners, radius: 24.0)
        searchBar.isTranslucent = false
        searchBar.setImage(UIImage(named: ""), for: .search, state: .normal)
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.textColor = .white
            searchBar.searchTextField.placeholder = "searchPlaceholder".localized
            searchBar.searchTextField.borderStyle = .none
            searchBar.searchTextField.backgroundColor = .clear
            searchBar.searchTextField.font = .kacstPen(ofSize: 16.0)
            searchBar.searchTextField.leftView = UIImageView(image: UIImage(named: "Search"))
        } else {
            // Fallback on earlier versions
        }
        
        dividerImage.image = UIImage(named: "SearchDivider")
        
        sessionsTableView.backgroundColor = .clear
        sessionsTableView.delegate = self
        sessionsTableView.dataSource = self
    }

    @IBAction func closeButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier) as! SearchTableViewCell
        cell.durationLabel.text = "3:50 دقيقة"
        cell.iconImage.image = UIImage(named: "CalmnessWater")
        cell.titleLabel.text = "المكان الآمن في داخلنا"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 122.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.sessionsTableView.frame.width, height: 24))
        
        let headerItemsStack = UIStackView(frame: headerView.frame)
        headerItemsStack.axis = .horizontal
        headerItemsStack.distribution = .fillProportionally
        headerItemsStack.alignment = .center
        headerItemsStack.spacing = 4.0
        headerItemsStack.backgroundColor = .clear
        
        let headerIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        headerIcon.widthAnchor.constraint(equalToConstant: 24).isActive = true
        headerIcon.heightAnchor.constraint(equalToConstant: 24).isActive = true
        headerIcon.backgroundColor = .clear
        headerIcon.image = UIImage(named: "MostListened")
        
        let headerTitle = UILabel()
        headerTitle.font = .kacstPen(ofSize: 16.0)
        headerTitle.textColor = .white
        headerTitle.text = "الأكثر استماعاً على توازن"
        
        headerItemsStack.addArrangedSubview(headerIcon)
        headerItemsStack.addArrangedSubview(headerTitle)
        
        headerView.addSubview(headerItemsStack)
        
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24.0
    }
}
extension SearchViewController{
    class func instantiate() -> SearchViewController {
        let storyboard = UIStoryboard(name: "Categories", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: SearchViewController.identifier) as! SearchViewController
        return viewController
    }
}
