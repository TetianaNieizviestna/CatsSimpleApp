//
//  RsAPIError.swift
//  CatsSimpleApp
//
//  Created by Tetiana Nieizviestna
//

import Foundation

struct RsAPIError: Error, Decodable, LocalizedError {
    static let mapError = RsAPIError(
        message: "Incorrect data",
        code: -100
    )
    
    static let serverError = RsAPIError(
        message: "Server error",
        code: -200
    )
    static let someError = RsAPIError(
        message: "Something Wrong",
        code: -300
    )
    static let badInternetError = RsAPIError(
        message: "No internet connection",
        code: -400
    )
    
    let message: String
    let code: Int
    
    var errorDescription: String? {
        return message
    }
    
    var localizedDescription: String {
        return message
    }
}
