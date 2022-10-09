//
//  HTTPRequest.swift
//  CatsSimpleApp
//
//  Created by Tetiana Nieizviestna
//

import Foundation

enum HTTPRequestError: Error {
    case invalidBaseURL(URL)
    case requestError(Error)
    case responseError(Error)
    case nonHTTPResponse(URLResponse?)
    case notMapError
    case someError
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum ContentType: String {
    case json = "application/json"
    case formData = "multipart/from-data"
}

enum AcceptType: String {
    case json = "application/json"
    case urlencoded = "application/x-www-form-urlencoded"
    case formData = "multipart/form-data"
}

struct QueryParameter {
    let key: String
    let value: String
}

protocol HTTPRequest {
    associatedtype Response: Decodable
    associatedtype Failure: Error
    typealias URLRequestBuilder = () throws -> URLRequest
    
    var baseURL: URL { get }
    
    var method: HTTPMethod { get }
    
    var path: String { get }
    
    var queryParameters: [QueryParameter] { get }
    
    var bodyParameters: [String: Any] { get }
    
    var contentType: ContentType { get }
    
    var acceptType: AcceptType? { get }
    
    var headerFields: [String: String] { get }
    
    func response(data: Data, urlResponse: HTTPURLResponse) throws -> Response
    func failure(data: Data, urlResponse: HTTPURLResponse) throws -> Failure
}

struct HTTPRequestAuth {
    let key: String
    let value: String
}

extension HTTPRequest {
    func failure(data: Data, urlResponse: HTTPURLResponse) throws -> RsAPIError {
        return try JSONDecoder().decode(RsAPIError.self, from: data)
    }
}

extension HTTPRequest {
    var parameters: Any? {
        return nil
    }
    
    var queryParameters: [QueryParameter] {
        return []
    }
    
    var bodyParameters: [String: Any] {
        return [:]
    }
    
    var contentType: ContentType {
        return .json
    }
    
    var acceptType: AcceptType? {
        return nil
    }
    
    var headerFields: [String: String] {
        return [
                 "x-api-key": "\(Defines.API.accessKey)"
        ]
    }
    
    func buildURLRequest(_ auth: HTTPRequestAuth? = nil) throws -> URLRequest {
        let url = path.isEmpty ? baseURL : baseURL.appendingPathComponent(path)
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            throw HTTPRequestError.invalidBaseURL(baseURL)
        }
        
        var urlRequest = URLRequest(url: url)
        
        if !queryParameters.isEmpty {
            components.queryItems = queryParameters.map { .init(name: $0.key, value: $0.value) }
        }
        
        if method == .post || method == .put || method == .patch {
            urlRequest.setValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
        }
        
        if !bodyParameters.isEmpty {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: bodyParameters, options: [])
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        urlRequest.url = components.url
        urlRequest.httpMethod = method.rawValue
        
        if let acceptType = acceptType {
            urlRequest.setValue(acceptType.rawValue, forHTTPHeaderField: "Accept")
        }
        
        headerFields.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
            
        if let auth = auth { urlRequest.setValue(auth.value, forHTTPHeaderField: auth.key) }
        
        return urlRequest
    }
    
    func buildMultipartURLRequest(_ auth: HTTPRequestAuth?) throws -> URLRequest {
        let url = path.isEmpty ? baseURL : baseURL.appendingPathComponent(path)
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            throw HTTPRequestError.invalidBaseURL(baseURL)
        }
        
        var urlRequest = URLRequest(url: url)
        
        if !queryParameters.isEmpty {
            components.queryItems = queryParameters.map { .init(name: $0.key, value: $0.value) }
        }
        
        let boundary = generateBoundaryString()
        var body = Data()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        let append: (String) -> Void = { $0.data(using: .utf8).do { body.append($0) } }
        
        for (key, value) in bodyParameters {
            if let data = value as? Data {
                let fname = "\(key).jpg"
                let mimetype = "image/jpg"
                
                //define the data post parameter
                append(boundaryPrefix)
                append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(fname)\"\r\n")
                append("Content-Type: \(mimetype)\r\n\r\n")
                
                body.append(data)
                
                append("\r\n")
                append("--\(boundary)\r\n")
            } else {
                append(boundaryPrefix)
                append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                append("\(value)\r\n")
            }
        }
        
        urlRequest.httpBody = body
        
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(String(body.count), forHTTPHeaderField: "Content-Length")
        
        urlRequest.url = components.url
        urlRequest.httpMethod = method.rawValue
        
        if let acceptType = acceptType {
            urlRequest.setValue(acceptType.rawValue, forHTTPHeaderField: "Accept")
        }
        
        headerFields.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        if let auth = auth { urlRequest.setValue(auth.value, forHTTPHeaderField: auth.key) }
        
        return urlRequest
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
}
