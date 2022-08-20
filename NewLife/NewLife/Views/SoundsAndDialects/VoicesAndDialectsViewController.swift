//
//  VoicesAndDialectsViewController.swift
//  Tawazon
//
//  Created by mac on 29/05/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

protocol VoicesAndDialectsDelegate: class {
    func sessionStreamLinkChanged(audioSource: String)
    func changeInterfaceLanguage(language: Language)
}
class VoicesAndDialectsViewController: HandleErrorViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelButton: CircularButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var voicesAndDialectsTableView: UITableView!
    
    var delegate : VoicesAndDialectsDelegate?
    var session: SessionVM!
    var selectedVoice: Int = NSNotFound
    var selectedDialect: Int = NSNotFound
//    var appLanguages = [Language.english, Language.arabic]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
        selectedVoice = 0
        selectedDialect = 0
        
        sendOpenVoicesAndDialectsEvent()
        populateData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        populateData()
    }
    
    private func initialize() {
        titleLabel.text = "voiceAndDialectsTitle".localized
        titleLabel.font = UIFont.kacstPen(ofSize: 24, language: .arabic)
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        
        cancelButton.setImage(#imageLiteral(resourceName: "Cancel.pdf"), for: .normal)
       
        backgroundImageView.contentMode = .scaleAspectFill
        
        
        voicesAndDialectsTableView.backgroundColor = .clear
        voicesAndDialectsTableView.separatorStyle = .none
    }

    private func populateData() {
        if let localiImageUrl = session?.localImageUrl {
            let image = UIImage(contentsOfFile: localiImageUrl.path)
            backgroundImageView.image = image
        } else if let imageUrl = session?.imageUrl {
            backgroundImageView.af.setImage(withURL: imageUrl)
        }
        getUserPrefferedAudioSettings()
    }
    
    private func getUserPrefferedAudioSettings(){
        if let preferredVoiceAndDialect = session?.getSessionPreferredVoiceAndDialect(), preferredVoiceAndDialect.voice != nil, preferredVoiceAndDialect.dialect != nil{
            selectedVoice = session.audioSources?.firstIndex(where: {$0.code == preferredVoiceAndDialect.voice?.code}) ?? 0
            selectedDialect = session.audioSources?[selectedVoice].dialects.firstIndex(where: {$0.code == preferredVoiceAndDialect.dialect?.code}) ?? 0
            
            voicesAndDialectsTableView.reloadData()
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    private func sendOpenVoicesAndDialectsEvent() {
        TrackerManager.shared.sendOpenVoicesAndDialectsEvent()
    }
}

extension VoicesAndDialectsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            return "voice".localized
        case 1:
            return "dialect".localized
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return session.audioSources?.count ?? 0
        case 1:
            return session.audioSources?[selectedVoice].dialects.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: VoicesAndDialectsTableViewCell.identifier) as! VoicesAndDialectsTableViewCell
        cell.tintColor = .white
        cell.accessoryType = .none
        cell.setSelectedStyle(selected: false)
        
        switch indexPath.section {
        case 0:
            cell.titleLabel.text = session.audioSources?[indexPath.row].title
            if indexPath.row == selectedVoice {
                cell.setSelectedStyle(selected: true)
            }
            
        case 1:
            cell.titleLabel.text = session.audioSources?[selectedVoice].dialects[indexPath.row].title
            if indexPath.row == selectedDialect {
                cell.setSelectedStyle(selected: true)
            }
        default: break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = .white
        header.textLabel?.font = UIFont.lbc(ofSize: 24)
        header.textLabel?.frame = header.bounds
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as! VoicesAndDialectsTableViewCell
        switch indexPath.section  {
        case 0:
            if selectedVoice >= 0 && selectedVoice < tableView.numberOfRows(inSection: 0) {
                let oldSelectedCell = tableView.cellForRow(at: IndexPath(item: selectedVoice, section: 0)) as! VoicesAndDialectsTableViewCell
                oldSelectedCell.setSelectedStyle(selected: false)
            }
            selectedVoice = indexPath.row
            selectedDialect = 0
            selectedCell.setSelectedStyle(selected: true)
            if session.audioSources?[selectedVoice].dialects.count == 1 {
                let dialectIndexPath = IndexPath(row: 0, section: 1)
                tableView.selectRow(at: dialectIndexPath, animated: false, scrollPosition: .none)
                tableView.delegate?.tableView!(tableView, didSelectRowAt: dialectIndexPath)
                return
            }
            tableView.reloadSections([1], with: .automatic)
        case 1:
            if selectedDialect >= 0 && selectedDialect < tableView.numberOfRows(inSection: 1) {
                let oldSelectedCell = tableView.cellForRow(at: IndexPath(item: selectedDialect, section: 1)) as! VoicesAndDialectsTableViewCell
                oldSelectedCell.setSelectedStyle(selected: false)
            }
            selectedDialect = indexPath.row
            selectedCell.setSelectedStyle(selected: true)
            
            savePrefferedAudioSettings(voice: session.audioSources?[selectedVoice].code ?? "", dialect: session.audioSources?[selectedVoice].dialects[indexPath.row].code ?? "")
            
            if let voice = session.audioSources?[selectedVoice]{
                let dialect = voice.dialects[indexPath.row]
                
                delegate?.sessionStreamLinkChanged(audioSource: dialect.stream)
                TrackerManager.shared.sendChangeVoicesAndDialectsEvent(voice: voice.code, dialect: dialect.code)
                
                self.dismiss(animated: true)
            }
                
        default:
            break
            
        }
        
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 56.0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56.0
    }
    
    private func savePrefferedAudioSettings(voice: String, dialect: String){
        UserDefaults.saveSelectedVoice(code: voice)
        UserDefaults.saveSelectedDialect(code: dialect)
        
        session.service.setUserSessionSettings(settings: UserSettings(defaultAudioSource: dialect)){(error) in
        }
    }
}
extension VoicesAndDialectsViewController {
    class func instantiate(session: SessionVM) -> VoicesAndDialectsViewController {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: VoicesAndDialectsViewController.identifier) as! VoicesAndDialectsViewController
        viewController.session = session
        return viewController
    }
}
