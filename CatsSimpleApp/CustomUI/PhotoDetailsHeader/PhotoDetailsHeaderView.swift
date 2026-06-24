//
//  PhotoHeaderView.swift
//  CatsSimpleApp
//

import SwiftUI

struct PhotoHeaderView: View {
    let url: URL?
    var onTap: (() -> Void)?

    var body: some View {
        RemoteImage(url: url, contentMode: .fill)
            .aspectRatio(1, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 7))
            .contentShape(Rectangle())
            .onTapGesture { onTap?() }
    }
}

struct RemoteImage: View {
    let url: URL?
    var contentMode: ContentMode = .fill

    var body: some View {
        AsyncImage(url: url, transaction: Transaction(animation: .easeInOut)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            case .failure, .empty:
                placeholder
            @unknown default:
                placeholder
            }
        }
    }

    @ViewBuilder
    private var placeholder: some View {
        ZStack {
            Color(.systemGray6)
            Image("placeholder_ic")
                .resizable()
                .scaledToFit()
                .padding(24)
                .opacity(0.5)
        }
    }
}
