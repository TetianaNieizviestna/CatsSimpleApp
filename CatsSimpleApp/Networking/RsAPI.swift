//
//  RsAPI.swift
//  RocketsSchedule
//
//  Created by Tetiana Nieizviestna
//

import Foundation

extension RsAPI: DataFetcher {}

typealias Completion<Request: RsRequest> = (Result<Request.Response, Error>) -> Void

final class RsAPI {
    
    private let client: HTTPClient

    init(session: URLSession = URLSession.shared) {
        self.client = .init(session: session)
    }

    func send<Request: RsRequest>(
        _ request: Request,
        completion: @escaping Completion<Request>
    ) {
        client.send(
            request,
            requestBuilder:  { try request.buildURLRequest() },
            completion: completion
        )
    }
}

func printResponse(data: Data) {
    let str = String(decoding: data, as: UTF8.self)
    debugPrint("Data: \(str)")
}
