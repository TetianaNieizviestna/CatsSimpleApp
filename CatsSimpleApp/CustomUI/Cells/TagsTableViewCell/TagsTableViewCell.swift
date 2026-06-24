//
//  TagsRow.swift
//  CatsSimpleApp
//

import SwiftUI

struct TagsRow: View {
    let country: String
    let isHypoallergenic: Bool

    var body: some View {
        HStack(spacing: 8) {
            tag(country)
            if isHypoallergenic {
                tag("Hypoallergenic")
            }
            Spacer(minLength: 0)
        }
    }

    private func tag(_ text: String) -> some View {
        Text(text)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(.systemGray5))
            )
    }
}
