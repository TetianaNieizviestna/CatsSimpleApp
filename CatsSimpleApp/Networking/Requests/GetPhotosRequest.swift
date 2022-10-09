//
//  GetPhotosRequest.swift
//  CatsSimpleApp
//
//  Created by Tetiana Nieizviestna
//

import Foundation

final class GetPhotosRequest: RsRequest {
    typealias Response = PhotosResponse
        
    let method: HTTPMethod = .get
    let rsPath: RsPath = .photos
    
    private let pagination: Pagination
    private let breedId: String?
    
    var queryParameters: [QueryParameter] {
        var parameters: [QueryParameter] = [
            .init(key: "limit", value: "\(pagination.limit)"),
            .init(key: "page", value: "\(pagination.page)"),
        ]
        
        if let breedId = breedId {
            parameters.append(.init(key: "breed_id", value: breedId))
        }
        return parameters
    }
    
    init(pagination: Pagination, breedId: String?) {
        self.pagination = pagination
        self.breedId = breedId
    }
}
