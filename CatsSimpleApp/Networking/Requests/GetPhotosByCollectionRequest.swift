//
//  GetCreGetPhotosByCollectionRequestwMemberRequest.swift
//  RocketsSchedule
//
//  Created by Tetiana Nieizviestna
//

import Foundation

final class GetPhotosByCollectionRequest: RsRequest {
    typealias Response = PhotosResponse
        
    let method: HTTPMethod = .get
    let rsPath: RsPath
    
    init(id: String) {
        rsPath = .photosByCollection(id: id)
    }
}
