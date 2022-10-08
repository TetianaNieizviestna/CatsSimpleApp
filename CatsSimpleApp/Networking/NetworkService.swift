//
//  ImageStorageService.swift
//  RocketsSchedule
//
//  Created by Tetiana Nieizviestna
//

import Foundation
import Combine

protocol NetworkProviderType: Service {
    func loadCollections(completion: CommandWith<Result<[Collection], Error>>)
    func loadCollectionDetails(id: String, completion: CommandWith<Result<Collection, Error>>)
    func loadPhotosByCollection(id: String, completion: CommandWith<Result<GetPhotosByCollectionRequest.Response, Error>>)
    func loadPhotos(pagination: Pagination, completion: CommandWith<Result<[Photo], Error>>)
    func loadPhoto(id: String, completion: CommandWith<Result<Photo, Error>>)
}

final class NetworkProvider: NetworkProviderType {
    private var fetcher: DataFetcher = RsAPI()

    func loadCollections(completion: CommandWith<Result<[Collection], Error>>) {
        let request = GetCollectionsRequest()
        
        fetcher.send(request) { result in
            completion.perform(with: result)
        }
    }
    
    func loadCollectionDetails(id: String, completion: CommandWith<Result<Collection, Error>>) {
        let request = GetCollectionDetailsRequest(id: id)

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
    
    func loadPhotosByCollection(id: String, completion: CommandWith<Result<GetPhotosByCollectionRequest.Response, Error>>) {
        let request = GetPhotosByCollectionRequest(id: id)
        
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
