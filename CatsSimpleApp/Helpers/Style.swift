//
//  Style.swift
//  RocketsSchedule
//
//  Created by Tetiana Nieizviestna 
//

import UIKit

struct Style {
    struct Color {
        static let tabBarItem = UIColor(red: 0, green: 0, blue: 50, alpha: 0.5)
        static let tabBarItemSelected = UIColor(red: 0, green: 0, blue: 50, alpha: 0.7)
        
        static let segmentText = UIColor.white
        
        static let segmentBg = UIColor(red: 0, green: 0, blue: 50, alpha: 0.3)
        static let segmentBgSelected = UIColor(red: 0, green: 0, blue: 50, alpha: 0.6)

    }
    
    struct Image {
        static let sort = UIImage(named: "sort_btn_ic")
        static let placeholderImage = UIImage(named: "placeholder_ic")
    }
}
