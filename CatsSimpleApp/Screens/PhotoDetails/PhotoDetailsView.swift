//
//  PhotoDetailsView.swift
//  CatsSimpleApp
//

import SwiftUI

struct PhotoDetailsView: View {
    @Environment(AppRouter.self)
    private var router

    @State
    var viewModel: PhotoDetailsViewModel

    @State
    private var alertMessage: String?

    var body: some View {
        List {
            Section {
                PhotoHeaderView(url: viewModel.imageURL)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
            }

            if !viewModel.breeds.isEmpty {
                Section(.breedsSection) {
                    ForEach(viewModel.breeds) { breed in
                        Button {
                            router.push(.breedDetails(breed))
                        } label: {
                            BreedRow(breed: breed)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .overlay {
            if viewModel.state == .loading, viewModel.photo == nil {
                ProgressView()
            }
        }
        .navigationTitle(.photosTitle)
        .toolbarTitleDisplayMode(.inline)
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
}
