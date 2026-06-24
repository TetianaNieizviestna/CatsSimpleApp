//
//  PhotosListView.swift
//  CatsSimpleApp
//

import SwiftUI

struct PhotosListView: View {
    @State
    var viewModel: PhotosListViewModel
    @Environment(AppRouter.self) private var router
    @State
    private var alertMessage: String?

    private let columns = [
        GridItem(.flexible(), spacing: Style.spacing.medium),
        GridItem(.flexible(), spacing: Style.spacing.medium)
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: Style.spacing.medium) {
                ForEach(viewModel.photos) { photo in
                    Button {
                        router.push(.photoDetails(id: photo.id))
                    } label: {
                        RemoteImage(url: photo.url.asUrl(), contentMode: .fit)
                            .scaledToFit()
                            .cornerRadius(Style.corner.default)
                    }
                    .buttonStyle(.plain)
                    .task { await viewModel.loadNextPageIfNeeded(currentItem: photo) }
                }
            }
            .padding(.horizontal, Style.padding.default)

            if viewModel.state == .loading {
                ProgressView()
                    .padding()
            }
        }
        .navigationTitle(viewModel.title)
        .toolbarTitleDisplayMode(.inline)
        .refreshable {
            await viewModel.refresh()
        }
        .task {
            await viewModel.loadIfNeeded()
        }
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
