//
//  ChartDataView.swift
//  Tawazon
//
//  Created by mac on 25/01/2023.
//  Copyright © 2023 Inceptiontech. All rights reserved.
//

import UIKit

class ChartDataView: UIView {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dataTypeSegment: RoundedSegmentedControl!
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var upperDividerView: UIView!
    @IBOutlet weak var verticalDividerView: UIView!
    @IBOutlet weak var bottomDividerView: UIView!
    @IBOutlet weak var verticalGradientView: GradientView!
    @IBOutlet weak var lineChartView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        dataTypeSegment.layoutIfNeeded()
        dataTypeSegment.roundCorners(corners: .allCorners, radius: 14)
//        dataTypeSegment.layer.cornerRadius = 14
    }
    private func initialize(){
        dateLabel.font = .munaBoldFont(ofSize: 20)
        dateLabel.textColor = .white.withAlphaComponent(0.5)
        dateLabel.text = "ديسمبر"
        
        dataTypeSegment.backgroundColor = .catalinaBlue
        dataTypeSegment.layer.masksToBounds = true
        dataTypeSegment.roundCorners(corners: .allCorners, radius: 14)
        dataTypeSegment.segmentImage = UIImage(color: .chambray)
        dataTypeSegment.setTitle("moodTrakerAccumulative".localized, forSegmentAt: 0)
        dataTypeSegment.setTitle("moodTrakerSubtractive".localized, forSegmentAt: 1)
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, .font: UIFont.munaBoldFont(ofSize: 16)]
        dataTypeSegment.setTitleTextAttributes(titleTextAttributes, for: .normal)
        dataTypeSegment.setTitleTextAttributes(titleTextAttributes, for: .selected)
        
        chartView.backgroundColor = .midnightBlue
        chartView.roundCorners(corners: .allCorners, radius: 16)
        
        upperDividerView.backgroundColor = .chambray
        
        verticalDividerView.backgroundColor = .chambray
        
        bottomDividerView.backgroundColor = .chambray
        
        verticalGradientView.applyGradientColor(colors: [UIColor.deYork.cgColor, UIColor.barleyWhite.cgColor, UIColor.cranberry.cgColor], startPoint: .top, endPoint: .bottom)
        verticalGradientView.roundCorners(corners: .allCorners, radius: 2)
        
        lineChartView.backgroundColor = .clear
        
    }
}
