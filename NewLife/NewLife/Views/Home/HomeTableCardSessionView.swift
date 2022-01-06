//
//  HomeTableCardSessionView.swift
//  Tawazon
//
//  Created by Shadi on 14/11/2020.
//  Copyright © 2020 Inceptiontech. All rights reserved.
//

import UIKit

protocol HomeTableCardSessionViewDelegate: class {
    func sessionTapped(_ sender: HomeTableCardSessionView, session: HomeSessionVM?)
}

class HomeTableCardSessionView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    weak var delegate: HomeTableCardSessionViewDelegate?
    
    var isLarge: Bool = false {
        didSet {
            layer.cornerRadius = isLarge ? 32 : 24
        }
    }
    
    override func awakeFromNib() {
        superview?.awakeFromNib()
        initialize()
    }
    
    var data: HomeSessionVM? {
        didSet {
            populateData()
        }
    }

    private func initialize() {
        layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
    }
    
    private func populateData() {
        imageView.image = nil
        if let imageUrl = data?.imageUrl?.url {
            imageView.af.setImage(withURL: imageUrl)
        }
    }
}
