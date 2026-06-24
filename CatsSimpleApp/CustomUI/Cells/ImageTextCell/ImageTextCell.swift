//
//  ImageTextRow.swift
//  CatsSimpleApp
//

import SwiftUI

struct ImageTextRow: View {
    let imageURL: URL?
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            RemoteImage(url: imageURL)
                .frame(width: 60, height: 60)
                .clipShape(Circle())
            Text(text)
                .font(.body)
            Spacer(minLength: 0)
        }
    }
}
