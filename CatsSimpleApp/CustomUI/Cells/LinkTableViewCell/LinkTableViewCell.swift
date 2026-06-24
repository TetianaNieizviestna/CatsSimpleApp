//
//  LinkRow.swift
//  CatsSimpleApp
//

import SwiftUI

enum LinkType {
    case wikipedia, cfa, vetstreet, vcaHospitals

    var assetName: String {
        switch self {
        case .wikipedia: return "wikipedia_logo"
        case .cfa: return "cfa_logo"
        case .vetstreet: return "vetstreet_logo"
        case .vcaHospitals: return "vcaHospitals_logo"
        }
    }

    var label: String {
        switch self {
        case .wikipedia: return "Wikipedia"
        case .cfa: return "CFA"
        case .vetstreet: return "Vetstreet"
        case .vcaHospitals: return "VCA Hospitals"
        }
    }
}

struct LinkRow: View {
    let type: LinkType

    var body: some View {
        HStack(spacing: 12) {
            Image(type.assetName)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .clipShape(RoundedRectangle(cornerRadius: 7))
            Text(type.label)
                .font(.body)
            Spacer()
            Image(systemName: "arrow.up.right.square")
                .foregroundStyle(.secondary)
        }
    }
}
