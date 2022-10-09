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
        return PhotoDetailsHeaderView.Props.init(
            url: URL(string: breed.image?.url ?? ""),
            didSelect: Command { [weak self] in
                guard let self = self else { return }
                self.coordinator.onPhotosList(breed: self.breed)
            }
        )
    }
    
    private func getItems() -> [BreedDetailsProps.Item] {
        var items: [BreedDetailsProps.Item] = []
        
        let tagsItem = BreedDetailsProps.Item.tags(
            .init(
                country: "\(breed.getCountryFlagSymbol()) \(breed.origin)",
                isHypoallergenic: breed.hypoallergenic == 1,
                onSelect: .nop
            )
        )
        items.append(tagsItem)
        
        let descriptionItem = BreedDetailsProps.Item.text(
            .init(
                text: breed.breedDescription,
                didSelect: .nop
            )
        )
        items.append(descriptionItem)

        if !breed.temperament.isEmpty {
            let temperamentItem = BreedDetailsProps.Item.text(
                .init(
                    text: "Temperament:\n\(breed.temperament)",
                    didSelect: .nop
                )
            )
            items.append(temperamentItem)
        }
        
        let rateItems = getRateItems()
        items.append(contentsOf: rateItems)
        
        let linkItems = getLinkItems()
        items.append(contentsOf: linkItems)
        
        return items
    }
    
    private func getRateItems() -> [BreedDetailsProps.Item] {
        var rateProps: [RateTableViewCell.Props] = []
        
        if let affectionLevel = breed.affectionLevel {
            let item = RateTableViewCell.Props(
                text: "Affection Level",
                starCount: affectionLevel,
                didSelect: .nop
            )
            rateProps.append(item)
        }
        
        if let energyLevel = breed.energyLevel {
            let item = RateTableViewCell.Props(
                text: "Energy level",
                starCount: energyLevel,
                didSelect: .nop
            )
            rateProps.append(item)
        }
        
        if let grooming = breed.grooming {
            let item = RateTableViewCell.Props(
                text: "Grooming",
                starCount: grooming,
                didSelect: .nop
            )
            rateProps.append(item)
        }
        
        if let healthIssues = breed.healthIssues {
            let item = RateTableViewCell.Props(
                text: "Health Issues",
                starCount: healthIssues,
                didSelect: .nop
            )
            rateProps.append(item)
        }
        
        if let intelligence = breed.intelligence {
            let item = RateTableViewCell.Props(
                text: "Intelligence",
                starCount: intelligence,
                didSelect: .nop
            )
            rateProps.append(item)
        }
        
        if let sheddingLevel = breed.sheddingLevel {
            let item = RateTableViewCell.Props(
                text: "Shedding Level",
                starCount: sheddingLevel,
                didSelect: .nop
            )
            rateProps.append(item)
        }
        
        if let socialNeeds = breed.socialNeeds {
            let item = RateTableViewCell.Props(
                text: "Social Needs",
                starCount: socialNeeds,
                didSelect: .nop
            )
            rateProps.append(item)
        }
        
        if let vocalisation = breed.vocalisation {
            let item = RateTableViewCell.Props(
                text: "Vocalisation",
                starCount: vocalisation,
                didSelect: .nop
            )
            rateProps.append(item)
        }
        
        return rateProps.map { .rate($0) }
    }
    
    private func getLinkItems() -> [BreedDetailsProps.Item] {
        var linkProps: [LinkTableViewCell.Props] = []
        
        if let wikipediaItem = breed.wikipediaURL {
            linkProps.append(.init(
                linkType: .wikipedia,
                didSelect: Command { [weak self] in
                    self?.coordinator.onUrl(wikipediaItem)
                }
            ))
        }
        
        if let cfaItem = breed.cfaURL {
            linkProps.append(.init(
                linkType: .cfa,
                didSelect: Command { [weak self] in
                    self?.coordinator.onUrl(cfaItem)
                }
            ))
        }
        
        if let vetstreetItem = breed.vetstreetURL {
            linkProps.append(.init(
                linkType: .vetstreet,
                didSelect: Command { [weak self] in
                    self?.coordinator.onUrl(vetstreetItem)
                }
            ))
        }
        
        if let vcaHospitalsItem = breed.vcahospitalsURL {
            linkProps.append(.init(
                linkType: .vcaHospitals,
                didSelect: Command { [weak self] in
                    self?.coordinator.onUrl(vcaHospitalsItem)
                }
            ))
        }
        
        return linkProps.map { .link($0) }
    }
}
