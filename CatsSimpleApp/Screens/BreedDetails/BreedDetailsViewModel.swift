//
//  BreedDetailsViewModel.swift
//  CatsSimpleApp
//

import Foundation
import UIKit

@Observable
@MainActor
final class BreedDetailsViewModel {
    let breed: Breed

    init(breed: Breed) {
        self.breed = breed
    }

    var headerURL: URL? {
        URL(string: breed.image?.url ?? "")
    }

    var title: String {
        breed.name
    }

    var countryText: String {
        "\(breed.countryFlagSymbol) \(breed.origin)"
    }

    var isHypoallergenic: Bool {
        breed.hypoallergenic == 1
    }

    var temperamentText: String? {
        breed.temperament.isEmpty ? nil : String(localized: "temperament \(breed.temperament)")
    }

    var ratings: [(String, Int)] {
        var items: [(String, Int)] = []
        if let value = breed.affectionLevel {
            items.append(("rating_affection_level".localized, value))
        }
        if let value = breed.energyLevel {
            items.append(("rating_energy_level".localized, value))
        }
        if let value = breed.grooming {
            items.append(("rating_grooming".localized, value))
        }
        if let value = breed.healthIssues {
            items.append(("rating_health_issues".localized, value))
        }
        if let value = breed.intelligence {
            items.append(("rating_intelligence".localized, value))
        }
        if let value = breed.sheddingLevel {
            items.append(("rating_shedding_level".localized, value))
        }
        if let value = breed.socialNeeds {
            items.append(("rating_social_needs".localized, value))
        }
        if let value = breed.vocalisation {
            items.append(("rating_vocalisation".localized, value))
        }
        return items
    }

    var links: [(LinkType, URL)] {
        var items: [(LinkType, URL)] = []
        if let url = breed.wikipediaURL?.asUrl() {
            items.append((.wikipedia, url))
        }
        if let url = breed.cfaURL?.asUrl() {
            items.append((.cfa, url))
        }
        if let url = breed.vetstreetURL?.asUrl() {
            items.append((.vetstreet, url))
        }
        if let url = breed.vcahospitalsURL?.asUrl() {
            items.append((.vcaHospitals, url))
        }
        return items
    }

    func openURL(_ url: URL) {
        UIApplication.shared.open(url)
    }
}
