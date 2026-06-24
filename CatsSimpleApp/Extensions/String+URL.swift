//
//  URL+.swift
//  CatsSimpleApp
//
//  Created by Nieizviestna, Tetiana on 24.06.2026.
//

import Foundation

extension String {
    func asUrl() -> URL? {
        URL(string: self)
    }
}

extension String {
    var localized: String {
        String(localized: String.LocalizationValue(self))
    }
}
