//
//  PhotoDetailsViewModel.swift
//  CatsSimpleApp
//

import Foundation

@Observable
@MainActor
final class PhotoDetailsViewModel {
    enum State: Equatable {
        case initial
        case loading
        case loaded
        case failed(String)
    }

    private(set) var state: State = .initial
    private(set) var photo: Photo?

    let photoId: String
    private let loader: PhotosLoaderType

    init(photoId: String, loader: PhotosLoaderType) {
        self.photoId = photoId
        self.loader = loader
    }

    var imageURL: URL? {
        URL(string: photo?.url ?? "")
    }

    var breeds: [Breed] {
        photo?.breeds ?? []
    }

    func loadIfNeeded() async {
        guard state == .initial else {
            return
        }
        await load()
    }

    func refresh() async {
        await load()
    }

    private func load() async {
        state = .loading
        do {
            photo = try await loader.loadPhoto(id: photoId)
            state = .loaded
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
