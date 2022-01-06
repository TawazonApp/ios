//
//  MoreSwitchCell.swift
//  NewLife
//
//  Created by Shadi on 28/02/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit
import AudioToolbox

class MoreSwitchCell: MoreCell {

    @IBOutlet weak var switchControl: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize() {
        switchControl.tintColor = UIColor.white.withAlphaComponent(0.2)
        switchControl.layer.cornerRadius = switchControl.frame.height / 2
        switchControl.backgroundColor = UIColor.white.withAlphaComponent(0.2)
    }
    
    override func fillData() {
        super.fillData()
        if let switchData = data as? MoreNotificationCellVM {
           updateSwitchStatus()
            
            switchData.fetchStatusIfNeeded { [weak self] (error) in
                if error == nil {
                    self?.updateSwitchStatus()
                }
            }
        }
    }
    
    private func updateSwitchStatus() {
        guard let switchData = data as? MoreNotificationCellVM else {
            return
        }
        switchControl.isOn = (switchData.switchValue) ?? false
        switchControl.isEnabled = (switchData.switchValue != nil)
    }

    private func changeStatus(status: Bool) {
        
        if let switchData = data as? MoreNotificationCellVM {
            switchData.changeStatus(status: status) { [weak self] (error) in
                self?.updateSwitchStatus()
            }
        }
        sendNotificationStatusChangedEvent(status: status)
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        SystemSoundID.play(sound: .switchOnOff)
        changeStatus(status: sender.isOn)
    }
    
    private func sendNotificationStatusChangedEvent(status: Bool) {
        TrackerManager.shared.sendNotificationStatusChangedEvent(status: status)
    }
}
