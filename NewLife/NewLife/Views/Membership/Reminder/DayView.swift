//
//  DayView.swift
//  Tawazon
//
//  Created by mac on 07/11/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import Foundation
import UIKit

class DayView: UIView {
    @IBOutlet weak var DayTitleLabel: UILabel!
    var selected : Bool = false
    var dayIndex : Int?
    var name : String = ""
}
