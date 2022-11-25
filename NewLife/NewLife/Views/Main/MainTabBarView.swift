//
//  MainTabBarView.swift
//  NewLife
//
//  Created by Shadi on 25/02/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit
import AudioToolbox

protocol MainTabBarViewDelegate: class {
    func tabItemTapped(index: Int)
}

class MainTabBarView: UIView {
    
    @IBOutlet var items : [MainTabBarItemView]!
    
    weak var delegate: MainTabBarViewDelegate?
    
    lazy var dataItems: [MainTabBarItemVM] =  {
        return  tabBarItemsIds.allCases.map({ return MainTabBarItemVM(id: $0.rawValue ) })
    }()
    
    let animationDuration: TimeInterval = 0.75
    var selectedIndex: Int = 0
    
    enum tabBarItemsIds: String {
        case todayActivity = "1"
        case home = "2"
//        case myBody = "2"
//        case music = "2"
        case meditations = "3"
//        case mySoul = "4"
        case podcasts = "4"
        case children = "5"
        static let allCases:[tabBarItemsIds] = [.todayActivity, .home, .meditations, .podcasts, .children]
        
        static func getItemId(forCategory categoryId: String) -> tabBarItemsIds? {
           let categoryId = CategoryIds(rawValue: categoryId)
            
            switch categoryId {
//            case .music:
//                return tabBarItemsIds.music
            case .children:
                return tabBarItemsIds.children
            case .podcasts:
                return tabBarItemsIds.podcasts
            case .meditations:
                return tabBarItemsIds.meditations
            default:
                return nil
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
        
//        let tourView = GuidedTourView(frame: self.frame)
//        tourView.backgroundColor = .darkBlueGrey.withAlphaComponent(0.62)
//        self.addSubview(tourView)
//        tourView.steps = [
//            StepInfo(view: items[1], textInfo: ("TITLE","مكان واحد حيث تجتمع التأملات المتنوعة بتأملات الجسد الذي ما يلبس أن يمتزج بتأملات الروح. طالع                                                التأملات، جسدي، روحي"), isBelow: false),
////            StepInfo(view: searchButton!, textInfo: ("TITLE","ابحث عن ما تريد ضمن أي فئة مباشرة وبشكل سريع عن طريق شريط البحث الممتد إلى أعماق محتويات توازن! 🔦"), isBelow: true),
////            StepInfo(view: backgroundSoundButton!, textInfo: ("TITLE","قم بتشغيل وإيقاف موسيقى الخلفية للتطبيق! 🪕"), isBelow: true),
////            StepInfo(view: soundsButton!, textInfo: ("TITLE","قم بإضافة مزيج من المؤثرات الصوتية بما يتناسب والشعور الذي تمر به أو تبحث عن الانغماس فيه. أضف طبقة ممتعة من الأصوات المريحة. 🌊🔥🌧🐧🌳"), isBelow: true),
////            StepInfo(view: !, textInfo: ("TITLE","قم بتشغيل وإيقاف موسيقى الخلفية للتطبيق! 🪕"), isBelow: true),
//            
//        ]
//        tourView.showSteps()
    }
    
    private func initialize() {
        selectedIndex = 0
        
        for (index,data) in dataItems.enumerated() {
            data.isSelected = (index == selectedIndex)
            items[index].data = data
            items[index].delegate = self
        }
    }
    
    func animateItems()  {
        for item in items {
            let translationX = UIApplication.isRTL() ? -item.frame.origin.x : item.frame.origin.x
            item.transform = CGAffineTransform(translationX: translationX, y: 0)
            UIView.animate(WithDuration: animationDuration, timing: .easeOutQuart, animations: {
                item.transform = CGAffineTransform.identity
            }, completion: nil)
        }
    }
    
}

extension MainTabBarView: MainTabBarItemViewDelegate {
    
    func openTap(id: tabBarItemsIds) {
        
        let index = dataItems.firstIndex { (item) -> Bool in
            item.id == id.rawValue
        }
        guard index != nil && index != selectedIndex else {
            return
        }
        
        items[selectedIndex].updateStyle(isSelected: false)
        let oldSelectedData = dataItems[selectedIndex]
        
        (id.rawValue == tabBarItemsIds.home.rawValue || oldSelectedData.id ==  tabBarItemsIds.home.rawValue) ? SystemSoundID.play(sound: .Sound2) :  SystemSoundID.play(sound: .Sound1)
        
        selectedIndex = index!
        items[safe: selectedIndex]?.updateStyle(isSelected: true)
        delegate?.tabItemTapped(index: selectedIndex)
    }
    
    func itemTapped(item: MainTabBarItemVM) {
        
        guard let index = dataItems.firstIndex(of: item), index != selectedIndex else {
            return
        }
        
        items[selectedIndex].updateStyle(isSelected: false)
        let oldSelectedData = dataItems[selectedIndex]
        
        (item.id == tabBarItemsIds.home.rawValue || oldSelectedData.id ==  tabBarItemsIds.home.rawValue) ? SystemSoundID.play(sound: .Sound2) :  SystemSoundID.play(sound: .Sound1)
        
        selectedIndex = index
        
        delegate?.tabItemTapped(index: selectedIndex)
    }
}
