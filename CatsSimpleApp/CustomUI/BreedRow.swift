//
//  BreedRow.swift
//  CatsSimpleApp
//

import SwiftUI

struct BreedRow: View {
    let breed: Breed

    var body: some View {
        HStack(alignment: .top, spacing: Style.spacing.large) {
            RemoteImage(url: breed.image?.url.asUrl())
                .size(Style.image.large)
                .cornerRadius(Style.corner.medium)

            VStack(alignment: .leading, spacing: Style.spacing.default) {
                Text(breed.name)
                    .font(.headline)
                if let altNames = breed.altNames,
                    !altNames.isEmpty {
                    Text(altNames)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Text(breed.breedDescription)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
                Text("\(breed.countryFlagSymbol) \(breed.origin)")
                    .font(.caption)
                    .padding(.horizontal, Style.padding.default)
                    .padding(.vertical, Style.padding.extraSmall)
                    .background(
                        RoundedRectangle(cornerRadius: Style.corner.default)
                            .fill(Color(.systemGray5))
                    )
            }
            Spacer()
        }
        .padding(.vertical, Style.padding.default)
    }
}
