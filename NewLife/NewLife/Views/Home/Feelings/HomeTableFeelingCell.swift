//
//  HomeTableFeelingCell.swift
//  Tawazon
//
//  Created by Shadi on 15/11/2020.
//  Copyright © 2020 Inceptiontech. All rights reserved.
//

import UIKit

protocol HomeTableFeelingCellDelegate: class {
    func playSession(_ sender: HomeTableFeelingCell, session: HomeSessionVM)
    
    func showErrorMessage(_ sender: HomeTableFeelingCell, message: String)
}

class HomeTableFeelingCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var feelingSelectionView: HomeFeelingSelectionView! {
        didSet {
            feelingSelectionView.delegate = self
        }
    }
    @IBOutlet weak var feelingSessionsView: FeelingSessionsView! {
        didSet {
            feelingSessionsView.delegate = self
        }
    }
    weak var tableView: UITableView?
    weak var delegate: HomeTableFeelingCellDelegate?
    
    private lazy var viewModel = HomeTableFeelingCellVM(homeService: HomeServiceCache.shared)

    
    private var collectionCellSpace: CGFloat = 16
    private var collectionCellWidth: CGFloat = 10
    private var collectionCellHeight: CGFloat = 10
    private var timer: Timer?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] timer in
            self?.setTitle()
        }
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
    
    private func initialize() {
        titleLabel.textColor = UIColor.white
        setTitle()
        feelingSessionsView.isHidden = true
        feelingSelectionView.isHidden = true
        updateHeight()
        titleLabel.isHidden = true
    }
    
     func fetchAndReloadData() {
        viewModel.getFeelings { [weak self] (error) in
            guard let self = self else { return }
            if let error = error {
                self.delegate?.showErrorMessage(self, message: error.localizedDescription)
                return
            }
            let feelingSelected = self.viewModel.feelingSelected
            if feelingSelected {
                self.fetchAndReloadSessions()
            } else {
                self.reloadData()
            }
        }
    }
    
    private func setTitle() {
        let dayTime = viewModel.dayTime
        feelingSelectionView.dayTime = dayTime
        let title = dayTime.title
        let userName = viewModel.userName
        let text = "\(title) \(userName)"
        let boldFont = UIFont.lbcBold(ofSize: 17)
        let attributedString = NSMutableAttributedString(string: text, attributes: [.font : UIFont.lbc(ofSize: 17)])
        if !userName.isEmpty {
            let range = NSString(string: text).range(of: userName)
            attributedString.addAttributes([.font : boldFont], range: range)
        }
        titleLabel.attributedText = attributedString
    }
    
    private func updateHeight() {
        let feelingSelected = viewModel.feelingSelected
        let height = feelingSelected ? calculateCollectionHeight() : 156
        tableView?.beginUpdates()
        contentHeightConstraint.constant = height
        tableView?.endUpdates()
    }
    
    private func reloadData() {
        setTitle()
        let feelingSelected = viewModel.feelingSelected
        updateHeight()
        let feelingSessionsViewIsHidden = !feelingSelected
        if feelingSessionsViewIsHidden {
            feelingSessionsView.isHidden = feelingSessionsViewIsHidden
        }
        feelingSelectionView.isHidden = feelingSelected
        feelingSelectionView.dayTime = viewModel.dayTime
        feelingSelectionView.feelings = viewModel.feelings
        self.reloadCollectionView()
        
    }
    
    private func reloadCollectionView() {
        feelingSessionsView.sessionsSection = viewModel.sessionsSection
    }
    
    private func fetchAndReloadSessions() {
        viewModel.getFeelingSessions { [weak self] (error) in
            if let error = error {
                //FIXNe show error if need
                return
            }
            self?.reloadData()
        }
    }
    
    private func calculateCollectionHeight() -> CGFloat {
        let availableWidth = frame.width - (2 * collectionCellSpace)
        collectionCellWidth = availableWidth / 1.1
        collectionCellHeight = collectionCellWidth / 1.2
        return collectionCellHeight + 20 + 40 + 16
    }
    
    private func resetFeelings() {
        viewModel.unselectFeelings()
        viewModel.sessionsSection = nil
        self.reloadData()
        viewModel.updateFeelings(feelingIds: []) { (_) in
        }
    }
}

extension HomeTableFeelingCell: HomeFeelingSelectionViewDelegate {
    func feelingDidChange(_ sender: HomeFeelingSelectionView, feelings: [FeelCellModel]) {
        let feelingIds = feelings.map({ $0.id })
        viewModel.updateFeelings(feelingIds: feelingIds) { [weak self] (error) in
            guard let self = self else { return }
            if let error = error {
                self.delegate?.showErrorMessage(self, message: error.localizedDescription)
            }
            self.fetchAndReloadSessions()
        }
    }
}

extension HomeTableFeelingCell: FeelingSessionsViewDelegate {
    
    func playSession(_ sender: FeelingSessionsView, session: HomeSessionVM) {
        delegate?.playSession(self, session: session)
    }
    
    func changeFeelingTapped(_ sender: FeelingSessionsView) {
        resetFeelings()
    }
}
