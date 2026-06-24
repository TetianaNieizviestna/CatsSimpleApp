//
//  RsAPIError.swift
//  CatsSimpleApp
//

import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case nonHTTPResponse
    case serverStatus(Int)
    case decoding(Error)
    case transport(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            "Invalid URL"
        case .nonHTTPResponse:
            "Invalid server response"
        case .serverStatus(let code):
            "Server error (\(code))"
        case .decoding:
            "Failed to read response"
        case .transport(let error):
            error.localizedDescription
        }
    }
}
