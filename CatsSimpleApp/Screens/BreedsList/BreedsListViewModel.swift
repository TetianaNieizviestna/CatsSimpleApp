//
//  BreedsListViewModel.swift
//  CatsSimpleApp
//
//  Created by Tetiana Nieizviestna
//

import Foundation
import Combine
import UIKit

typealias BreedsListProps = BreedsListViewController.Props

protocol BreedsListViewModelType {
    var stateSubscriber: PassthroughSubject<BreedsListViewController.Props, Never> { get }
}

final class BreedsListViewModel: BreedsListViewModelType {
    var stateSubscriber = PassthroughSubject<BreedsListViewController.Props, Never>()

    private let coordinator: BreedsListCoordinatorType
    private var breedsLoader: BreedsLoaderType

    private var loadedBreeds: [Breed] = []
    private var pagination = Pagination()
    
    private var selectedSortType: SortingType = .random {
        didSet {
            refresh()
        }
    }
    
    private var screenState: BreedsListProps.ScreenState = .initial {
        didSet {
            updateProps()
        }
    }
    
    private var searchQuery: String?
        
    init(_ coordinator: BreedsListCoordinatorType, serviceHolder: ServiceHolder) {
        self.coordinator = coordinator
        
        breedsLoader = serviceHolder.get(by: BreedsLoaderType.self)
        loadPhotos()
    }
    
    private func setScreenState(_ state: BreedsListProps.ScreenState) {
        screenState = state
        updateProps()
    }
    
    private func loadPhotos() {
        setScreenState(.loading)
        
        breedsLoader.loadBreeds(
            pagination: pagination,
            onSuccess: CommandWith { [weak self] breeds in
                guard let self = self else { return }
                if self.pagination.page == .zero {
                    self.loadedBreeds = breeds
                } else {
                    self.loadedBreeds += breeds
                }
                if breeds.count < self.pagination.limit {
                    self.pagination.stopLoading()
                }
                self.setScreenState(.loaded)
            },
            onFailure: CommandWith { [weak self] error in
                self?.setScreenState(.failed(error))
            }
        )
    }
    
    private func loadNextPage() {
        if pagination.needMore {
            pagination.increment()
            loadPhotos()
        }
    }
    
    private func refresh() {
        pagination.reset()
        loadPhotos()
    }

    private func createItems() -> [BreedTableViewCell.Props] {
        return loadedBreeds.map { self.createCellProps($0) }
    }
    
    private func createCellProps(_ breedModel: Breed) -> BreedTableViewCell.Props {
        return .init(
            breed: breedModel,
            onSelect: Command { [weak self] in
                self?.coordinator.onBreedDetails(breedModel)
            }
        )
    }

    private func updateProps() {
        let props = BreedsListProps(
            state: screenState,
            items: createItems(),
            selectedSorting: selectedSortType,
            onRefresh: Command { [weak self] in
                self?.refresh()
            },
            onNextPage: Command { [weak self] in
                self?.loadNextPage()
            },
            onChangeSorting: CommandWith { [weak self] type in
                self?.selectedSortType = type
            }
        )
        
        stateSubscriber.send(props)
    }
}
