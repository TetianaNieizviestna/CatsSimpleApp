//
//  LinkRow.swift
//  CatsSimpleApp
//

import SwiftUI

enum LinkType {
    case wikipedia, cfa, vetstreet, vcaHospitals

    var assetName: ImageResource {
        switch self {
        case .wikipedia:
            .wikipediaLogo
        case .cfa:
            .cfaLogo
        case .vetstreet:
            .vetstreetLogo
        case .vcaHospitals:
            .vcaHospitalsLogo
        }
    }

    var label: LocalizedStringResource {
        switch self {
        case .wikipedia:
            .linkWikipedia
        case .cfa:
            .linkCfa
        case .vetstreet:
            .linkVetstreet
        case .vcaHospitals:
            .linkVcaHospitals
        }
    }
}

struct LinkRow: View {
    let type: LinkType

    var body: some View {
        HStack(spacing: Style.spacing.large) {
            Image(type.assetName)
                .resizable()
                .scaledToFit()
                .size(Style.image.small)
                .clipShape(RoundedRectangle(cornerRadius: 7))
            Text(type.label)
                .font(.body)
            Spacer()
            Image(systemName: "arrow.up.right.square")
                .foregroundStyle(.secondary)
        }
    }
}
