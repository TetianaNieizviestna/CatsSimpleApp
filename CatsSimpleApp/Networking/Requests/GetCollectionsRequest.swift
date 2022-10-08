//
//  GetCollectionsRequest.swift
//  RocketsSchedule
//
//  Created by Tetiana Nieizviestna
//

final class GetCollectionsRequest: RsRequest {
    typealias Response = CollectionsResponse
    
    var method: HTTPMethod = .get
    var rsPath: RsPath = .collections
}
