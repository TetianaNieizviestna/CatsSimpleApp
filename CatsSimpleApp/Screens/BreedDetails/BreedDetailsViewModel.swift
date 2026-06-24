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
    private let router: AppRouter

    init(breed: Breed, router: AppRouter) {
        self.breed = breed
        self.router = router
    }

    var headerURL: URL? { URL(string: breed.image?.url ?? "") }
    var title: String { breed.name }
    var countryText: String { "\(breed.countryFlagSymbol) \(breed.origin)" }
    var isHypoallergenic: Bool { breed.hypoallergenic == 1 }
    var temperamentText: String? {
        breed.temperament.isEmpty ? nil : "Temperament:\n\(breed.temperament)"
    }

    var ratings: [(String, Int)] {
        var items: [(String, Int)] = []
        if let v = breed.affectionLevel { items.append(("Affection Level", v)) }
        if let v = breed.energyLevel { items.append(("Energy level", v)) }
        if let v = breed.grooming { items.append(("Grooming", v)) }
        if let v = breed.healthIssues { items.append(("Health Issues", v)) }
        if let v = breed.intelligence { items.append(("Intelligence", v)) }
        if let v = breed.sheddingLevel { items.append(("Shedding Level", v)) }
        if let v = breed.socialNeeds { items.append(("Social Needs", v)) }
        if let v = breed.vocalisation { items.append(("Vocalisation", v)) }
        return items
    }

    var links: [(LinkType, URL)] {
        var items: [(LinkType, URL)] = []
        if let s = breed.wikipediaURL, let url = URL(string: s) { items.append((.wikipedia, url)) }
        if let s = breed.cfaURL, let url = URL(string: s) { items.append((.cfa, url)) }
        if let s = breed.vetstreetURL, let url = URL(string: s) { items.append((.vetstreet, url)) }
        if let s = breed.vcahospitalsURL, let url = URL(string: s) { items.append((.vcaHospitals, url)) }
        return items
    }

    func openPhotos() { router.push(.photosList(breed: breed)) }
    func goBack() { router.pop() }
    func openURL(_ url: URL) { UIApplication.shared.open(url) }
}
