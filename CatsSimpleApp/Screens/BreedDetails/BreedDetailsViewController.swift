//
//  BreedDetailsView.swift
//  CatsSimpleApp
//

import SwiftUI

struct BreedDetailsView: View {
    @State var viewModel: BreedDetailsViewModel

    var body: some View {
        List {
            Section {
                PhotoHeaderView(url: viewModel.headerURL) {
                    viewModel.openPhotos()
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
            }

            Section {
                TagsRow(country: viewModel.countryText, isHypoallergenic: viewModel.isHypoallergenic)
            }

            Section {
                TextDescriptionRow(text: viewModel.breed.breedDescription)
                if let temperament = viewModel.temperamentText {
                    TextDescriptionRow(text: temperament)
                }
            }

            if !viewModel.ratings.isEmpty {
                Section("Ratings") {
                    ForEach(viewModel.ratings, id: \.0) { item in
                        RatingRow(title: item.0, starCount: item.1)
                    }
                }
            }

            if !viewModel.links.isEmpty {
                Section("Links") {
                    ForEach(viewModel.links, id: \.1) { item in
                        Button {
                            viewModel.openURL(item.1)
                        } label: {
                            LinkRow(type: item.0)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(viewModel.title)
        .toolbarTitleDisplayMode(.inline)
    }
}
