//
//  PhotoDetailsCoordinator.swift
//  CatsSimpleApp
//
//  Created by Tetiana Nieizviestna 
//

import UIKit

protocol PhotoDetailsCoordinatorType {
    func dismiss()
    func onBreedDetails(_ breed: Breed)
}

final class PhotoDetailsCoordinator: PhotoDetailsCoordinatorType {
    weak var controller: PhotoDetailsViewController? = Storyboard.photoDetails.instantiateViewController()
    private let navigationController: UINavigationController?
    private var serviceHolder: ServiceHolder!
        
    init(navigationController: UINavigationController?, serviceHolder: ServiceHolder, id: String) {
        self.navigationController = navigationController
        self.navigationController?.navigationBar.isTranslucent = true
        self.serviceHolder = serviceHolder

        controller?.viewModel = PhotoDetailsViewModel(self, serviceHolder: self.serviceHolder, id: id)
    }
    
    func start() {
        if let controller = controller {
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func dismiss() {
        navigationController?.popViewController(animated: true)
    }
    
    func onBreedDetails(_ breed: Breed) {
        let coordinator = BreedDetailsCoordinator(navigationController: navigationController, serviceHolder: serviceHolder, breed: breed)
        coordinator.start()
    }
}
