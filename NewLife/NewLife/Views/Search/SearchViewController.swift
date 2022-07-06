//
//  SearchViewController.swift
//  Tawazon
//
//  Created by mac on 13/06/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit
import Alamofire
import CoreAudio

class SearchViewController: BaseViewController {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var dividerImage: UIImageView!
    @IBOutlet weak var sessionsTableView: UITableView!
    @IBOutlet weak var categoriesCollection: UICollectionView!
    @IBOutlet weak var noResultView: UIView!
    @IBOutlet weak var noResultImage: UIImageView!
    @IBOutlet weak var noResultLabel: UILabel!
    @IBOutlet weak var searchResultStack: UIStackView!
    @IBOutlet weak var mostListenedView: UIView!
    
    var data: SearchVM? {
        didSet {
            
        }
    }

    var categories = [SearchCategoryVM]()
    var selectedCategoryIndex: Int = 0 {
        didSet {
            updateCategorySelectStyle(index: oldValue, isSelected: false)
            updateCategorySelectStyle(index: selectedCategoryIndex, isSelected: true)
        }
    }
    var tableSessions: [HomeSessionVM]?
    var timer: Timer? = nil
    let searchDebouncer = Debouncer()
    let eventDebouncer = Debouncer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
        data = SearchVM(service: SessionServiceFactory.service())
        performSearch()
        sendOpenSearchEvent()
    }
    

    private func sendOpenSearchEvent(){
        TrackerManager.shared.sendOpenSearchEvent()
    }
    
    private func sendSearchFor(query: String){
        TrackerManager.shared.sendSearchFor(query: query)
    }
    
    private func sendTapPlaySessionFromSearchResultEvent(id: String, name: String){
        TrackerManager.shared.sendTapPlaySessionFromSearchResultEvent(id: id, name: name)
    }
    func initialize(){
        view.backgroundColor = UIColor.cyprus
        let tapOnScreen: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:  #selector(viewTapped(_:)))
        tapOnScreen.cancelsTouchesInView = false
        view.addGestureRecognizer(tapOnScreen)
        
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
        
        searchResultStack.backgroundColor = .clear
        searchResultStack.removeArrangedSubview(noResultView)
        searchResultStack.removeArrangedSubview(categoriesCollection)
        
        categoriesCollection.backgroundColor = .clear
        categoriesCollection.isHidden = true
        categoriesCollection.collectionViewLayout = ArabicCollectionFlow()
        if let layout = categoriesCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        noResultView.isHidden = true
        noResultView.backgroundColor = .clear
        
        noResultImage.image = UIImage(named: "NoResults")
        
        noResultLabel.text = "searchNoResultMessage".localized
        noResultLabel.font = UIFont.munaFont(ofSize: 18.0)
        noResultLabel.numberOfLines = 0
        noResultLabel.textColor = .white
        noResultLabel.adjustsFontSizeToFitWidth = true
        noResultLabel.minimumScaleFactor = 0.5
        
        dividerImage.image = UIImage(named: "SearchDivider")
        
        sessionsTableView.backgroundColor = .clear
        sessionsTableView.delegate = self
        sessionsTableView.dataSource = self
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func performSearch(query: String? = "") {
        data?.getSearchData(query: query){
            (error) in
            if error != nil{
                print("getSearchDataError: \(String(describing: error))")
            }
            self.categories = self.data?.categories ?? []
            self.selectedCategoryIndex = 0
            self.tableSessions = self.data?.categories?.count ?? 0 > 0 ? self.data?.categories?[0].sessions : self.data?.sections?.first?.sessions
            
            if self.data?.message != nil{
                self.noResultLabel.text = self.data?.message
            }
            let isNoResult = (!self.categoriesDataAvailable()) && !(self.searchBar.text?.isEmpty ?? true)
            self.updateViewAppereance(noResult: isNoResult)
            self.sessionsTableView.reloadData()
            self.collectionReloadData()
        }
    }
    
    private func collectionReloadData() {
        categoriesCollection.reloadData()
    }
    
    private func updateViewAppereance(noResult: Bool){
        if noResult {
            print("show no result message")
            searchResultStack.insertArrangedSubview(noResultView, at: 0)
            searchResultStack.removeArrangedSubview(categoriesCollection)
        }else{
            print("result message")
            searchResultStack.removeArrangedSubview(noResultView)
            searchResultStack.insertArrangedSubview(categoriesCollection, at: 0)
        }
        
        noResultView.isHidden = !noResult
        categoriesCollection.isHidden = noResult
    }
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
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
        if categoriesDataAvailable() && selectedCategoryIndex == 0 {
            return self.data?.categories?.count ?? 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if categoriesDataAvailable() && selectedCategoryIndex == 0 {
            return data?.categories?[section].sessions.count ?? 0
        }
        return self.tableSessions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier) as! SearchTableViewCell
        if categoriesDataAvailable() && selectedCategoryIndex == 0 {
            cell.session = self.data?.categories?[indexPath.section].sessions[indexPath.row]
        }else{
            cell.session = self.tableSessions?[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var session: HomeSessionVM?
        if categoriesDataAvailable() && selectedCategoryIndex == 0 {
            session = self.data?.categories?[indexPath.section].sessions[indexPath.row]
        }else{
            session = self.tableSessions?[indexPath.row]
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
       
        if categoriesDataAvailable()  && selectedCategoryIndex == 0{
            headerTitle.text = "\(self.data?.categories?[section].name ?? "") (\(self.data?.categories?[section].sessions.count ?? 0))"
        }else if categoriesDataAvailable(){
            headerTitle.text = "\(self.data?.categories?[selectedCategoryIndex - 1].name ?? "") (\(self.data?.categories?[selectedCategoryIndex - 1].sessions.count ?? 0))"
        } else{
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
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.sessionsTableView.frame.width, height: 1))
        
        if categoriesDataAvailable() {
            
            let separator = GradientView(frame: footerView.frame)
            if Language.language == .arabic {
                separator.applyGradientColor(colors: [UIColor.lightSlateBlue.cgColor, UIColor.lynch.cgColor, UIColor.sanJuan.withAlphaComponent(0).cgColor], startPoint: .right, endPoint: .left)
            }else{
                separator.applyGradientColor(colors: [UIColor.lightSlateBlue.cgColor, UIColor.lynch.cgColor, UIColor.sanJuan.withAlphaComponent(0).cgColor], startPoint: .left, endPoint: .right)
            }
            
            footerView.addSubview(separator)
            
            separator.translatesAutoresizingMaskIntoConstraints = false
            separator.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 20).isActive = true
            separator.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 0).isActive = true
            separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
            separator.widthAnchor.constraint(equalToConstant: footerView.frame.width - 40).isActive = true
        }
        return footerView
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    private func playSession(_ session: HomeSessionVM) {
        guard let sessionModel = session.session else { return }
        let viewcontroller = DetailedSessionPlayerViewController.instantiate(session: SessionVM(service: SessionServiceFactory.service(), session: sessionModel), delegate: self)
        viewcontroller.modalPresentationStyle = .custom
        viewcontroller.transitioningDelegate = self
        sendTapPlaySessionFromSearchResultEvent(id: sessionModel.id, name: sessionModel.name)
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchDebouncer.debounce(seconds: 0.35){
            self.performSearch(query: searchText)
        }
        
        eventDebouncer.debounce(seconds: 1){
            self.sendSearchFor(query: searchText)
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.searchBar.resignFirstResponder()
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count > 0 ? categories.count + 1 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCategoryCollectionViewCell.identifier, for: indexPath) as! SearchCategoryCollectionViewCell
        
        cell.isAll = false
        if indexPath.item == 0{
            cell.isAll = true
        }else{
            cell.category = categories[indexPath.item - 1]
        }
        cell.setSelected = (indexPath.item == selectedCategoryIndex)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height: CGFloat = 32
        if indexPath.item == 0 {
            let width = "allSearchCategoryLabel".localized.width(withConstrainedHeight: height, font: UIFont.kacstPen(ofSize: 18)) + 20
            return CGSize(width: width, height: height)
        }
        let category = categories[indexPath.item - 1]
        
        let width = category.name.width(withConstrainedHeight: height, font: UIFont.kacstPen(ofSize: 18)) + 20
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if selectedCategoryIndex != indexPath.item {
            selectedCategoryIndex = indexPath.item
            if selectedCategoryIndex != 0 {
                self.tableSessions = self.data?.categories?[indexPath.item - 1].sessions
            }
            
            centerItemIfNeeded(indexPath: indexPath)
            sessionsTableView.reloadData()
        }
       
    }
    
    private func centerItemIfNeeded(indexPath: IndexPath) {
        if categoriesCollection.contentSize.width > categoriesCollection.frame.width {
            categoriesCollection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    private func updateCategorySelectStyle(index: Int, isSelected: Bool) {
        guard let cell = categoriesCollection.cellForItem(at: IndexPath(item: index, section: 0)) as? SearchCategoryCollectionViewCell else {
            return
        }
        cell.setSelected = isSelected
    }
    
}


extension SearchViewController{
    class func instantiate() -> SearchViewController {
        let storyboard = UIStoryboard(name: "Categories", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: SearchViewController.identifier) as! SearchViewController
        return viewController
    }
}



class Debouncer{
    var timer : Timer? = nil
    
    func debounce(seconds: TimeInterval, function: @escaping () -> Swift.Void ) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: seconds, repeats: false, block: { _ in
            function()
        })
    }
}
