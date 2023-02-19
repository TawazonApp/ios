//
//  DateValueFormatter.swift
//  ChartsDemo-iOS
//
//  Created by Jacob Christie on 2017-07-09.
//  Copyright © 2017 jc. All rights reserved.
//

import Foundation
import Charts

public class DateValueFormatter: AxisValueFormatter {
    private let dateFormatter = DateFormatter()
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        dateFormatter.dateFormat = "dd MMM"
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}
