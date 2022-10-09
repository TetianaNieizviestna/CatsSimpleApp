//
//  AppCoordinator.swift
//  CatsSimpleApp
//
//  Created by Tetiana Nieizviestna 
//

import Foundation
import UIKit

final class AppCoordinator {
    private var navigationController: UINavigationController?
    private let window: UIWindow
    
    private var serviceHolder: ServiceHolder!

    private var photosService: PhotosLoader!
    private var breedsService: BreedsLoader!

//    private var startCoordinator: PhotosListCoordinatorType?
    private var startCoordinator: BreedsListCoordinatorType?

    init(window: UIWindow) {
        self.window = window
        
        startServices()
    }
    
    private func startServices() {
        serviceHolder = ServiceHolder()
        
        photosService = PhotosLoader()
        breedsService = BreedsLoader()

        serviceHolder.add(PhotosLoaderType.self, for: photosService)
        serviceHolder.add(BreedsLoaderType.self, for: breedsService)
    }
    
    func start() {
        navigationController = UINavigationController()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
//        startCoordinator = PhotosListCoordinator(navigationController: navigationController, serviceHolder: serviceHolder)
        startCoordinator = BreedsListCoordinator(navigationController: navigationController, serviceHolder: serviceHolder)
        startCoordinator?.start()
    }
}
