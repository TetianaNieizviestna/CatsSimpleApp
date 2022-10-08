//
//  GetPhotosRequest.swift
//  RocketsSchedule
//
//  Created by Tetiana Nieizviestna
//

import Foundation

final class GetPhotosRequest: RsRequest {
    typealias Response = PhotosResponse
        
    let method: HTTPMethod = .get
    let rsPath: RsPath = .photos
    let pagination: Pagination
    
    var queryParameters: [QueryParameter] {
        return [
            .init(key: "limit", value: "\(pagination.limit)"),
            .init(key: "page", value: "\(pagination.page)"),
        ]
    }
    
    init(pagination: Pagination) {
        self.pagination = pagination
    }
}
