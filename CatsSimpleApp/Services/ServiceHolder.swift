//
//  ServiceHolder.swift
//  CatsSimpleApp
//

import Foundation

@MainActor
final class AppServices {
    let breedsLoader: BreedsLoaderType
    let photosLoader: PhotosLoaderType

    init(api: CatAPIType = CatAPI()) {
        self.breedsLoader = BreedsLoader(api: api)
        self.photosLoader = PhotosLoader(api: api)
    }
}
