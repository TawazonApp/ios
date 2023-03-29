//
//  LandingReminderViewController.swift
//  Tawazon
//
//  Created by mac on 03/11/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//
import UserNotifications
import UIKit
import AudioToolbox

class DayViewTapGesture: UITapGestureRecognizer {
    var dayIndex = Int()
    var selected = Bool()
}

class LandingReminderViewController: HandleErrorViewController {
    
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var closeButton: CircularButton!
    @IBOutlet weak var reminderImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var reminderView: UIView!
    @IBOutlet weak var reminderViewTitleLabel: UILabel!
    @IBOutlet weak var reminderDaysStack: UIStackView!
    @IBOutlet weak var reminderTimeLabel: UILabel!
    @IBOutlet weak var amPmStack: UIStackView!
    @IBOutlet weak var amButton: UIButton!
    @IBOutlet weak var pmButton: UIButton!
    @IBOutlet weak var selectedTimeLabel: UILabel!
    @IBOutlet weak var selectedTimeField: UITextField!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet var weekDaysViews: [DayView]!
    
    var datePicker :UIDatePicker!
    
    let leftCorners : UIRectCorner = [[.bottomLeft, .topLeft]]
    let rightCorners : UIRectCorner = [.bottomRight, .topRight]
    var pmButtonCorners : UIRectCorner?
    var amButtonCorners : UIRectCorner?
    var calendar = Calendar.current
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pmButtonCorners = Language.language == .english ? rightCorners : leftCorners
        amButtonCorners  = Language.language == .english ? leftCorners : rightCorners
        
        initialize()
        TrackerManager.shared.sendEvent(name: GeneralCustomEvents.landingReminderScreenLoad, payload: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
   
    
    private func initialize(){
        view.backgroundColor = .midnight
        
        backgroundImageView.backgroundColor = .clear
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.image = UIImage(named: "PreparationSessionHeader")
        
        closeButton.roundCorners(corners: .allCorners, radius: 24)
        closeButton.backgroundColor = .black.withAlphaComponent(0.62)
        closeButton.setImage(UIImage(named: "Cancel"), for: .normal)
        closeButton.tintColor = .white
        
        reminderImageView.backgroundColor = .clear
        reminderImageView.contentMode = .scaleToFill
        reminderImageView.image = UIImage(named: "LandingReminderIcon")
        
        titleLabel.font = .munaBoldFont(ofSize: 36)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.text = "landingReminderViewTitle".localized
        
        subtitleLabel.font = .munaFont(ofSize: 14)
        subtitleLabel.textColor = .white
        subtitleLabel.numberOfLines = 0
        subtitleLabel.lineBreakMode = .byWordWrapping
        subtitleLabel.textAlignment = .center
        subtitleLabel.text = "landingReminderViewSubtitle".localized
        
        reminderView.backgroundColor = .clear
        
        reminderViewTitleLabel.font = .munaBoldFont(ofSize: 22)
        reminderViewTitleLabel.textColor = .white
        reminderViewTitleLabel.textAlignment = .center
        reminderViewTitleLabel.text = "landingReminderViewSelectDaysLabel".localized
        
        reminderTimeLabel.font = .munaBoldFont(ofSize: 22)
        reminderTimeLabel.textColor = .white
        reminderTimeLabel.textAlignment = .center
        reminderTimeLabel.text = "landingReminderViewSelectTimeLabel".localized
        
        amPmStack.backgroundColor = .clear
        
        amButton.setTitle("AM".localized, for: .normal)
        amButton.backgroundColor = .darkGray.withAlphaComponent(0.26)
        amButton.tintColor = .white
        amButton.gradientBorder(width: 1, colors: [.mayaBlue, .mauve, .white.withAlphaComponent(0)], startPoint: .bottomLeft, endPoint: .topRight, corners: amButtonCorners!, andRoundCornersWithRadius: 15.0)
        amButton.roundCorners(corners: amButtonCorners!, radius: 15.0)
        amButton.addTarget(self, action: #selector(self.amPmTapped), for: .touchUpInside)
        
        pmButton.setTitle("PM".localized, for: .normal)
        pmButton.backgroundColor = .darkGray.withAlphaComponent(0.26)
        pmButton.tintColor = .white
        pmButton.roundCorners(corners: pmButtonCorners!, radius: 15.0)
        pmButton.addTarget(self, action: #selector(self.amPmTapped), for: .touchUpInside)
        
        selectedTimeLabel.isHidden = true
        
        selectedTimeField.font = .munaFont(ofSize: 24)
        selectedTimeField.textColor = .white
        selectedTimeField.textAlignment = .center
        selectedTimeField.roundCorners(corners: .allCorners, radius: 15)
        setDateTextField(from: Date())
        selectedTimeField.backgroundColor = .darkGray.withAlphaComponent(0.26)
        selectedTimeField.gradientBorder(width: 1, colors: [.mayaBlue, .mauve, .white.withAlphaComponent(0)], startPoint: .bottomLeft, endPoint: .topRight, andRoundCornersWithRadius: 15)
        
        let hours = Calendar.current.component(.hour, from: Date())
        updateAmPmButtonStyle(hours: hours)
        
        noteLabel.font = .munaFont(ofSize: 14)
        noteLabel.textColor = .white
        noteLabel.textAlignment = .center
        noteLabel.numberOfLines = 0
        noteLabel.lineBreakMode = .byWordWrapping
        noteLabel.text = "landingReminderViewNoteLabel".localized
        
        
        saveButton.tintColor = .white
        saveButton.layer.cornerRadius = 20
        saveButton.backgroundColor = .white
        saveButton.tintColor = UIColor.mariner
        saveButton.setTitle("landingReminderViewSubmitButtonTitle".localized, for: .normal)
        saveButton.titleLabel?.font = UIFont.munaBoldFont(ofSize: 26)
        
        weekDaysViews = weekDaysViews.enumerated().map{ (index, weekDayView) in
            weekDayView.layer.cornerRadius = 20
            weekDayView.backgroundColor = .white.withAlphaComponent(0.08)
            
            weekDayView.transform = CGAffineTransform(rotationAngle: 30.0 * .pi / 180.0)
            
            
            weekDayView.DayTitleLabel.font = .munaFont(ofSize: 16)
            weekDayView.DayTitleLabel.textColor = .white
            weekDayView.DayTitleLabel.transform = CGAffineTransform(rotationAngle: -90.0 * .pi / 180.0)
            weekDayView.DayTitleLabel.text = weekdayDayNames()[index]
            weekDayView.name = weekdayDayNames()[index]
            weekDayView.DayTitleLabel.setContentHuggingPriority(.init(249), for: .horizontal)
            weekDayView.DayTitleLabel.setContentHuggingPriority(.init(249), for: .vertical)
            let tapAction = DayViewTapGesture(target: self, action: #selector(weekDayTapped(_:)))
            tapAction.dayIndex = index
            weekDayView.addGestureRecognizer(tapAction)
            
//            weekDayView.dayIndex = Language.language == .english ? index + 1 : index
            weekDayView.dayIndex = index + 1
            let currentDayIndex = Calendar.current.component(.weekday, from: Date())
            if currentDayIndex % 2 == 0{
                if weekDayView.dayIndex! % 2 == 0{
                    weekDayViewFormatting(weekDayView: weekDayView, selected: weekDayView.selected)
                    weekDayView.selected = true
                }
            }else{
                if weekDayView.dayIndex! % 2 != 0{
                    weekDayViewFormatting(weekDayView: weekDayView, selected: weekDayView.selected)
                    weekDayView.selected = true
                }
            }
            return weekDayView
        }
        initializeDatePicker()
    }
    
    @objc private func amPmTapped(){
        selectedTimeField.sendActions(for: .touchUpInside)
        selectedTimeField.becomeFirstResponder()
    }
    private func initializeDatePicker(){
        datePicker = UIDatePicker.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 200))
        datePicker.datePickerMode  = .time
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.addTarget(self, action: #selector(self.dateChanged), for: .allEvents)

        selectedTimeField.inputView = datePicker

        let doneButton = UIBarButtonItem.init(title: "ok".localized, style: .done, target: self, action: #selector(self.datePickerDone))
        let toolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 44))
        toolBar.setItems([UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil), doneButton], animated: true)
        selectedTimeField.inputAccessoryView = toolBar
    }
    
    @objc func datePickerDone() {
        selectedTimeField.resignFirstResponder()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       self.view.endEditing(true)
    }
    
    @objc func dateChanged() {
        setDateTextField(from: datePicker.date)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        TrackerManager.shared.sendReminderTimeSelected(time: formatter.string(from: datePicker.date))
    }
    
    private func setDateTextField(from date: Date){
        let calendar = Calendar.current
        let hours = calendar.component(.hour, from: date)
        
        let minutesString = String(format: "%02d",calendar.component(.minute, from: date))
        let hoursString = hours > 12 ? String(format: "%02d", hours - 12) : String(format: "%02d", hours)
        
        selectedTimeField.text = "\(hoursString):\(minutesString)"
        updateAmPmButtonStyle(hours: hours)
    }
    private func updateAmPmButtonStyle(hours: Int){
        if hours >= 12{
            
            pmButton.gradientBorder(width: 1, colors: [.mayaBlue, .mauve, .white.withAlphaComponent(0)], startPoint: .bottomLeft, endPoint: .topRight, corners: [pmButtonCorners!], andRoundCornersWithRadius: 15.0)
            
            amButton.layer.sublayers?.first(where: {$0.name == UIView.kLayerNameGradientBorder})?.removeFromSuperlayer()
            
            pmButton.backgroundColor = .lightSkyBlue.withAlphaComponent(0.4)
            amButton.backgroundColor = .darkGray.withAlphaComponent(0.26)
        }
        else{
            
            amButton.gradientBorder(width: 1, colors: [.mayaBlue, .mauve, .white.withAlphaComponent(0)], startPoint: .bottomLeft, endPoint: .topRight, corners: amButtonCorners!, andRoundCornersWithRadius: 15.0)
            
            pmButton.layer.sublayers?.first(where: {$0.name == UIView.kLayerNameGradientBorder})?.removeFromSuperlayer()
            
            amButton.backgroundColor = .lightSkyBlue.withAlphaComponent(0.4)
            pmButton.backgroundColor = .darkGray.withAlphaComponent(0.26)
        }
    }
    private func formateDate(_ date: Date) -> String{
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "hh : mm"
        return dateFormatter.string(from: date)
    }
    
    private func weekdayDayNames() -> [String] {
        var weekDays : [String] = []
        calendar.locale = Locale(identifier: Language.languageCode())
        let firstWeekday = 2
        for dayNumber in 0...6{
            let dayIndex = ((dayNumber - 1) + (firstWeekday - 1)) % 7
            weekDays.append(calendar.weekdaySymbols[dayIndex].localized)
        }
        return weekDays
    }
    
    private func initializeWeekDays(){
        weekDaysViews = weekDaysViews.map{ let weekDayView = $0
            weekDayView.gradientBorder(width: 1, colors: [.mayaBlue, .mauve, .white.withAlphaComponent(0)], startPoint: .bottomLeft, endPoint: .topRight, andRoundCornersWithRadius: 20)
            
            return weekDayView
        }
    }
    
    @objc private func weekDayTapped(_ sender: DayViewTapGesture){
        let dayIndex = sender.dayIndex
        weekDaysViews = weekDaysViews.enumerated().map{ (index, weekDayView) in
            if dayIndex == index{
                let isSelected = weekDayView.selected
                weekDayViewFormatting(weekDayView: weekDayView, selected: isSelected)
            }
            return weekDayView
        }
        let weekDay = self.weekDaysViews[dayIndex]
        TrackerManager.shared.sendReminderDayTapped(dayId: String(weekDay.dayIndex ?? 0), dayName: weekDay.name, selected: weekDay.selected)
    }
    
    private func weekDayViewFormatting(weekDayView: DayView, selected: Bool){
        if !selected{
            weekDayView.selected = true
            weekDayView.backgroundColor = .lightSkyBlue.withAlphaComponent(0.4)
            weekDayView.gradientBorder(width: 1, colors: [.mayaBlue, .mauve, .white.withAlphaComponent(0)], startPoint: .bottomLeft, endPoint: .topRight, andRoundCornersWithRadius: 20)
        }else{
            weekDayView.selected = false
            weekDayView.backgroundColor = .white.withAlphaComponent(0.08)
            weekDayView.layer.sublayers?.first(where: {$0.name == UIView.kLayerNameGradientBorder})?.removeFromSuperlayer()
        }
    }
    @objc private func selectedTimeTapped(){
        let picker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        picker.datePickerMode = .time
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        view.addSubview(picker)
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        picker.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    
    @IBAction func saveReminderTapped(_ sender: Any) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge] ,completionHandler: {(success, error) in
            if success{
                self.scheduleReminder()
                
            }else if let error = error{
                print("Error: \(error.localizedDescription)")
            }
        })
    }
    
    private func scheduleReminder(){
        DispatchQueue.main.async {
            let weekdaysReminder = self.weekDaysViews.filter({return $0.selected})
            self.calendar.locale = .autoupdatingCurrent
            let selectedDate = self.datePicker.date
            print("selectedDate: \(selectedDate)")
            self.scheduleReminderFor(date: selectedDate)
        }
    }
    private func scheduleReminderFor(date: Date){
        var localeContent : [String : Any]?
        if Language.language == .english{
            localeContent = RemoteConfigManager.shared.json(forKey: .meditationReminderString)["en"] as? [String: Any]
        }else{
            localeContent =  RemoteConfigManager.shared.json(forKey: .meditationReminderString)["ar"] as? [String: Any]
        }
        let content = UNMutableNotificationContent()
        if let localeContent = localeContent{
            content.title = localeContent["title"] as! String
            content.sound = .default
            content.subtitle = localeContent["subtitle"] as! String
            content.body = localeContent["body"] as! String
        }
        
        
        let weekdaysReminder = self.weekDaysViews.filter({return $0.selected})
        for weekday in weekdaysReminder {
            var dateInfo = DateComponents()
            dateInfo.hour = calendar.component(.hour, from: date)
            dateInfo.minute = calendar.component(.minute, from: date)
            dateInfo.weekday = weekday.dayIndex
            dateInfo.timeZone = .current

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: true)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
                if let error = error{
                    print("Error Adding: \(error.localizedDescription)")
                }
                let formatter = DateFormatter()
                formatter.dateFormat = "hh:mm a"
                TrackerManager.shared.sendReminderSet(dayId: String(weekday.dayIndex ?? 0), dayName: weekday.name, time: formatter.string(from: date))
                TrackerManager.shared.sendEvent(name: GeneralCustomEvents.landingReminderSubmit, payload: ["dayId": String(weekday.dayIndex ?? 0), "dayName": weekday.name, "time": formatter.string(from: date)])
            })
       }
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        setUserSettings(reminderForDate: formatter.string(from: date))
    }
    
    private func setUserSettings(reminderForDate: String){
        let weekdaysReminder = self.weekDaysViews.filter({return $0.selected})
        let days = weekdaysReminder.map{ weekday in
            return weekday.dayIndex!
        }
        
        var settings = UserSettings(defaultAudioSource: "ar.ps", alarms: [Alarm(time: reminderForDate, days: days)])
        if Language.language == .english{
            settings = UserSettings(defaultAudioSource: "en.us", alarms:  [Alarm(time: reminderForDate, days: days)])
        }
        UserInfoManager.shared.setUserSessionSettings(settings: settings, service: MembershipServiceFactory.service()){ (error) in
            if let error = error{
                self.showErrorMessage( message: error.localizedDescription )
            }
            self.openMainViewController()
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        TrackerManager.shared.sendReminderSkipped()
        TrackerManager.shared.sendEvent(name: GeneralCustomEvents.landingReminderSkip, payload: nil)
        openMainViewController()
    }
    
    private func openMainViewController() {
        SystemSoundID.play(sound: .LaunchToHome)
        (UIApplication.shared.delegate as? AppDelegate)?.pushWindowToRootViewController(viewController: MainTabBarController.instantiate(), animated: true)
    }
    
}

extension LandingReminderViewController{
    class func instantiate() -> LandingReminderViewController {
        let storyboard = UIStoryboard(name: "Membership", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: LandingReminderViewController.identifier) as! LandingReminderViewController
        viewController.modalPresentationStyle = .fullScreen
        
        return viewController
    }
}
