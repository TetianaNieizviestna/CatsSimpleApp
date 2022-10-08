//
//  GetPhotoRequest.swift
//  CatsSimpleApp
//
//  Created by Tetiana Nieizviestna
//

import Foundation

final class GetPhotoRequest: RsRequest {
    typealias Response = Photo
        
    let method: HTTPMethod = .get
    let rsPath: RsPath
    
    init(id: String) {
        rsPath = .photo(id: id)
    }
}
