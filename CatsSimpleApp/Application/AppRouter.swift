//
//  AppRouter.swift
//  CatsSimpleApp
//

import SwiftUI

enum Route: Hashable {
    case breedDetails(Breed)
    case photosList(breed: Breed?)
    case photoDetails(id: String)
}

@Observable
@MainActor
final class AppRouter {
    var path: [Route] = []

    func push(_ route: Route) { path.append(route) }
    func pop() { _ = path.popLast() }
    func popToRoot() { path.removeAll() }
}
