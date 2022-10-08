//
//  RsRequest.swift
//  RocketsSchedule
//
//  Created by Tetiana Nieizviestna
//

import Foundation

enum RsPath {
    case photos
    case collections
    case collection(id: String)
    case photosByCollection(id: String)
    case photo(id: String)
    
    var string: String {
        switch self {
        case .photos:
            return "/images/search"
        case .collections:
            return "/collections"
        case .collection(let id):
            return "/collections/\(id)"
        case .photosByCollection(let id):
            return "/collections/\(id)/photos"
        case .photo(let id):
            return "/images/\(id)"
        }
    }
}

protocol RsRequest: HTTPRequest {
    var rsPath: RsPath { get }
}

extension RsRequest {
    var path: String { return rsPath.string }
    var acceptType: AcceptType? {
        return .json
    }
}

extension RsRequest {
    var baseURL: URL { return Defines.API.baseUrl }
}

extension RsRequest where Response: DecodableResponse {
    func response(data: Data, urlResponse: HTTPURLResponse) throws -> Response {
        return try Response.decode(data: data, urlResponse: urlResponse)
    }
}

protocol DecodableResponse {
    static func decode(data: Data, urlResponse: URLResponse) throws -> Self
}

extension DecodableResponse where Self: Decodable {
    static func decode(data: Data, urlResponse: URLResponse) throws -> Self {
        return try JSONDecoder().decode(Self.self, from: data)
    }
}

extension RsRequest where Failure: DecodableFailure {
    func failure(data: Data, urlResponse: HTTPURLResponse) throws -> Failure {
        return try Failure.decode(data: data, urlResponse: urlResponse)
    }
}

protocol DecodableFailure {
    static func decode(data: Data, urlResponse: URLResponse) throws -> Self
}

extension DecodableFailure where Self: Decodable {
    static func decode(data: Data, urlResponse: URLResponse) throws -> Self {
        return try JSONDecoder().decode(Self.self, from: data)
    }
}

extension Array: DecodableResponse where Element: Decodable {
    static func decode(data: Data, urlResponse: URLResponse) throws -> [Element] {
        return try JSONDecoder().decode([Element].self, from: data)
    }
}

extension Result: DecodableResponse where Success: DecodableResponse, Failure: DecodableResponse {
    static func decode(data: Data, urlResponse: URLResponse) throws -> Result<Success, Failure> {
        let successParsingError: Error
        do {
            let success = try Success.decode(data: data, urlResponse: urlResponse)
            return .success(success)
        } catch {
            successParsingError = error
        }
        do {
            let failure = try Failure.decode(data: data, urlResponse: urlResponse)
            return .failure(failure)
        } catch {
            throw successParsingError
        }
    }
}
