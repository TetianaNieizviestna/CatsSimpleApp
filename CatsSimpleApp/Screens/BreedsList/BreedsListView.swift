//
//  BreedsListView.swift
//  CatsSimpleApp
//

import SwiftUI

struct BreedsListView: View {
    @State
    private var router = AppRouter()

    @State
    var viewModel: BreedsListViewModel
    let services: AppServices
    @State
    private var alertMessage: String?

    var body: some View {
        NavigationStack(path: $router.path) {
            content
                .navigationDestination(for: Route.self) { route in
                    destination(for: route)
                }
        }
        .environment(router)
    }

    private var content: some View {
        ScrollView {
            LazyVStack(spacing: .zero, pinnedViews: [.sectionHeaders]) {
                Button {
                    router.push(.photosList(breed: nil))
                } label: {
                    HStack {
                        Image(systemName: "photo.on.rectangle.angled")
                        Text(.randomCatsButtonTitle)
                            .font(.headline)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, Style.padding.large)
                    .padding(.vertical, Style.padding.medium)
                }
                .buttonStyle(.plain)

                ForEach(viewModel.breeds) { breed in
                    Button {
                        router.push(.breedDetails(breed))
                    } label: {
                        BreedRow(breed: breed)
                            .padding(.horizontal, Style.padding.large)
                    }
                    .buttonStyle(.plain)
                    .task { await viewModel.loadNextPageIfNeeded(currentItem: breed) }
                    Divider()
                }

                if viewModel.state == .loading {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    .padding(.vertical, Style.padding.medium)
                }
                Spacer()
            }
        }
        .refreshable {
            await viewModel.refresh()
        }
        .task { 
            await viewModel.loadIfNeeded()
        }
        .onChange(of: viewModel.state) { _, newValue in
            if case .failed(let message) = newValue {
                alertMessage = message
            }
        }
        .alert(.alertError, isPresented: Binding(
            get: { alertMessage != nil },
            set: { if !$0 { alertMessage = nil } }
        )) {
            Button(.buttonOk, role: .cancel) { alertMessage = nil }
        } message: {
            Text(alertMessage ?? "")
        }
    }

    @ViewBuilder
    private func destination(for route: Route) -> some View {
        switch route {
        case .breedDetails(let breed):
            BreedDetailsView(
                viewModel: BreedDetailsViewModel(breed: breed)
            )
        case .photosList(let breed):
            PhotosListView(
                viewModel: PhotosListViewModel(
                    breed: breed,
                    loader: services.photosLoader
                )
            )
        case .photoDetails(let id):
            PhotoDetailsView(
                viewModel: PhotoDetailsViewModel(
                    photoId: id,
                    loader: services.photosLoader
                )
            )
        }
    }
}
