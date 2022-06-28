//
//  SearchViewController.swift
//  Tawazon
//
//  Created by mac on 13/06/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit
import Alamofire

class SearchViewController: BaseViewController {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var dividerImage: UIImageView!
    @IBOutlet weak var sessionsTableView: UITableView!
    
    @IBOutlet weak var mostListenedView: UIView!
    
    var data: SearchVM? {
        didSet {
            print("SearchVM")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
        
        data = SearchVM(service: SessionServiceFactory.service())
        performSearch()
    }
    

    func initialize(){
        view.backgroundColor = UIColor.cyprus
        
        mostListenedView.backgroundColor = .clear
        
        closeButton.setTitle("close".localized, for: .normal)
        closeButton.titleLabel?.font = .lbc(ofSize: 15.0)
        closeButton.tintColor = .white
        
        searchBar.backgroundColor = .black.withAlphaComponent(0.32)
        searchBar.layer.cornerRadius = 24
        
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

    private func performSearch(query: String? = "") {
        data?.getSearchData(query: query){
            (error) in
            if error != nil{
                print("getSearchDataError: \(error)")
            }
            print("data.sections: \(self.data?.sections?.first?.title)")
            print("data.categories: \(self.data?.categories?.count)")
            self.sessionsTableView.reloadData()
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource{
    
    private func categoriesDataAvailable()-> Bool{
        if data?.categories?.count ?? 0 > 0 {
            return true
        }else {
            return false
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if categoriesDataAvailable() {
            return data?.categories?.count ?? 0
        }else {
            return data?.sections?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if categoriesDataAvailable() {
            return data?.categories?[section].sessions.count ?? 0
        }else {
            return data?.sections?[section].sessions.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier) as! SearchTableViewCell
        if categoriesDataAvailable() {
            cell.session = self.data?.categories?[indexPath.section].sessions[indexPath.row]
        }else{
            cell.session = self.data?.sections?[indexPath.section].sessions[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var session: HomeSessionVM?
        if categoriesDataAvailable() {
            session = self.data?.categories?[indexPath.section].sessions[indexPath.row]
        }else{
            session = self.data?.sections?[indexPath.section].sessions[indexPath.row]
        }
        if session != nil {
            playSession(session!)
        }
        
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
        headerIcon.image = nil
        
        if !categoriesDataAvailable() {
            if let imageUrl = self.data?.sections?[section].imageUrl?.url {
                headerIcon.af.setImage(withURL: imageUrl)
            }
        }
        
        
        let headerTitle = UILabel()
        headerTitle.font = .kacstPen(ofSize: 16.0)
        headerTitle.textColor = .white
        if categoriesDataAvailable() {
            headerTitle.text = self.data?.categories?[section].name
        }else{
            headerTitle.text = self.data?.sections?[section].title
        }
        
        
        headerItemsStack.addArrangedSubview(headerIcon)
        headerItemsStack.addArrangedSubview(headerTitle)
        
        headerView.addSubview(headerItemsStack)
        headerItemsStack.translatesAutoresizingMaskIntoConstraints = false
        headerItemsStack.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20).isActive = true
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24.0
    }
    
    private func playSession(_ session: HomeSessionVM) {
        guard let sessionModel = session.session else { return }
        let viewcontroller = SessionPlayerViewController.instantiate(session: SessionVM(service: SessionServiceFactory.service(), session: sessionModel), delegate: self)
        viewcontroller.modalPresentationStyle = .custom
        viewcontroller.transitioningDelegate = self
        self.present(viewcontroller, animated: true, completion: nil)
    }
}
extension SearchViewController: SessionPlayerDelegate {
    func sessionStoped(_ session: SessionVM) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
            SessionRateViewController.show(session: session, from: self, force: false)
        }
    }
}
extension SearchViewController:  UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        performSearch(query: searchBar.text)
        self.searchBar.resignFirstResponder()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "searchCancelButton".localized
        self.searchBar.showsCancelButton = true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
        searchBar.text = ""
        self.searchBar.resignFirstResponder()
    }
}
extension SearchViewController{
    class func instantiate() -> SearchViewController {
        let storyboard = UIStoryboard(name: "Categories", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: SearchViewController.identifier) as! SearchViewController
        return viewController
    }
}
