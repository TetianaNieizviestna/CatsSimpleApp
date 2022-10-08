//
//  GetCollectionDetailsRequest.swift
//  RocketsSchedule
//
//  Created by Tetiana Nieizviestna
//

import Foundation

final class GetCollectionDetailsRequest: RsRequest {
    typealias Response = Collection
        
    let method: HTTPMethod = .get
    let rsPath: RsPath
    
    init(id: String) {
        rsPath = .collection(id: id)
    }
}
