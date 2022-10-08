//
//  Links.swift
//  RocketsSchedule
//
//  Created by Tetiana Nieizviestna
//

import Foundation

struct Links: Codable {
    let linksSelf: String?
    let html: String?
    let download: String?
    let downloadLocation: String?
    let photos: String?
    let likes: String?
    let portfolio: String?
    
    
    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html
        case download
        case downloadLocation = "download_location"
        case photos
        case likes
        case portfolio

    }
}
