//
//  RatingRow.swift
//  CatsSimpleApp
//

import SwiftUI

struct RatingRow: View {
    let title: String
    let starCount: Int
    private let maxStars = 5

    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
            Spacer()
            HStack(spacing: 2) {
                ForEach(0..<maxStars, id: \.self) { index in
                    Image(systemName: index < max(0, starCount - 1) ? "star.fill" : "star")
                        .foregroundStyle(.yellow)
                        .font(.footnote)
                }
            }
        }
    }
}
