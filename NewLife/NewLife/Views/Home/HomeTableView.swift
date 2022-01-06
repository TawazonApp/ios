//
//  HomeTableView.swift
//  Tawazon
//
//  Created by Shadi on 09/04/2021.
//  Copyright © 2021 Inceptiontech. All rights reserved.
//

import UIKit

class HomeTableView: UITableView {
    weak var videosContainer: UIView?
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return point.y >= 0
    }
}
