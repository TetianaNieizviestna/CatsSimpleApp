//
//  BreedsListView.swift
//  CatsSimpleApp
//

import SwiftUI

struct BreedsListView: View {
    @State var viewModel: BreedsListViewModel
    @Bindable var router: AppRouter
    let services: AppServices
    @State private var alertMessage: String?

    var body: some View {
        NavigationStack(path: $router.path) {
            content
                .navigationDestination(for: Route.self) { route in
                    destination(for: route)
                }
        }
    }

    private var content: some View {
        ScrollView {
            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                Section {
                    Button {
                        viewModel.openAllPhotos()
                    } label: {
                        HStack {
                            Image(systemName: "photo.on.rectangle.angled")
                            Text("Show random cats")
                                .font(.headline)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.secondary)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                    }
                    .buttonStyle(.plain)
                    Divider()
                }

                Section {
                    ForEach(viewModel.breeds) { breed in
                        Button {
                            viewModel.openBreed(breed)
                        } label: {
                            BreedRow(breed: breed)
                                .padding(.horizontal, 16)
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
                        .padding(.vertical, 12)
                    }
                } header: {
                    HStack {
                        Text("Breeds")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color(.systemBackground))
                }
                Spacer()
            }
        }
        .refreshable { await viewModel.refresh() }
        .task { await viewModel.loadIfNeeded() }
        .onChange(of: viewModel.state) { _, newValue in
            if case .failed(let message) = newValue {
                alertMessage = message
            }
        }
        .alert("Error", isPresented: Binding(
            get: { alertMessage != nil },
            set: { if !$0 { alertMessage = nil } }
        )) {
            Button("OK", role: .cancel) { alertMessage = nil }
        } message: {
            Text(alertMessage ?? "")
        }
    }

    @ViewBuilder
    private func destination(for route: Route) -> some View {
        switch route {
        case .breedDetails(let breed):
            BreedDetailsView(
                viewModel: BreedDetailsViewModel(breed: breed, router: router)
            )
        case .photosList(let breed):
            PhotosListView(
                viewModel: PhotosListViewModel(
                    breed: breed,
                    loader: services.photosLoader,
                    router: router
                )
            )
        case .photoDetails(let id):
            PhotoDetailsView(
                viewModel: PhotoDetailsViewModel(
                    photoId: id,
                    loader: services.photosLoader,
                    router: router
                )
            )
        }
    }
}
