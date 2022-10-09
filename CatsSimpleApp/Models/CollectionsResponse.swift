//
//  CollectionsResponse.swift
//  CatsSimpleApp
//
//  Created by Tetiana Nieizviestna
//

import Foundation

extension Breed: DecodableResponse {
    static func decode(data: Data, urlResponse: URLResponse) throws -> Breed {
        return try JSONDecoder().decode(Breed.self, from: data)
    }
}

typealias BreedsResponse = [Breed]

struct Breed: Codable {
    let id: String
    let name: String
    let image: Photo?
    let weight: Weight?
    
    let temperament: String
    let origin: String
    let countryCode: String
    let breedDescription: String
    let lifeSpan: String
    let indoor: Int
    let lap: Int?
    let altNames: String?
    let energyLevel: Int
    let grooming: Int
    let healthIssues: Int
    let intelligence: Int
    let sheddingLevel: Int
    let socialNeeds: Int
    let strangerFriendly: Int
    let vocalisation: Int
    let experimental: Int
    let hairless: Int
    let natural: Int
    let rare: Int
    let hypoallergenic: Int
    let catFriendly: Int?
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
        case energyLevel = "energy_level"
        case grooming
        case healthIssues = "health_issues"
        case intelligence
        case sheddingLevel = "shedding_level"
        case socialNeeds = "social_needs"
        case strangerFriendly = "stranger_friendly"
        case vocalisation
        case experimental
        case hairless
        case natural
        case rare
        case hypoallergenic
        case catFriendly = "cat_friendly"
        case bidability
        case cfaURL = "cfa_url"
        case vetstreetURL = "vetstreet_url"
        case vcahospitalsURL = "vcahospitals_url"
        case wikipediaURL = "wikipedia_url"
    }
    
    static let initial: Breed = .init(
        id: "",
        name: "",
        image: nil,
        weight: nil,
        temperament: "",
        origin: "",
        countryCode: "",
        breedDescription: "",
        lifeSpan: "",
        indoor: 0,
        lap: nil,
        altNames: nil,
        energyLevel: 0,
        grooming: 0,
        healthIssues: 0,
        intelligence: 0,
        sheddingLevel: 0,
        socialNeeds: 0,
        strangerFriendly: 0,
        vocalisation: 0,
        experimental: 0,
        hairless: 0,
        natural: 0,
        rare: 0,
        hypoallergenic: 0,
        catFriendly: nil,
        bidability: nil,
        cfaURL: nil,
        vetstreetURL: nil,
        vcahospitalsURL: nil,
        wikipediaURL: nil
    )
    
    func getCountryFlagSymbol() -> String {
        return countryCode
            .unicodeScalars
            .map({ 127397 + $0.value })
            .compactMap(UnicodeScalar.init)
            .map(String.init)
            .joined()
    }
}

// MARK: - Weight
struct Weight: Codable {
    let imperial: String
    let metric: String
}
