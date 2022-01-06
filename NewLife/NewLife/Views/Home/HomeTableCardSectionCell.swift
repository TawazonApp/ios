//
//  HomeTableCardSectionCell.swift
//  Tawazon
//
//  Created by Shadi on 14/11/2020.
//  Copyright © 2020 Inceptiontech. All rights reserved.
//

import UIKit

protocol HomeTableCardSectionCellDelegate: class {
    func sectionTapped(_ sender: HomeTableCardSectionCell, section: HomeSectionVM?)
}

class HomeTableCardSectionCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var sessionView1: HomeTableCardSessionView! {
        didSet {
            sessionView1.delegate = self
            sessionView1.isLarge = false
        }
    }
    @IBOutlet weak var sessionView2: HomeTableCardSessionView! {
        didSet {
            sessionView2.delegate = self
            sessionView2.isLarge = false
            
        }
    }
    @IBOutlet weak var sessionView3: HomeTableCardSessionView! {
        didSet {
            sessionView3.delegate = self
            sessionView3.isLarge = true
            
        }
    }
    var data: HomeSectionVM? {
        didSet {
            reloadData()
        }
    }
    weak var delegate: HomeTableCardSectionCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        addGestureRecognizer(tapGesture)
    }
    
    private func initialize() {
        titleLabel.font = UIFont.kacstPen(ofSize: 16)
        titleLabel.textColor = UIColor.white.withAlphaComponent(0.64)
        
        subTitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        subTitleLabel.textColor = UIColor.white
        gradientView.applyGradientColor(colors: [UIColor.dusk.cgColor, UIColor.duskTwo.cgColor], startPoint: .bottom, endPoint: .top)
        gradientView.layer.cornerRadius = 32
        gradientView.layer.masksToBounds = true
        layer.masksToBounds = false
        layer.applySketchShadow(color: UIColor.black, alpha: 0.1, x: 0, y: 5, blur: 10, spread: 0)
    }
    
    private func reloadData() {
        titleLabel.text = data?.title
        subTitleLabel.text = data?.subTitle
        sessionView1.data = data?.sessions[safe: 0]
        sessionView2.data = data?.sessions[safe: 1]
        sessionView3.data = data?.sessions[safe: 2]
    }
    
    @objc
    private func viewTapped(_ sender: HomeTableCardSectionCell) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        pulsate()
        delegate?.sectionTapped(self, section: data)
    }
}

extension HomeTableCardSectionCell:  HomeTableCardSessionViewDelegate {
    func sessionTapped(_ sender: HomeTableCardSessionView, session: HomeSessionVM?) {
        
    }
}
