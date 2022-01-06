//
//  UploadImageView.swift
//  NewLife
//
//  Created by Shadi on 20/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class UploadImageView: UIImageView {

    var loadingView: NVActivityIndicatorView?
    
    var loading: Bool = false {
        didSet {
            if loading {
                startAnimation()
            } else {
                stopAnimation()
            }
        }
    }
    
    private func startAnimation() {
        if loadingView == nil {
            let loadingSize: CGFloat = self.frame.height - 40
            loadingView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: loadingSize, height: loadingSize), type: NVActivityIndicatorType.ballSpinFadeLoader, color: UIColor.white, padding: nil)
            loadingView?.center = CGPoint(x: frame.width/2, y: frame.height/2)
            
            self.addSubview(loadingView!)
            loadingView?.startAnimating()
        }
       
    }
    
    private func stopAnimation() {
        loadingView?.stopAnimating()
        loadingView = nil
    }
}
