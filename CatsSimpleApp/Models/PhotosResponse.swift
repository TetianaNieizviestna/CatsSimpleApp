//
//  PhotosResponse.swift
//  CatsSimpleApp
//
//  Created by Tetiana Nieizviestna
//

import Foundation

struct Pagination {
    let limit: Int = 10
    var page: Int = 0
    
    mutating func increment() {
        page += 1
    }
    
    mutating func reset() {
        page = 0
    }
}

extension Photo: DecodableResponse {
    static func decode(data: Data, urlResponse: URLResponse) throws -> Photo {
        return try JSONDecoder().decode(Photo.self, from: data)
    }
}

typealias PhotosResponse = [Photo]

struct PhotoURLs: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

struct Photo: Codable {
    let id: String
    let url: String
    let breeds: [Breed]
    
    enum CodingKeys: String, CodingKey {
        case id
        case url
        case breeds
    }
    
    static let initial: Photo = .init(
        id: "",
        url: "",
        breeds: []
    )
}

struct Breed: Codable {
    let id: String
    let name: String
}