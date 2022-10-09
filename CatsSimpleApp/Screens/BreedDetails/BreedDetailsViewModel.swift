//
//  BreedDetailsViewModel.swift
//  CatsSimpleApp
//
//  Created by Тетяна Нєізвєстна on 09.10.2022.
//

import Foundation
import UIKit
import Combine

typealias BreedDetailsProps = BreedDetailsViewController.Props

protocol BreedDetailsViewModelType {
    func getProps() -> BreedDetailsProps

}

final class BreedDetailsViewModel: BreedDetailsViewModelType{
    var stateSubscriber = PassthroughSubject<BreedDetailsProps, Never>()

    private let coordinator: BreedDetailsCoordinatorType
    
    private var breed: Breed
    
    init(_ coordinator: BreedDetailsCoordinatorType, serviceHolder: ServiceHolder, breed: Breed) {
        self.coordinator = coordinator
        
        self.breed = breed
    }
    
    func getProps() -> BreedDetailsProps {
        return .init(
            title: breed.name,
            header: getHeaderItem(),
            items: getItems(),
            onBack: Command { [weak self] in
                self?.coordinator.dismiss()
            },
            onPhoto: CommandWith { [weak self] photo in
                self?.coordinator.onPhoto(photo)
            },
            onUrl: CommandWith { [weak self] url in
                self?.coordinator.onUrl(url)
            }
        )
    }
}

// MARK: Props creation
extension BreedDetailsViewModel {
    private func getHeaderItem() -> PhotoDetailsHeaderView.Props {
        return PhotoDetailsHeaderView.Props.init(url: URL(string: breed.image?.url ?? ""), didSelect: .nop)
    }
    
    private func getItems() -> [BreedDetailsProps.Item] {
        var items: [BreedDetailsProps.Item] = []
        
//        let tagsItem = BreedDetailsProps.Item.tags()
        
        let descriptionItem = BreedDetailsProps.Item.text(
            .init(
                text: breed.breedDescription,
                didSelect: .nop
            )
        )
        items.append(descriptionItem)
        
        return items
    }
}
