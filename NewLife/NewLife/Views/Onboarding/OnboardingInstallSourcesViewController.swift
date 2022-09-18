//
//  OnboardingInstallSourcesViewController.swift
//  Tawazon
//
//  Created by mac on 08/09/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class OnboardingInstallSourcesViewController: HandleErrorViewController {

    @IBOutlet weak var topBannerBackground: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var sloganLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var sourcesTable: UITableView!
    
    let installSources = InstallSourcesVM(service: MembershipServiceFactory.service())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
        fetchAndReload()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setNeedsStatusBarAppearanceUpdate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            self.closeButton.isHidden = false
        })
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func initialize(){
        self.view.backgroundColor = .darkBlueGreyThree
        
        topBannerBackground.image = UIImage(named: "OnboardingBackground")
        topBannerBackground.contentMode = .scaleAspectFill
        
        logoImageView.image = UIImage(named: "LogoWithName")
        
        sloganLabel.text = "launchSlogan".localized
        sloganLabel.font = .lbc(ofSize: 18)
        sloganLabel.textColor = .white
        
        closeButton.isHidden = true
        closeButton.roundCorners(corners: .allCorners, radius: 24)
        closeButton.backgroundColor = .black.withAlphaComponent(0.62)
        closeButton.setImage(UIImage(named: "Cancel"), for: .normal)
        closeButton.tintColor = .white
        
        descriptionLabel.text = "installSourceViewtitle".localized
        descriptionLabel.font = .munaBoldFont(ofSize: 22)
        descriptionLabel.textColor = .white
        
        sourcesTable.backgroundColor = .clear
        sourcesTable.separatorStyle = .none
    }
    
    private func fetchAndReload() {
        
        installSources.fetchInstallSources { [weak self] (error) in
            guard let self = self else { return }
            
            if let error = error {
                self.showErrorMessage(message: error.message ?? "generalErrorMessage".localized)
                
            } else {
                self.sourcesTable.reloadData()
            }
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        UserDefaults.appOpenedInstallSources()
        TrackerManager.shared.sendCloseInstallSource()
        dismiss(animated: true)
    }
    
}

extension OnboardingInstallSourcesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.installSources.sources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InstallSourceTableViewCell.identifier) as! InstallSourceTableViewCell
        cell.source = installSources.sources[indexPath.row]
        cell.delegate = self
        return cell
    }
}

extension OnboardingInstallSourcesViewController: InstallSourceDelegate{
    func selectInstallSource(source: InstallSourceVM) {
        UserDefaults.appOpenedInstallSources()
        installSources.setSelectedSource(source: source, completion: {error in
            if let error = error {
                self.showErrorMessage(message: error.message ?? "generalErrorMessage".localized)
            } else {
                self.dismiss(animated: true)            }
        })
    }
}
extension OnboardingInstallSourcesViewController{
    class func instantiate() -> OnboardingInstallSourcesViewController {
        let storyboard = UIStoryboard(name: "Membership", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: OnboardingInstallSourcesViewController.identifier) as! OnboardingInstallSourcesViewController
        viewController.modalPresentationStyle = .fullScreen
        return viewController
    }
}
