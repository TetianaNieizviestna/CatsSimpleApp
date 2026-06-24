//
//  Links.swift
//  CatsSimpleApp
//

import Foundation

enum SortingType: String, CaseIterable, Identifiable, Codable {
    case ascending = "ASC"
    case descending = "DESC"
    case random = "RAND"

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .ascending:
            "Ascending"
        case .descending:
            "Descending"
        case .random:
            "Random"
        }
    }
}
