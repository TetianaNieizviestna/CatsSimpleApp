//
//  PhotosListView.swift
//  CatsSimpleApp
//

import SwiftUI

struct PhotosListView: View {
    @State var viewModel: PhotosListViewModel
    @State private var alertMessage: String?

    private let columns = [GridItem(.flexible(), spacing: 8), GridItem(.flexible(), spacing: 8)]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(viewModel.photos) { photo in
                    Button {
                        viewModel.openPhoto(photo)
                    } label: {
                        PhotoGridItem(url: URL(string: photo.url))
                    }
                    .buttonStyle(.plain)
                    .task { await viewModel.loadNextPageIfNeeded(currentItem: photo) }
                }
            }
            .padding(.horizontal, 8)

            if viewModel.state == .loading {
                ProgressView()
                    .padding()
            }
        }
        .navigationTitle(viewModel.title)
        .toolbarTitleDisplayMode(.inline)
        .refreshable { await viewModel.refresh() }
        .task { await viewModel.loadIfNeeded() }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Picker("Sort", selection: $viewModel.sorting) {
                        ForEach(SortingType.allCases) { option in
                            Text(option.title).tag(option)
                        }
                    }
                } label: {
                    Label("Sort: \(viewModel.sorting.title)", systemImage: "arrow.up.arrow.down")
                }
            }
        }
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
