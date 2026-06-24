//
//  BreedsListViewModel.swift
//  CatsSimpleApp
//

import Foundation

@Observable
@MainActor
final class BreedsListViewModel {
    enum State: Equatable {
        case initial
        case loading
        case loaded
        case failed(String)
    }

    private(set) var state: State = .initial
    private(set) var breeds: [Breed] = []

    private var pagination = Pagination()
    private let loader: BreedsLoaderType
    private let router: AppRouter

    init(loader: BreedsLoaderType, router: AppRouter) {
        self.loader = loader
        self.router = router
    }

    func loadIfNeeded() async {
        guard state == .initial else { return }
        await load()
    }

    func refresh() async {
        pagination.reset()
        await load()
    }

    func loadNextPageIfNeeded(currentItem breed: Breed) async {
        guard let last = breeds.last, last.id == breed.id else { return }
        guard pagination.needMore, state != .loading else { return }
        pagination.increment()
        await load()
    }

    func openBreed(_ breed: Breed) { router.push(.breedDetails(breed)) }
    func openAllPhotos() { router.push(.photosList(breed: nil)) }

    private func load() async {
        state = .loading
        do {
            let newBreeds = try await loader.loadBreeds(pagination: pagination)
            if pagination.page == 0 {
                breeds = newBreeds
            } else {
                breeds += newBreeds
            }
            if newBreeds.count < pagination.limit {
                pagination.stopLoading()
            }
            state = .loaded
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
