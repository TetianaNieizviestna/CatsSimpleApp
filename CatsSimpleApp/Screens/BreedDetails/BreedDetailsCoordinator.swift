//
//  BreedDetailsCoordinator.swift
//  CatsSimpleApp
//
//  Created by Тетяна Нєізвєстна on 09.10.2022.
//

import UIKit

protocol BreedDetailsCoordinatorType {
    func dismiss()
    func onPhotosList(breed: Breed?)
    func onPhoto(_ photo: Photo)
    func onUrl(_ urlString: String)
}

final class BreedDetailsCoordinator: BreedDetailsCoordinatorType {
    weak var controller: BreedDetailsViewController? = Storyboard.breedDetails.instantiateViewController()
    private let navigationController: UINavigationController?
    private var serviceHolder: ServiceHolder!
        
    init(navigationController: UINavigationController?, serviceHolder: ServiceHolder, breed: Breed) {
        self.navigationController = navigationController
        self.navigationController?.navigationBar.isTranslucent = true
        self.serviceHolder = serviceHolder

        controller?.viewModel = BreedDetailsViewModel(self, serviceHolder: self.serviceHolder, breed: breed)
    }
    
    func start() {
        if let controller = controller {
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func dismiss() {
        navigationController?.popViewController(animated: false)
    }
    
    func onPhoto(_ photo: Photo) {
        let coordinator = PhotoDetailsCoordinator(navigationController: navigationController, serviceHolder: serviceHolder, id: photo.id)
        coordinator.start()
    }
    
    func onPhotosList(breed: Breed?) {
        let coordinator = PhotosListCoordinator(navigationController: navigationController, serviceHolder: serviceHolder, breed: breed)
        coordinator.start()
    }
    
    func onUrl(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        UIApplication.shared.open(url)
    }
}
