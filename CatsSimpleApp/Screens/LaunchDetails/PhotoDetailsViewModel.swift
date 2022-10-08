//
//  PhotoDetailsViewModel.swift
//  RocketsSchedule
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
            title: "", // photo?.photoDescription ?? "",
            header: .init(items: getHeaderItems()),
            details: "", // photo?.photoDescription ?? "",
            sections: getSections(),
            onBack: Command { [weak self] in
                self?.coordinator.dismiss()
            }, onRefresh: Command { [weak self] in
                self?.loadData()
            }
        )
        DispatchQueue.main.async { [weak self] in
            self?.stateSubscriber.send(props)
        }
    }
}

// MARK: Props creation
extension PhotoDetailsViewModel {
    private func getHeaderItems() -> [FullPhotoCollectionViewCell.Props] {
        return [FullPhotoCollectionViewCell.Props.init(url: URL(string: photo?.url ?? ""), didSelect: .nop)]
    }
    
    private func getSections() -> [Section] {
        return []
//        var sections: [Section] = []

//        if !launchDetails.crew.isEmpty {
//            let crewSection = createCrewSection(crew: launchDetails.crew)
//            sections.append(crewSection)
//        }
        
//        return sections
    }
    
//    private func createCrewSection(crew: [CrewMember]) -> Section {
//        let memberItems = crew.map { crewMember -> ImageTextCell.Props in
//            return .init(
//                imageUrl: crewMember.image ?? "",
//                text: crewMember.name,
//                didSelect: .nop
//            )
//        }
//        let sectionItems = memberItems.map { memberItem -> LaunchDetailsProps.Item in
//            return .imageText(memberItem)
//        }
//        return .init(
//            title: "Crew",
//            items: sectionItems
//        )
//    }

}
