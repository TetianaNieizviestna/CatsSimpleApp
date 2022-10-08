//
//  DataFetcher.swift
//  RocketsSchedule
//
//  Created by Тетяна Нєізвєстна on 01.07.2022.
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
