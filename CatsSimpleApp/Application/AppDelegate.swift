//
//  AppDelegate.swift
//  CatsSimpleApp
//
//  Created by Tetiana Nieizviestna
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let window = UIWindow(frame: UIScreen.main.bounds)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window.overrideUserInterfaceStyle = .light
        
        let appCoordinator = AppCoordinator(window: window)
        appCoordinator.start()

        return true
    }
    
}

