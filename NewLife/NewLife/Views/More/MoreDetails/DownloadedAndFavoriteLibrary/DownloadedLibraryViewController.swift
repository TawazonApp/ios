//
//  DownloadedLibraryViewController.swift
//  NewLife
//
//  Created by Shadi on 05/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class DownloadedLibraryViewController: MoreDetailsViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var data: DownloadedLibraryVM!
    var type : libraryType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        initializeNotificationCenter()
        data = DownloadedLibraryVM(service: SessionServiceFactory.service())
        fetchData()
        sendOpenDownloadedLibraryEvent()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
   
    private func initialize() {
        if type == .downloads {
            backgroundImageName = "DownloadedLibraryBackground"
            title = "downloadedLibraryViewTitle".localized
        }else if type == .favorite{
            backgroundImageName = "FavoritesLibraryBackground"
            title = "favoriteLibraryViewTitle".localized
        }
        
    }
    
    private func initializeNotificationCenter() {
        NotificationCenter.default.addObserver(self,  selector: #selector(downloadSessionsProgressChanged(_:)),  name: Notification.Name.downloadSessionsProgressChanged, object: nil)
    }
    
    @objc private func downloadSessionsProgressChanged(_ notification: Notification) {
        reloadCollectionData()
    }
    
    private func fetchData() {
        
        data.fetchData(type: type!) { [weak self] (error) in
            if let error = error {
                self?.showErrorMessage( message: error.message ?? "generalErrorMessage".localized)
            }
            self?.reloadCollectionData()
        }
    }
    
    private func reloadCollectionData() {
        collectionView.reloadData()
    }
    
    private func performDeleteSession(session: LibrarySessionVM) {
        session.deleteSession { [weak self] (error) in
            if let error = error {
                self?.showErrorMessage(message: error.message ?? "generalErrorMessage".localized)
            } else {
                self?.fetchData()
            }
        }
    }
    
    private func showDeleteSessionConfirmationAlert(session: LibrarySessionVM) {
        
        let message = "deleteSessionConfirmAlertMessage".localized.replacingOccurrences(of: "{name}", with: session.name ?? "")
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet, blurStyle: .dark)
        
        alert.addAction(title: "deleteSessionConfirmAlertLogoutButton".localized, style: .destructive) { [weak self] (alert) in
            self?.performDeleteSession(session: session)
        }
        
        alert.addAction(title: "deleteSessionConfirmAlertCancelButton".localized, style: .cancel, handler: nil)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func openSessionPlayerViewController(session: LibrarySessionVM) {
        guard let session = session.session else { return }
        let viewcontroller = DetailedSessionPlayerViewController.instantiate(session: SessionVM(service: SessionServiceFactory.service(), session: session), delegate: self)
        viewcontroller.modalPresentationStyle = .custom
        viewcontroller.transitioningDelegate = self
        self.present(viewcontroller, animated: true, completion: nil)
    }
    
    private func sendOpenDownloadedLibraryEvent() {
        TrackerManager.shared.sendOpenDownloadedLibraryEvent()
    }
}

extension DownloadedLibraryViewController: LibrarySessionCollectionCellDelegate {
    
    func downloadSessionTapped(session: LibrarySessionVM) {
        session.download()
    }
    
    func deleteSessionTapped(session: LibrarySessionVM) {
        showDeleteSessionConfirmationAlert(session: session)
    }
    func removeFavoriteSessionTapped(session: LibrarySessionVM) {
        if session.isFavorite{
            session.removeFromFavorites { [weak self] (error) in
                self?.fetchData()
            }
        }
    }
}

extension DownloadedLibraryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.sessions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LibrarySessionCollectionCell.identifier, for: indexPath) as! LibrarySessionCollectionCell
        cell.type = type
        cell.session = data.sessions[indexPath.item]
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - (2*20), height: 164)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let session = data.sessions[indexPath.item]
        
        DispatchQueue.main.async { [weak self] in
            self?.openSessionPlayerViewController(session:  session)
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if  indexPath.item >= (data.sessions.count - 4) {
            
            data.fetchMore(type: type!, completion:  { [weak self] (error) in
                if error == nil {
                    self?.reloadCollectionData()
                }
            })
        }
    }
}


extension DownloadedLibraryViewController {
    
    class func instantiate(type: libraryType) -> DownloadedLibraryViewController {
        let storyboard = UIStoryboard(name: "More", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: DownloadedLibraryViewController.identifier) as! DownloadedLibraryViewController
        viewController.type = type
        return viewController
    }
}

extension DownloadedLibraryViewController: SessionPlayerDelegate {
    func sessionStoped(_ session: SessionVM) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
            SessionRateViewController.show(session: session, from: self, force: false)
        }
    }
}

