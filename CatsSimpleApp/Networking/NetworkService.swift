//
//  ImageStorageService.swift
//  CatsSimpleApp
//
//  Created by Tetiana Nieizviestna
//

import Foundation
import Combine

protocol NetworkProviderType: Service {
    func loadBreeds(pagination: Pagination, completion: CommandWith<Result<[Breed], Error>>)
    func loadPhotos(pagination: Pagination, completion: CommandWith<Result<[Photo], Error>>)
    func loadPhoto(id: String, completion: CommandWith<Result<Photo, Error>>)
}

final class NetworkProvider: NetworkProviderType {
    private var fetcher: DataFetcher = RsAPI()

    func loadBreeds(pagination: Pagination, completion: CommandWith<Result<[Breed], Error>>) {
        let request = GetBreedsRequest(pagination: pagination)
        
        fetcher.send(request) { result in
            completion.perform(with: result)
        }
    }
    
    func loadPhotos(pagination: Pagination, completion: CommandWith<Result<[Photo], Error>>) {
        let request = GetPhotosRequest(pagination: pagination)

        fetcher.send(request) { result in
            completion.perform(with: result)
        }
    }
        
    func loadPhoto(id: String, completion: CommandWith<Result<Photo, Error>>) {
        let request = GetPhotoRequest(id: id)
        
        fetcher.send(request) { result in
            completion.perform(with: result)
        }
    }
}
