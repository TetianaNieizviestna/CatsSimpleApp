//
//  HTTPClient.swift
//  CatsSimpleApp
//
//  Created by Tetiana Nieizviestna
//

import Foundation
import Combine

protocol URLHTTPTask {
    func resume()
    func cancel()
}

protocol URLHTTPSession {
    @discardableResult
    func send(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLHTTPTask
}

extension URLSession: URLHTTPSession {
    @discardableResult
    func send(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLHTTPTask {
        let task = self.dataTask(with: request, completionHandler: completion)
        return task
    }
}

extension URLSessionDataTask: URLHTTPTask { }

class HTTPClient {
    private let session: URLSession
    private var cancellable: AnyCancellable?

    init(session: URLSession) {
        self.session = session
    }
    
    func send<Request: RsRequest>(
        _ request: Request,
        requestBuilder: Request.URLRequestBuilder,
        completion: @escaping Completion<Request>
    ) {
        let urlRequest: URLRequest
        do {
            urlRequest = try requestBuilder()
        } catch let error as HTTPRequestError {
            completion(.failure(error))
            return
        } catch {
            completion(.failure(HTTPRequestError.requestError(error)))
            return
        }
        
        cancellable = session.dataTaskPublisher(for: urlRequest)
            .map {
                printResponse(data: $0.data)
                return $0.data
            }
            .decode(type: Request.Response.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
            .sink(receiveCompletion: { resultCompletion in
                switch resultCompletion {
                case .finished:
                    break
                case .failure(let error):
                    completion(.failure(HTTPRequestError.requestError(error)))
                }
            }, receiveValue: { response in
                completion(.success(response))
            })
    }
}
