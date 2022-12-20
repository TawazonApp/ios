//
//  TawazonTalkSectionVM.swift
//  Tawazon
//
//  Created by mac on 18/12/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import Foundation
class TawazonTalkSectionVM{
    var title: String
    var sessions: [HomeSessionVM]
    
    init(title: String, sessions: [HomeSessionVM]) {
        self.title = title
        self.sessions = sessions
    }
    init(section: TawazonTalkSection){
        self.title = section.title
        self.sessions = section.items.map({HomeSessionVM(session: $0)})
    }
}
