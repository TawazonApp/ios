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
    func removeFavoriteSessionTapped(session: LibrarySessionVM)
}

class LibrarySessionCollectionCell: UICollectionViewCell  {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var overlayView: GradientView!
    @IBOutlet weak var downloadButton: DownloadSessionButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    
    //Swipe cell
    var pan: UIPanGestureRecognizer!
    var tap: UITapGestureRecognizer!
    var removeFavoriteView: UIView!
    
    weak var delegate: LibrarySessionCollectionCellDelegate?
    
    var type: libraryType?
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
    override func layoutSubviews() {
        super.layoutSubviews()
        if enableSwipe(){
            updateFrames()
        }
        
    }
    
    private func initialize() {
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
        
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        
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
        
        // initialize pan gesture
        pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        pan.delegate = self
        
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
        if type == .downloads {
            downloadButton.setImage(#imageLiteral(resourceName: "Download.pdf"), for: .normal)
            downloadButton.tintColor = UIColor.white
            
            deleteButton.setImage(#imageLiteral(resourceName: "DeleteSession.pdf"), for: .normal)
            deleteButton.tintColor = UIColor.white
            updateDownloadButtonStatus()
        }else if type == .favorite {
            downloadButton.isHidden = true
            deleteButton.isHidden = true
            swipeInit()
        }
    }
    private func swipeInit() {
        self.addGestureRecognizer(pan)
        createRemoveFavoriteViewUI()
        tap = UITapGestureRecognizer(target: self, action: #selector(onTapDelete(_:)))
        removeFavoriteView.addGestureRecognizer(tap)
      }
    
    private func createRemoveFavoriteViewUI(){
        // image
        let removeImage = UIImageView()
        removeImage.image = UIImage(named: "removeFromFavorites")
        removeImage.translatesAutoresizingMaskIntoConstraints  = false
        removeImage.widthAnchor.constraint(equalToConstant: 28.0).isActive = true
        removeImage.heightAnchor.constraint(equalToConstant: 28.0).isActive = true
        
        // lable
        let removeFavoriteLabel = UILabel()
        removeFavoriteLabel.text = "removeFromFavorite".localized
        removeFavoriteLabel.textColor = UIColor.white
        removeFavoriteLabel.textAlignment = .center
        removeFavoriteLabel.font = UIFont.kacstPen(ofSize: 20)
        removeFavoriteLabel.numberOfLines = 0
        removeFavoriteLabel.lineBreakMode = .byWordWrapping
        
        // stackView
        let removeFavoriteStack = UIStackView()
        removeFavoriteStack.axis = NSLayoutConstraint.Axis.vertical
        removeFavoriteStack.alignment = .center
        removeFavoriteStack.backgroundColor = .clear
        
        // addToStack
        removeFavoriteStack.addArrangedSubview(removeImage)
        removeFavoriteStack.addArrangedSubview(removeFavoriteLabel)
        
        // remove favorite view
        removeFavoriteView = UIView()
        removeFavoriteView.layer.cornerRadius = 16
        removeFavoriteView.layer.masksToBounds = true
        removeFavoriteView.backgroundColor = UIColor.haiti
        removeFavoriteView.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.width/3, height: self.contentView.frame.height)
        removeFavoriteView.addSubview(removeFavoriteStack)
        removeFavoriteView.isUserInteractionEnabled = true
        removeFavoriteView.isHidden = true
        
        // stack constaints
        removeFavoriteStack.translatesAutoresizingMaskIntoConstraints  = false
        removeFavoriteStack.topAnchor.constraint(equalTo: removeFavoriteView.topAnchor, constant: 36).isActive = true
        removeFavoriteStack.bottomAnchor.constraint(equalTo: removeFavoriteView.bottomAnchor, constant: -36).isActive = true
        removeFavoriteStack.leadingAnchor.constraint(equalTo: removeFavoriteView.leadingAnchor, constant: 16).isActive = true
        removeFavoriteStack.trailingAnchor.constraint(equalTo: removeFavoriteView.trailingAnchor, constant: -16).isActive = true
        
        // add stack to view
        self.insertSubview(removeFavoriteView, belowSubview: self.contentView)
    }
    @IBAction func downloadButtonTapped(_ sender: UIButton) {
        delegate?.downloadSessionTapped(session: session)
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        delegate?.deleteSessionTapped(session: session)
    }
    
    @objc func onPan(_ pan: UIPanGestureRecognizer) {
        if pan.state == .began {
            removeFavoriteView.isHidden = false
        } else if pan.state == .changed {
            if pan.velocity(in: self).x > 0 {
                updateCellFramePosition()
            }
       } else {
             updateCellFramePosition()
       }
     }
    private func movedGreaterThanThirdWay() -> Bool{
        let hasMovedThirdWay = pan.translation(in: self).x > self.bounds.size.width/3
        return hasMovedThirdWay
    }
    private func updateCellFramePosition(){
        if movedGreaterThanThirdWay(){
                self.contentView.frame = CGRect(x: 10 + (self.contentView.frame.width / 3),y: 0, width: self.contentView.frame.width, height: self.contentView.frame.height);
        }else{
            UIView.animate(withDuration: 0.2, animations: {
              self.setNeedsLayout()
              self.layoutIfNeeded()
            })
        }
    }
    private func updateFrames(){
        let p: CGPoint = pan.translation(in: self)
        let width = self.contentView.frame.width
        let height = self.contentView.frame.height
        if (pan.state == UIGestureRecognizer.State.changed)  {
            self.contentView.frame = CGRect(x: p.x,y: 0, width: width, height: height);
            self.removeFavoriteView.frame = CGRect(x: 0, y: 0, width: width/3, height: height)
        }
    }
    private func enableSwipe() -> Bool{
        return type == .favorite && session != nil
    }
    @objc func onTapDelete(_ tap: UITapGestureRecognizer) {
        delegate?.removeFavoriteSessionTapped(session: session)
    }
    
}

extension LibrarySessionCollectionCell: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
      }

      override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return abs((pan.velocity(in: pan.view)).x) > abs((pan.velocity(in: pan.view)).y)
      }
}
