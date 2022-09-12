//
//  InstallSourcesVM.swift
//  Tawazon
//
//  Created by mac on 08/09/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import Foundation

class InstallSourcesVM: NSObject {
    
    let service: MembershipService!
    var installSourcesModel: InstallSourcesModel? {
        didSet {
            buildSourcesArray()
        }
    }
    
    var sources: [InstallSourceVM] = []
    
    init(service: MembershipService) {
        self.service = service
    }
    
    private func buildSourcesArray() {
        sources = installSourcesModel?.installSources?.map({ return InstallSourceVM(id: $0.id, name: $0.name , isSelected: $0.selected)}) ?? []
    }
    
    func fetchInstallSources(completion: @escaping (_ error: CustomError?) -> Void) {
        service.fetchInstallSources { (installSources, error) in
            if error == nil {
                self.installSourcesModel = installSources
            }
            completion(error)
        }
    }
    
    func setSelectedSource(source: InstallSourceVM, completion: @escaping (_ error: CustomError?) -> Void) {
        
        service.setInstallSource(selectedInstallSourceId: source.id) { (error) in
            if error == nil {
                TrackerManager.shared.sendSetInstallSource(installSource: source.name)
            }
            completion(error)
        }
        
    }
    
}

