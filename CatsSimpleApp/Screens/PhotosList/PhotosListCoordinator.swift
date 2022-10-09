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
    func onBack()
}

final class PhotosListCoordinator: PhotosListCoordinatorType {
    weak var controller: PhotosListViewController? = Storyboard.photosList.instantiateViewController()
    private let navigationController: UINavigationController?
    private var serviceHolder: ServiceHolder!
    
    init(navigationController: UINavigationController?, serviceHolder: ServiceHolder, breed: Breed?) {
        self.navigationController = navigationController
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.isHidden = true
        
        self.serviceHolder = serviceHolder
        controller?.viewModel = PhotosListViewModel(self, serviceHolder: serviceHolder, breed: breed)
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
    
    func onBack() {
        navigationController?.popViewController(animated: true)
    }
}

