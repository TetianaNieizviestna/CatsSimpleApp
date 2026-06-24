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
        case .invalidURL: return "Invalid URL"
        case .nonHTTPResponse: return "Invalid server response"
        case .serverStatus(let code): return "Server error (\(code))"
        case .decoding: return "Failed to read response"
        case .transport(let error): return error.localizedDescription
        }
    }
}
