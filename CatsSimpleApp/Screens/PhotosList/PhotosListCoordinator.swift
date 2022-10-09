//
//  PhotosListCoordinator.swift
//  CatsSimpleApp
//
//  Created by Tetiana Nieizviestna
//

import UIKit

protocol PhotosListCoordinatorType {
    func start()
    func onDetails(photoId: String)
}

final class PhotosListCoordinator: PhotosListCoordinatorType {
    weak var controller: PhotosListViewController? = Storyboard.photosList.instantiateViewController()
    private let navigationController: UINavigationController?
    private var serviceHolder: ServiceHolder!
    
    init(navigationController: UINavigationController?, serviceHolder: ServiceHolder) {
        self.navigationController = navigationController
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.isHidden = true
        
        self.serviceHolder = serviceHolder
        controller?.viewModel = PhotosListViewModel(self, serviceHolder: serviceHolder)
    }
    
    func start() {
        if let controller = controller {
            navigationController?.pushViewController(controller, animated: false)
        }
    }
    
    func onDetails(photoId: String) {
        let coordinator = PhotoDetailsCoordinator(
            navigationController: navigationController,
            serviceHolder: serviceHolder,
            id: photoId
        )
        coordinator.start()
    }
}

