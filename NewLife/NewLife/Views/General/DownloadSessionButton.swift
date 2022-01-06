//
//  DownloadButton.swift
//  NewLife
//
//  Created by Shadi on 14/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class DownloadSessionButton: UIButton {
    
    var loadingView: NVActivityIndicatorView?
    
    var downloadStatus : SessionDownloadStatus! {
        didSet {
            updateStyle()
        }
    }
    
    private func updateStyle() {
       
        if downloadStatus == .downloading {
            startLoadingAnimation()
        } else {
            stopLoadingAnimation()
        }
        self.isHidden = (downloadStatus == .downloaded)
        self.isEnabled = (downloadStatus != .downloading)
    }
 
    private func startLoadingAnimation() {
        if loadingView == nil {
            let loadingSize: CGFloat = self.frame.height
            loadingView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: loadingSize, height: loadingSize), type: NVActivityIndicatorType.circleStrokeSpin, color: UIColor.white, padding: 2)
            loadingView?.center = CGPoint(x: frame.width/2, y: frame.height/2)
            
            self.addSubview(loadingView!)
            loadingView?.startAnimating()
        }
        
    }
    
    private func stopLoadingAnimation() {
        loadingView?.stopAnimating()
        loadingView = nil
    }
    
}
