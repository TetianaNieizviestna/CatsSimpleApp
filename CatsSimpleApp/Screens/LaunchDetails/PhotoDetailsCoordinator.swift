//
//  PhotoDetailsCoordinator.swift
//  RocketsSchedule
//
//  Created by Tetiana Nieizviestna 
//

import UIKit

protocol PhotoDetailsCoordinatorType {
    func dismiss()
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
            controller.modalTransitionStyle = .coverVertical
            controller.modalPresentationStyle = .overFullScreen
            navigationController?.present(controller, animated: true, completion: nil)
        }
    }
    
    func dismiss() {
        self.controller?.dismiss(animated: false) 
    }
}
