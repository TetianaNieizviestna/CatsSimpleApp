//
//  BreedRow.swift
//  CatsSimpleApp
//

import SwiftUI

struct BreedRow: View {
    let breed: Breed

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            RemoteImage(url: URL(string: breed.image?.url ?? ""))
                .frame(width: 96, height: 96)
                .clipShape(RoundedRectangle(cornerRadius: 6))

            VStack(alignment: .leading, spacing: 4) {
                Text(breed.name)
                    .font(.headline)
                if let altNames = breed.altNames, !altNames.isEmpty {
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
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color(.systemGray5))
                    )
            }
            Spacer(minLength: 0)
        }
        .padding(.vertical, 6)
    }
}
