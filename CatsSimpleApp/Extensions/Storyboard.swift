//
//  Storyboard.swift
//  RocketsSchedule
//
//  Created by Tetiana Nieizviestna 
//

import UIKit

struct Storyboard {
    static let photosList = UIStoryboard(name: "PhotosList", bundle: nil)
    static let photoDetails = UIStoryboard(name: "PhotoDetails", bundle: nil)
}

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self.self)
    }
}

extension UIStoryboard {
    func instantiateViewController<T: StoryboardIdentifiable>() -> T? {
        return instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T
    }
}

extension UIViewController: StoryboardIdentifiable { }
