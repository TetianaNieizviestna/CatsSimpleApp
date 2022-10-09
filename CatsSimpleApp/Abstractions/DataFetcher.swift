//
//  DataFetcher.swift
//  CatsSimpleApp
//
//  Created by Tetiana Nieizviestna
//

import Foundation

typealias Fetcher<Request: RsRequest> = (
    _ request: Request,
    _ completion: @escaping (Result<Request.Response, Error>) -> Void
    ) -> Void

protocol DataFetcher {
    func send<Request: RsRequest>(
        _ request: Request,
        completion: @escaping (Result<Request.Response, Error>) -> Void
    )
}
