//
//  PhotoHeaderView.swift
//  CatsSimpleApp
//

import SwiftUI

struct PhotoHeaderView: View {
    let url: URL?
    var onTap: (() -> Void)?

    var body: some View {
        RemoteImage(url: url, contentMode: .fit)
            .scaledToFit()
            .cornerRadius(Style.corner.default)
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
            Image(.placeholderIc)
                .resizable()
                .scaledToFit()
                .padding(Style.padding.extraLarge)
                .opacity(0.5)
        }
    }
}
