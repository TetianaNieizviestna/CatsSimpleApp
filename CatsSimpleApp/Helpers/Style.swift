//
//  Style.swift
//  CatsSimpleApp
//
//  Created by Nieizviestna, Tetiana on 24.06.2026.
//
import Foundation

enum Style {
    static let padding = Padding()
    static let spacing = Spacing()
    static let corner = CornerRadius()
    static let image = ImageSize()

    struct Padding {
        let `default`: CGFloat = 8
        let extraSmall: CGFloat = 2
        let small: CGFloat = 4
        let medium: CGFloat = 12
        let large: CGFloat = 16
        let extraLarge: CGFloat = 24
    }

    struct Spacing {
        let `default`: CGFloat = 4
        let small: CGFloat = 2
        let medium: CGFloat = 8
        let large: CGFloat = 12
    }

    struct CornerRadius {
        let `default`: CGFloat = 8
        let medium: CGFloat = 12
    }

    struct ImageSize {
        let small: CGFloat = 40
        let medium: CGFloat = 60
        let large: CGFloat = 96
    }
}
