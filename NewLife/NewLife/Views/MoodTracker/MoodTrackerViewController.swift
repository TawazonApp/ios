//
//  MoodTrackerViewController.swift
//  Tawazon
//
//  Created by mac on 25/01/2023.
//  Copyright © 2023 Inceptiontech. All rights reserved.
//

import UIKit

class MoodTrackerViewController: HandleErrorViewController, ChartDataViewDelegate {
    
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
    
    var moodTrackerVM: MoodTrackerVM = MoodTrackerVM(service: TodayServiceFactory.service())
    
    var moodTrackerStatsVM: MoodTrackerStatsVM = MoodTrackerStatsVM(service: TodayServiceFactory.service())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        fetchMoodTrackerData(from: "", type: 1)
        fetchMoodTrackerStatsData()
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
        chartDataView.delegate = self
        
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

    @IBAction func backButtonTapped(_ sender: UIButton) {
        if isModal() {
            self.dismiss(animated: true, completion: nil)
        } else {
             self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func statisticsValueLabelAttributeText(part1: String, part2: String) -> NSMutableAttributedString {
        
        let allText = String(format: "%@ %@", part1, part2)
        
        let attributedString = NSMutableAttributedString(string: allText, attributes: [.font: UIFont.munaFont(ofSize: 16)])
        
        if let part1Range = allText.range(of: part1) {
            attributedString.addAttributes([.font: UIFont.munaFont(ofSize: 28, language: .english)], range: part1Range.nsRange(in: allText))
        }
        return attributedString
    }
    
    private func fetchMoodTrackerData(from: String, type: Int) {
        moodTrackerVM.getMoodTrackerData(from: from, type: type) { [weak self] (error) in
            if let error = error {
                self?.showErrorMessage(message: error.localizedDescription)
            }
            if from == ""{
                self?.dateSegment.removeAllSegments()
                if let ranges = self?.moodTrackerVM.MoodTrackerData?.ranges{
                    for (index, range) in ranges.enumerated(){
                        self?.dateSegment.insertSegment(withTitle: range.title, at: index, animated: false)
                    }
                }
                self?.dateSegment.selectedSegmentIndex = 0
            }
            self?.chartDataView.moodTrackerVM = self?.moodTrackerVM
            
        }
    }
    
    private func fetchMoodTrackerStatsData() {
        moodTrackerStatsVM.getMoodTrackerStatsData() { [weak self] (error) in
            if let error = error {
                self?.showErrorMessage(message: error.localizedDescription)
            }
            self?.setStatsData()
        }
    }
    private func setStatsData(){
        completedSessionValueLabel.attributedText = statisticsValueLabelAttributeText(part1: "\(moodTrackerStatsVM.MoodTrackerStatsData?.completedSessions ?? 0)", part2: "completedSessionValueLabel".localized)
        tawazonMinutesValueLabel.attributedText = statisticsValueLabelAttributeText(part1: "\(moodTrackerStatsVM.MoodTrackerStatsData?.tawazonMinutes ?? 0)", part2: "tawazonMinutesValueLabel".localized)
        userActivityValueLabel.attributedText = statisticsValueLabelAttributeText(part1: "\(moodTrackerStatsVM.MoodTrackerStatsData?.activeDays ?? 0)", part2: "userActivityValueLabel".localized)
    }
    @IBAction func dateChanged(_ sender: Any) {
        if let range = self.moodTrackerVM.MoodTrackerData?.ranges?[dateSegment.selectedSegmentIndex]{
            
            if range.id == 200{
                self.chartDataView.dataTypeSegment.isHidden = false
                fetchMoodTrackerData(from: range.from ?? "", type: 1)
            }else{
                self.chartDataView.dataTypeSegment.isHidden = true
                if range.id == 100{
                    fetchMoodTrackerData(from: range.from ?? "", type: 1)
                }else{
                    fetchMoodTrackerData(from: range.from ?? "", type: 2)
                }
            }
        }
    }
    
    func dataTypeChanged(type: Int) {
        if let range = self.moodTrackerVM.MoodTrackerData?.ranges?[dateSegment.selectedSegmentIndex]{
            fetchMoodTrackerData(from: range.from ?? "", type: type)
        }
    }
}


extension MoodTrackerViewController {
    
    class func instantiate() -> MoodTrackerViewController {
        let storyboard = UIStoryboard(name: "TodayActivity", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: MoodTrackerViewController.identifier) as! MoodTrackerViewController
        return viewController
    }
}
