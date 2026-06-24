//
//  PhotoGridItem.swift
//  CatsSimpleApp
//

import SwiftUI

struct PhotoGridItem: View {
    let url: URL?

    var body: some View {
        RemoteImage(url: url)
            .aspectRatio(1, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 7))
    }
}
