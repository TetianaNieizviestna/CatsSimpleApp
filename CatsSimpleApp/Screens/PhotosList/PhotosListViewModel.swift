//
//  PhotosListViewModel.swift
//  CatsSimpleApp
//

import Foundation

@Observable
@MainActor
final class PhotosListViewModel {
    enum State: Equatable {
        case initial
        case loading
        case loaded
        case failed(String)
    }

    private(set) var state: State = .initial
    private(set) var photos: [Photo] = []

    var sorting: SortingType = .random {
        didSet {
            guard sorting != oldValue else {
                return
            }
            Task {
                await refresh()
            }
        }
    }

    let breed: Breed?

    var title: String {
        breed?.name ?? "Cats"
    }

    private var pagination = Pagination()
    private let loader: PhotosLoaderType

    init(breed: Breed?, loader: PhotosLoaderType) {
        self.breed = breed
        self.loader = loader
    }

    func loadIfNeeded() async {
        guard state == .initial else {
            return
        }
        await load()
    }

    func refresh() async {
        pagination.reset()
        await load()
    }

    func loadNextPageIfNeeded(currentItem photo: Photo) async {
        guard let last = photos.last,
              last.id == photo.id,
              pagination.needMore,
              state != .loading else {
            return
        }
        pagination.increment()
        await load()
    }

    private func load() async {
        state = .loading
        do {
            let newPhotos = try await loader.loadPhotos(pagination: pagination, breedId: breed?.id)
            if pagination.page == 0 {
                photos = newPhotos
            } else {
                photos += newPhotos
            }
            if newPhotos.count < pagination.limit {
                pagination.stopLoading()
            }
            state = .loaded
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
