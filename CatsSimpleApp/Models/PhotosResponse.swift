//
//  PhotosResponse.swift
//  CatsSimpleApp
//

import Foundation

struct Pagination {
    let limit: Int = 10
    var page: Int = 0
    var needMore: Bool = true

    mutating func increment() {
        page += 1
    }
    mutating func reset() {
        page = 0
        needMore = true
    }
    mutating func stopLoading() {
        needMore = false
    }
}

struct Photo: Codable, Hashable, Identifiable {
    let id: String
    let url: String
    let breeds: [Breed]?

    static func == (lhs: Photo, rhs: Photo) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
