//
//  LibrarySessionCollectionCell.swift
//  NewLife
//
//  Created by Shadi on 05/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

protocol LibrarySessionCollectionCellDelegate: class {
    func downloadSessionTapped(session: LibrarySessionVM)
    func deleteSessionTapped(session: LibrarySessionVM)
}

class LibrarySessionCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var overlayView: GradientView!
    @IBOutlet weak var downloadButton: DownloadSessionButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    weak var delegate: LibrarySessionCollectionCellDelegate?
    
    var session: LibrarySessionVM! {
        didSet {
            fillData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func updateDownloadButtonStatus() {
        downloadButton.downloadStatus = session.downloadStatus
        deleteButton.isHidden = (session.downloadStatus != .downloaded)
    }
    
    private func initialize() {
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
        
        imageView.contentMode = .scaleAspectFill
        
        downloadButton.setImage(#imageLiteral(resourceName: "Download.pdf"), for: .normal)
        downloadButton.tintColor = UIColor.white
        
        deleteButton.setImage(#imageLiteral(resourceName: "DeleteSession.pdf"), for: .normal)
        deleteButton.tintColor = UIColor.white
        
        nameLabel.font = UIFont.lbcBold(ofSize: 16, language: .arabic)
        nameLabel.textColor = UIColor.white
        
        durationLabel.font = UIFont.lbc(ofSize: 14)
        durationLabel.textColor = UIColor.white
        overlayView.applyGradientColor(colors: [UIColor.black.withAlphaComponent(0.0).cgColor, UIColor.black.withAlphaComponent(0.56).cgColor], startPoint: GradientPoint.top, endPoint: GradientPoint.bottom)
    }
    
    private func fillData() {
        
        imageView.image = nil
        if let localiImageUrl = session.localImageUrl {
            imageView.image = UIImage(contentsOfFile: localiImageUrl.path)
        } else if let imageUrl = session.imageUrl {
            imageView.af.setImage(withURL: imageUrl)
        }
        
        nameLabel.text = session.name
        durationLabel.text = session.durationString
        updateDownloadButtonStatus()
    }
    
    @IBAction func downloadButtonTapped(_ sender: UIButton) {
        delegate?.downloadSessionTapped(session: session)
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        delegate?.deleteSessionTapped(session: session)
    }
}
