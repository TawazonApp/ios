//
//  SettingsSwitchCell.swift
//  Tawazon
//
//  Created by mac on 18/07/2023.
//  Copyright © 2023 Inceptiontech. All rights reserved.
//

import UIKit

class SettingsSwitchCell: SettingsCell {

    @IBOutlet weak var switchControl: UISwitch!
    @IBOutlet weak var contentBodyView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize() {
        
        contentBodyView.backgroundColor = .black.withAlphaComponent(0.6)
        contentBodyView.roundCorners(corners: .allCorners, radius: 24)
        
        switchControl.tintColor = UIColor.white.withAlphaComponent(0.2)
        switchControl.layer.cornerRadius = switchControl.frame.height / 2
        switchControl.backgroundColor = UIColor.white.withAlphaComponent(0.2)
    }
    
    override func fillData() {
        super.fillData()
        if let switchData = data as? NotificationCellVM {
           updateSwitchStatus()
            
            switchData.fetchStatusIfNeeded { [weak self] (error) in
                if error == nil {
                    self?.updateSwitchStatus()
                }
            }
        }
    }
    
    private func updateSwitchStatus() {
        guard let switchData = data as? NotificationCellVM else {
            return
        }
        switchControl.isOn = (switchData.switchValue) ?? false
        switchControl.isEnabled = (switchData.switchValue != nil)
    }

    private func changeStatus(status: Bool) {
        
        if let switchData = data as? NotificationCellVM {
            switchData.changeStatus(status: status) { [weak self] (error) in
                self?.updateSwitchStatus()
            }
        }
        sendNotificationStatusChangedEvent(status: status)
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        changeStatus(status: sender.isOn)
    }
    
    private func sendNotificationStatusChangedEvent(status: Bool) {
        TrackerManager.shared.sendNotificationStatusChangedEvent(status: status)
    }
}
