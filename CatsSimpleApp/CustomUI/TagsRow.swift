//
//  TagsRow.swift
//  CatsSimpleApp
//

import SwiftUI

struct TagsRow: View {
    let country: String
    let isHypoallergenic: Bool

    var body: some View {
        HStack(spacing: Style.spacing.medium) {
            tag(country)
            if isHypoallergenic {
                tag("hypoallergenic".localized)
            }
            Spacer()
        }
    }

    private func tag(_ text: String) -> some View {
        Text(text)
            .font(.caption)
            .padding(.horizontal, Style.padding.default)
            .padding(.vertical, Style.padding.small)
            .background(
                RoundedRectangle(cornerRadius: Style.corner.default)
                    .fill(Color(.systemGray5))
            )
    }
}
