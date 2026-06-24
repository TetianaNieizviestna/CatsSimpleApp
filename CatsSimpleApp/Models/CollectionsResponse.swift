//
//  CollectionsResponse.swift
//  CatsSimpleApp
//

import Foundation

struct Breed: Codable, Hashable, Identifiable {
    let id: String
    let name: String
    let image: Photo?
    let weight: Weight?

    let temperament: String
    let origin: String
    let countryCode: String
    let breedDescription: String
    let lifeSpan: String
    let indoor: Int?
    let lap: Int?
    let altNames: String?
    let affectionLevel: Int?
    let energyLevel: Int?
    let grooming: Int?
    let healthIssues: Int?
    let intelligence: Int?
    let sheddingLevel: Int?
    let socialNeeds: Int?
    let vocalisation: Int?
    let experimental: Int?
    let hairless: Int?
    let natural: Int?
    let rare: Int?
    let hypoallergenic: Int?
    let bidability: Int?
    let cfaURL: String?
    let vetstreetURL: String?
    let vcahospitalsURL: String?
    let wikipediaURL: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image
        case weight
        case temperament
        case origin
        case countryCode = "country_code"
        case breedDescription = "description"
        case lifeSpan = "life_span"
        case indoor
        case lap
        case altNames = "alt_names"
        case affectionLevel = "affection_level"
        case energyLevel = "energy_level"
        case grooming
        case healthIssues = "health_issues"
        case intelligence
        case sheddingLevel = "shedding_level"
        case socialNeeds = "social_needs"
        case vocalisation
        case experimental
        case hairless
        case natural
        case rare
        case hypoallergenic
        case bidability
        case cfaURL = "cfa_url"
        case vetstreetURL = "vetstreet_url"
        case vcahospitalsURL = "vcahospitals_url"
        case wikipediaURL = "wikipedia_url"
    }

    var countryFlagSymbol: String {
        countryCode
            .unicodeScalars
            .map { 127397 + $0.value }
            .compactMap(UnicodeScalar.init)
            .map(String.init)
            .joined()
    }

    static func == (lhs: Breed, rhs: Breed) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

struct Weight: Codable, Hashable {
    let imperial: String
    let metric: String
}
