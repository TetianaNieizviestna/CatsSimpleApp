//
//  PhotoDetailsViewModel.swift
//  CatsSimpleApp
//
//  Created by Tetiana Nieizviestna 
//

import UIKit
import Combine

typealias PhotoDetailsProps = PhotoDetailsViewController.Props

protocol PhotoDetailsViewModelType {
    var stateSubscriber: PassthroughSubject<PhotoDetailsProps, Never> { get }
}

final class PhotoDetailsViewModel: PhotoDetailsViewModelType{
    typealias Section = PhotoDetailsViewController.Props.Section
    var stateSubscriber = PassthroughSubject<PhotoDetailsProps, Never>()

    private let coordinator: PhotoDetailsCoordinatorType
    private var launchesLoader: PhotosLoaderType

    private var screenState: PhotoDetailsProps.ScreenState = .initial
    
    private var id: String

    private var photo: Photo?
    
    init(_ coordinator: PhotoDetailsCoordinatorType, serviceHolder: ServiceHolder, id: String) {
        self.coordinator = coordinator
        launchesLoader = serviceHolder.get(by: PhotosLoaderType.self)
        
        self.id = id
        
        loadData()
    }
    
    private func setScreenState(_ state: PhotoDetailsProps.ScreenState) {
        screenState = state
        updateProps()
    }
    
    private func loadData() {
        setScreenState(.loading)
        
        launchesLoader.loadPhotoDetails(
            id: id,
            onSuccess: CommandWith { [weak self] photo in
                self?.photo = photo
                self?.setScreenState(.loaded)
            },
            onFailure: CommandWith { [weak self] error in
                self?.setScreenState(.failed(error))
            }
        )
    }
    
    private func updateProps() {
        let props = PhotoDetailsProps(
            state: screenState,
            title: "Details",
            header: getHeaderItem(),
            details: "",
            sections: getSections(),
            onBack: Command { [weak self] in
                self?.coordinator.dismiss()
            }, onRefresh: Command { [weak self] in
                self?.loadData()
            }
        )
        stateSubscriber.send(props)
    }
}

// MARK: Props creation
extension PhotoDetailsViewModel {
    private func getHeaderItem() -> PhotoDetailsHeaderView.Props {
        return PhotoDetailsHeaderView.Props.init(url: URL(string: photo?.url ?? ""), didSelect: .nop)
    }
    
    private func getSections() -> [Section] {
        return []
    }
}
