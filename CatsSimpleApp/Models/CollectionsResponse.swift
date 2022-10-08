//
//  CollectionsResponse.swift
//  CatsSimpleApp
//
//  Created by Tetiana Nieizviestna
//

import Foundation

extension Collection: DecodableResponse {
    static func decode(data: Data, urlResponse: URLResponse) throws -> Collection {
        return try JSONDecoder().decode(Collection.self, from: data)
    }
}

typealias CollectionsResponse = [Collection]

// MARK: - Collection
struct Collection: Codable {
    let id: Int
    let title: String
    let collectionDescription: String?
    let publishedAt: String // Date
    let lastCollectedAt: String // Date
    let updatedAt: String // Date
    let totalPhotos: Int?
    let collectionPrivate: Bool = false
    let shareKey: String?
    let coverPhoto: CoverPhoto?
    let user: User?
    let links: CollectionLinks?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case collectionDescription = "description"
        case publishedAt = "published_at"
        case lastCollectedAt = "last_collected_at"
        case updatedAt = "updated_at"
        case totalPhotos = "total_photos"
        case collectionPrivate = "private"
        case shareKey = "share_key"
        case coverPhoto = "cover_photo"
        case user
        case links
    }
}

// MARK: - CoverPhoto
struct CoverPhoto: Codable {
    let id: String
    let width, height: Int
    let color: String
    let blurHash: String
    let likes: Int
    let likedByUser: Bool
    let coverPhotoDescription: String
    let user: User
    let urls: PhotoURLs
    let links: Links

    enum CodingKeys: String, CodingKey {
        case id, width, height, color
        case blurHash = "blur_hash"
        case likes
        case likedByUser = "liked_by_user"
        case coverPhotoDescription = "description"
        case user, urls, links
    }
}

// MARK: - User
struct User: Codable {
    let id, username, name: String
    let portfolioURL: String?
    let bio: String?
    let location: String?
    let totalLikes: Int = 0
    let totalPhotos: Int = 0
    let totalCollections: Int = 0
    let instagramUsername: String?
    let twitterUsername: String?
    let profileImage: ProfileImage
    let links: Links
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, username, name
        case portfolioURL = "portfolio_url"
        case bio, location
        case totalLikes = "total_likes"
        case totalPhotos = "total_photos"
        case totalCollections = "total_collections"
        case instagramUsername = "instagram_username"
        case twitterUsername = "twitter_username"
        case profileImage = "profile_image"
        case links
        case updatedAt = "updated_at"
    }
}

// MARK: - ProfileImage
struct ProfileImage: Codable {
    let small, medium, large: String
}

// MARK: - CollectionLinks
struct CollectionLinks: Codable {
    let linksSelf, html, photos, related: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, photos, related
    }
}

typealias Collections = [Collection]
