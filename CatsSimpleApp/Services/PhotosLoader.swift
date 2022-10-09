//
//  PhotosLoader.swift
//  CatsSimpleApp
//
//  Created by Tetiana Nieizviestna
//

import Foundation
import Combine

protocol PhotosLoaderType: Service {
    func loadPhotos(pagination: Pagination, breedId: String?, onSuccess: CommandWith<[Photo]>, onFailure: CommandWith<String>)
    func loadPhotoDetails(id: String, onSuccess: CommandWith<Photo>, onFailure: CommandWith<String>)
}

final class PhotosLoader: PhotosLoaderType {
    private var networkProvider: NetworkProviderType
    private var cancellable: AnyCancellable?
    
    private var photos = [Photo]()
    
    init() {
        networkProvider = NetworkProvider()
    }
    
    func loadPhotos(pagination: Pagination, breedId: String?, onSuccess: CommandWith<[Photo]>, onFailure: CommandWith<String>) {
        networkProvider.loadPhotos(
            pagination: pagination,
            breedId: breedId,
            completion: CommandWith { result in
                switch result {
                case .success(let data):
                    onSuccess.perform(with: data.map { $0 })
                case .failure(let error):
                    onFailure.perform(with: error.localizedDescription)
                }
            }
        )
    }

    func loadPhotoDetails(id: String, onSuccess: CommandWith<Photo>, onFailure: CommandWith<String>) {
        networkProvider.loadPhoto(
            id: id,
            completion: CommandWith { result in
                switch result {
                case .success(let data):
                    onSuccess.perform(with: data)
                case .failure(let error):
                    onFailure.perform(with: error.localizedDescription)
                }
            }
        )
    }
}
