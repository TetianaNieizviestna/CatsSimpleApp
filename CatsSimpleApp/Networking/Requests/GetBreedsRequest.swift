//
//  GetBreedsRequest.swift
//  CatsSimpleApp
//
//  Created by Tetiana Nieizviestna
//

final class GetBreedsRequest: RsRequest {
    typealias Response = BreedsResponse
    
    var method: HTTPMethod = .get
    var rsPath: RsPath = .breeds
    private let pagination: Pagination
    
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
