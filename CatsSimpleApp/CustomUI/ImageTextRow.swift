//
//  ImageTextRow.swift
//  CatsSimpleApp
//

import SwiftUI

struct ImageTextRow: View {
    let imageURL: URL?
    let text: String

    var body: some View {
        HStack(spacing: Style.spacing.large) {
            RemoteImage(url: imageURL)
                .size(Style.image.medium)
                .clipShape(Circle())
            Text(text)
                .font(.body)
            Spacer()
        }
    }
}
