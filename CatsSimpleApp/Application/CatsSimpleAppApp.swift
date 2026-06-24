//
//  CatsSimpleAppApp.swift
//  CatsSimpleApp
//

import SwiftUI

@main
struct CatsSimpleAppApp: App {
    @State private var services = AppServices()
    @State private var router = AppRouter()

    var body: some Scene {
        WindowGroup {
            BreedsListView(
                viewModel: BreedsListViewModel(
                    loader: services.breedsLoader,
                    router: router
                ),
                router: router,
                services: services
            )
            .environment(router)
            .preferredColorScheme(.light)
        }
    }
}
