//
//  BreedsLoader.swift
//  CatsSimpleApp
//
//  Created by Tetiana Nieizviestna
//

import Foundation
import Combine

protocol BreedsLoaderType: Service {
    func loadBreeds(pagination: Pagination, onSuccess: CommandWith<[Breed]>, onFailure: CommandWith<String>)
}

final class BreedsLoader: BreedsLoaderType {
    private var networkProvider: NetworkProviderType
    private var cancellable: AnyCancellable?
        
    init() {
        networkProvider = NetworkProvider()
    }
    
    func loadBreeds(pagination: Pagination, onSuccess: CommandWith<[Breed]>, onFailure: CommandWith<String>) {
        networkProvider.loadBreeds(
            pagination: pagination,
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
}
