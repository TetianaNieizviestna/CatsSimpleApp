//
//  AppCoordinator.swift
//  RocketsSchedule
//
//  Created by Tetiana Nieizviestna 
//

import Foundation
import UIKit

final class AppCoordinator {
    private var navigationController: UINavigationController?
    private let window: UIWindow
    
    private var serviceHolder: ServiceHolder!

    private var launchesService: PhotosLoader!

    private var startCoordinator: PhotosListCoordinatorType?

    init(window: UIWindow) {
        self.window = window
        
        startServices()
    }
    
    private func startServices() {
        serviceHolder = ServiceHolder()
        
        launchesService = PhotosLoader()
        
        serviceHolder.add(PhotosLoaderType.self, for: launchesService)
    }
    
    func start() {
        navigationController = UINavigationController()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        startCoordinator = PhotosListCoordinator(navigationController: navigationController, serviceHolder: serviceHolder)
        startCoordinator?.start()
    }
}
