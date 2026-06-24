//
//  CatsSimpleAppApp.swift
//  CatsSimpleApp
//

import SwiftUI

@main
struct CatsSimpleAppApp: App {
    @State
    private var services = AppServices()

    var body: some Scene {
        WindowGroup {
            BreedsListView(
                viewModel: BreedsListViewModel(
                    loader: services.breedsLoader
                ),
                services: services
            )
            .preferredColorScheme(.light)
        }
    }
}
