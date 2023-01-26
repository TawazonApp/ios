//
//  MoodTrackerViewController.swift
//  Tawazon
//
//  Created by mac on 25/01/2023.
//  Copyright © 2023 Inceptiontech. All rights reserved.
//

import UIKit

class MoodTrackerViewController: UIViewController {

    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var dateSegment: RoundedSegmentedControl!
    
    @IBOutlet weak var chartDataView: ChartDataView!
    
    @IBOutlet weak var statisticsView: UIView!
    @IBOutlet weak var statisticsViewTitleLabel: UILabel!
    
    @IBOutlet weak var completedSessionImageView: UIImageView!
    @IBOutlet weak var completedSessionTitleLabel: UILabel!
    @IBOutlet weak var completedSessionValueLabel: UILabel!
    
    @IBOutlet weak var tawazonMinutesImageView: UIImageView!
    @IBOutlet weak var tawazonMinutesTitleLabel: UILabel!
    @IBOutlet weak var tawazonMinutesValueLabel: UILabel!
    
    @IBOutlet weak var userActivityImageView: UIImageView!
    @IBOutlet weak var userActivityTitleLabel: UILabel!
    @IBOutlet weak var userActivityValueLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
    }
    

    private func initialize(){
        view.backgroundColor = .midnightBlueTwo
        
        headerImageView.image = UIImage(named: "MoodTrackerHeader")
        headerImageView.contentMode = .scaleAspectFill
        
        backButton.backgroundColor = .black.withAlphaComponent(0.41)
        backButton.setImage(UIImage(named: "Cancel"), for: .normal)
        backButton.tintColor = .white
        backButton.roundCorners(corners: .allCorners, radius: backButton.frame.height / 2)
        
        titleLabel.font = .lbc(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.text = "moodTrackerViewTitle".localized
        
        subTitleLabel.font = .munaBlackFont(ofSize: 24)
        subTitleLabel.textColor = .white
        subTitleLabel.text = "moodTrackerViewSubTitle".localized
        
        dateSegment.backgroundColor = .catalinaBlue
        dateSegment.layer.masksToBounds = true
        dateSegment.clipsToBounds = true
        dateSegment.roundCorners(corners: .allCorners, radius: 14)
        dateSegment.segmentImage = UIImage(color: .chambray)
        dateSegment.setTitle("moodTrakerWeek".localized, forSegmentAt: 0)
        dateSegment.setTitle("moodTrakerMonth".localized, forSegmentAt: 1)
        dateSegment.setTitle("moodTraker3Months".localized, forSegmentAt: 2)
        dateSegment.setTitle("moodTraker6Months".localized, forSegmentAt: 3)
        dateSegment.setTitle("moodTrakerYear".localized, forSegmentAt: 4)
        dateSegment.setTitle("moodTrakerAll".localized, forSegmentAt: 5)
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, .font: UIFont.munaBoldFont(ofSize: 16)]
        dateSegment.setTitleTextAttributes(titleTextAttributes, for: .normal)
        dateSegment.setTitleTextAttributes(titleTextAttributes, for: .selected)
        
        chartDataView.backgroundColor = .clear
        
        statisticsView.backgroundColor = .clear
        
        statisticsViewTitleLabel.font = .munaBlackFont(ofSize: 24)
        statisticsViewTitleLabel.textColor = .white
        statisticsViewTitleLabel.text = "moodTrackerStatisticsViewTitleLabel".localized
        
        completedSessionImageView.contentMode = .scaleAspectFill
        completedSessionImageView.image = UIImage(named: "MoodTrackerAllSessions")
        
        completedSessionTitleLabel.font = .munaFont(ofSize: 18)
        completedSessionTitleLabel.textColor = .white
        completedSessionTitleLabel.text = "MoodTrackerCompletedSessionTitleLabel".localized
        
        completedSessionValueLabel.textColor = .lavenderBlue
        completedSessionValueLabel.attributedText = statisticsValueLabelAttributeText(part1: "16", part2: "جلسة")
        
        tawazonMinutesImageView.contentMode = .scaleAspectFill
        tawazonMinutesImageView.image = UIImage(named: "MoodTrackerTawazonMinutes")
        
        tawazonMinutesTitleLabel.font = .munaFont(ofSize: 18)
        tawazonMinutesTitleLabel.textColor = .white
        tawazonMinutesTitleLabel.text = "MoodTrackerTawazonMinutesTitleLabel".localized
        
        tawazonMinutesValueLabel.textColor = .lavenderBlue
        tawazonMinutesValueLabel.attributedText = statisticsValueLabelAttributeText(part1: "40", part2: "دقيقة")
        
        userActivityImageView.contentMode = .scaleAspectFill
        userActivityImageView.image = UIImage(named: "MoodTrackerUserActivity")
        
        userActivityTitleLabel.font = .munaFont(ofSize: 18)
        userActivityTitleLabel.textColor = .white
        userActivityTitleLabel.text = "MoodTrackerUserActivityTitleLabel".localized
        
        userActivityValueLabel.textColor = .lavenderBlue
        userActivityValueLabel.attributedText = statisticsValueLabelAttributeText(part1: "5", part2: "يوم")
    }

    private func statisticsValueLabelAttributeText(part1: String, part2: String) -> NSMutableAttributedString {
        
        let allText = String(format: "%@ %@", part1, part2)
        
        let attributedString = NSMutableAttributedString(string: allText, attributes: [.font: UIFont.munaFont(ofSize: 16)])
        
        if let part1Range = allText.range(of: part1) {
            attributedString.addAttributes([.font: UIFont.munaFont(ofSize: 28, language: .english)], range: part1Range.nsRange(in: allText))
        }
        return attributedString
    }
}


extension MoodTrackerViewController {
    
    class func instantiate() -> MoodTrackerViewController {
        let storyboard = UIStoryboard(name: "TodayActivity", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: MoodTrackerViewController.identifier) as! MoodTrackerViewController
        return viewController
    }
}
