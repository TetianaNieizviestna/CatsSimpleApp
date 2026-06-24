//
//  TextDescriptionRow.swift
//  CatsSimpleApp
//

import SwiftUI

struct TextDescriptionRow: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.body)
            .fixedSize(horizontal: false, vertical: true)
    }
}
