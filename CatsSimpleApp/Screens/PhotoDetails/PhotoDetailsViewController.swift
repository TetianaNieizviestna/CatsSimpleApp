//
//  PhotoDetailsView.swift
//  CatsSimpleApp
//

import SwiftUI

struct PhotoDetailsView: View {
    @State var viewModel: PhotoDetailsViewModel
    @State private var alertMessage: String?

    var body: some View {
        List {
            Section {
                PhotoHeaderView(url: viewModel.imageURL)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
            }

            if !viewModel.breeds.isEmpty {
                Section("Breeds") {
                    ForEach(viewModel.breeds) { breed in
                        Button {
                            viewModel.openBreed(breed)
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
        .navigationTitle("Details")
        .toolbarTitleDisplayMode(.inline)
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
}
