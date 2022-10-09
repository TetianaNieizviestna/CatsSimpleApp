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

//enum SortingType: String {
//    case ascending = "ASC"
//    case descending = "DESC"
//    case random = "RAND"
//
//    var title: String {
//        switch self {
//        case .ascending:
//            return "Ascending"
//        case .descending:
//            return "Descending"
//        case .random:
//            return "Random"
//        }
//    }
//
//    static let all: [SortingType] = [.ascending, .descending, .random]
//}

protocol BreedsListViewModelType {
    var stateSubscriber: PassthroughSubject<BreedsListViewController.Props, Never> { get }
//    var diffableDataSource: PhotosTableViewDiffableDataSource! { get }
//    var snapshot: NSDiffableDataSourceSnapshot<String?, PhotoTableViewCell.Props> { get }

}

final class BreedsListViewModel: BreedsListViewModelType {
    var stateSubscriber = PassthroughSubject<BreedsListViewController.Props, Never>()
    
//    var diffableDataSource: PhotosTableViewDiffableDataSource!
//    var snapshot = NSDiffableDataSourceSnapshot<String?, PhotoTableViewCell.Props>()

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
    
    private func filter(by searchText: String) {
        searchQuery = searchText
        updateProps()
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
            onSearch: CommandWith { [weak self] text in
                self?.filter(by: text)
            },
            onChangeSorting: CommandWith { [weak self] type in
                self?.selectedSortType = type
            }
        )
        
        stateSubscriber.send(props)
    }
}
