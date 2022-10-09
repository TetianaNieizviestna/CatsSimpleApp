//
//  BreedsListCoordinator.swift
//  CatsSimpleApp
//
//  Created by Tetiana Nieizviestna
//

import UIKit

protocol BreedsListCoordinatorType {
    func start()
    func onBreedDetails(_ breed: Breed)
    func dismiss()
}

final class BreedsListCoordinator: BreedsListCoordinatorType {
    weak var controller: BreedsListViewController? = Storyboard.breedsList.instantiateViewController()
    private let navigationController: UINavigationController?
    private var serviceHolder: ServiceHolder!
    
    init(navigationController: UINavigationController?, serviceHolder: ServiceHolder) {
        self.navigationController = navigationController
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.isHidden = true
        
        self.serviceHolder = serviceHolder
        controller?.viewModel = BreedsListViewModel(self, serviceHolder: serviceHolder)
    }
    
    func start() {
        if let controller = controller {
            navigationController?.pushViewController(controller, animated: false)
        }
    }
    
    func onBreedDetails(_ breed: Breed) {
        let coordinator = BreedDetailsCoordinator(
            navigationController: navigationController,
            serviceHolder: serviceHolder,
            breed: breed
        )
        coordinator.start()
    }
    
    func dismiss() {
        navigationController?.popViewController(animated: true)
    }
}

