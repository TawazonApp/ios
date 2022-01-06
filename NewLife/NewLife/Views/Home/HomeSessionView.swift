//
//  HomeAnimateRectangleView.swift
//  NewLife
//
//  Created by Shadi on 26/02/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

protocol HomeSessionViewDelegate: class {
    func sessionTapped(session: HomeSessionVM)
}

class HomeSessionView: UIView {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var lockImageView: UIImageView!
    weak var delegate: HomeSessionViewDelegate?
    
    let duration: TimeInterval = 1.0
    var tapGesture: UITapGestureRecognizer!
    
    weak var shapeLayer: CAShapeLayer?
    
    var session: HomeSessionVM? {
        didSet {
            fillData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize() {
        nameLabel.font = UIFont.lbc(ofSize: 24, language: .arabic)
        nameLabel.textColor = UIColor.white
        
        descriptionLabel.font = UIFont.kacstPen(ofSize: 20, language: .arabic)
        descriptionLabel.textColor = UIColor.white
        
        durationLabel.font = UIFont.kacstPen(ofSize: 16)
        durationLabel.textColor = UIColor.white
        lockImageView.image = #imageLiteral(resourceName: "SessionLock.pdf")
        lockImageView.contentMode = .scaleAspectFit
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        lockImageView.isHidden = true
        addGestureRecognizer(tapGesture)
        //isUserInteractionEnabled = false
    }
    
    @objc func tapped(_ sender: UITapGestureRecognizer) {
        guard let session = session else { return }
        delegate?.sessionTapped(session: session)
    }
    
    func draw(_ animated: Bool) {
        
        self.shapeLayer?.removeFromSuperlayer()
        
        // create whatever path you want
        
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), cornerRadius: 32)
        
        // create shape layer for that path
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.path = path.cgPath
        
        shapeLayer.applySketchShadow(color: UIColor.white, alpha: 1.0, x: 0, y: 0, blur: 16, spread: 0)
        
        self.layer.addSublayer(shapeLayer)
        
        // animate it
        if animated {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0.5
            animation.duration = duration
            animation.timingFunction =  CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            shapeLayer.add(animation, forKey: "MyAnimation")
        }
        
        self.shapeLayer = shapeLayer
    }
    
    private func fillData() {
        nameLabel.text = session?.name
        descriptionLabel.text = session?.descriptionString
        durationLabel.text = session?.durationString
        lockImageView.isHidden = (session?.isLock ?? false) == false
    }
    /*
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        //TODO//
        let view = super.hitTest(point, with: event)
        return view == self ? nil : view
    }
 */
}
