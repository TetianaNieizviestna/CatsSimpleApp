//
//  LaunchListViewModel.swift
//  RocketsSchedule
//
//  Created by Tetiana Nieizviestna
//

import Foundation
import Combine
import UIKit

typealias PhotosListProps = PhotosListViewController.Props

enum SortingType: String {
    case ascending = "ASC"
    case descending = "DESC"
    case random = "RAND"
    
    var title: String {
        switch self {
        case .ascending:
            return "Ascending"
        case .descending:
            return "Descending"
        case .random:
            return "Random"
        }
    }
    
    static let all: [SortingType] = [.ascending, .descending, .random]
}

protocol PhotosListViewModelType {
    var stateSubscriber: PassthroughSubject<PhotosListViewController.Props, Never> { get }
    var diffableDataSource: PhotosTableViewDiffableDataSource! { get }
    var snapshot: NSDiffableDataSourceSnapshot<String?, PhotoTableViewCell.Props> { get }

}

final class PhotosListViewModel: PhotosListViewModelType {
    var stateSubscriber = PassthroughSubject<PhotosListViewController.Props, Never>()
    
    var diffableDataSource: PhotosTableViewDiffableDataSource!
    var snapshot = NSDiffableDataSourceSnapshot<String?, PhotoTableViewCell.Props>()

    private let coordinator: PhotosListCoordinatorType
    private var photosLoader: PhotosLoaderType

    private var loadedPhotos: [Photo] = []
    private var pagination = Pagination()
    
    private var selectedSortType: SortingType = .random {
        didSet {
            refresh()
        }
    }
    
    private var screenState: PhotosListProps.ScreenState = .initial {
        didSet {
            updateProps()
        }
    }
    
    private var searchQuery: String?
        
    init(_ coordinator: PhotosListCoordinatorType, serviceHolder: ServiceHolder) {
        self.coordinator = coordinator
        
        photosLoader = serviceHolder.get(by: PhotosLoaderType.self)
        loadPhotos()
    }
    
    private func setScreenState(_ state: PhotosListProps.ScreenState) {
        screenState = state
        updateProps()
    }
    
    private func loadPhotos() {
        setScreenState(.loading)
        
        photosLoader.loadPhotos(
            pagination: pagination,
            onSuccess: CommandWith { [weak self] photos in
                guard let self = self else { return }
                if self.pagination.page == .zero {
                    self.loadedPhotos = photos
                } else {
                    self.loadedPhotos += photos
                }
                if photos.count < self.pagination.limit {
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

    private func createItems() -> [FullPhotoCollectionViewCell.Props] {
        return loadedPhotos.map { self.createCellProps($0) }
    }
    
    private func createCellProps(_ photo: Photo) -> FullPhotoCollectionViewCell.Props {
        return .init(
            url: URL(string: photo.url),
            didSelect: Command { [weak self] in
                self?.coordinator.onDetails(
                    photoId: photo.id
                )
            }
        )
    }
    
    private func filter(by searchText: String) {
        searchQuery = searchText
        updateProps()
    }
    
    private func updateProps() {
        let props = PhotosListProps(
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
