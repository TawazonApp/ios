//
//  PlayerControlsView.swift
//  NewLife
//
//  Created by Shadi on 05/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

protocol PlayerControlsViewDelegate: class {
    func backwardButtonTapped()
    func forwardButtonTapped()
}

class PlayerControlsView: UIView {
    
    @IBOutlet weak var backwardButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var durationLabel: UILabel!
    
    weak var delegate: PlayerControlsViewDelegate?
    
    var duration: String? {
        didSet {
            fillData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }

    private func initialize() {
        backwardButton.tintColor = UIColor.white
        backwardButton.setBackgroundImage(#imageLiteral(resourceName: "PlayerBackward.pdf"), for: .normal)
        backwardButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        backwardButton.setTitle("10", for: .normal)
        
        forwardButton.tintColor = UIColor.white
        forwardButton.setBackgroundImage(#imageLiteral(resourceName: "PlayerForward.pdf"), for: .normal)
        forwardButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        forwardButton.setTitle("10", for: .normal)
        
        durationLabel.font = UIFont.systemFont(ofSize: 17)
        durationLabel.textColor = UIColor.white
    }
    
    private func fillData() {
        durationLabel.text = duration
    }
    
    @IBAction func backwardButtonTapped(_ sender: UIButton) {
        delegate?.backwardButtonTapped()
    }
    
    @IBAction func forwardButtonTapped(_ sender: UIButton) {
        delegate?.forwardButtonTapped()
    }
}
