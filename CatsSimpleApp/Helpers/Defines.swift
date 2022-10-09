//
//  Defines.swift
//  CatsSimpleApp
//
//  Created by Tetiana Nieizviestna
//

import Foundation

struct Defines {
    enum API {
        static var baseUrl: URL {
            return URL(string: "https://api.thecatapi.com/v1")!
        }
        
        static var accessKey: String {
            return "live_dVUPwZNNM2I0RZnRK6WZtZKFCsS0IaygmpuZdtMjIfm8eQDrT901AJPzWXtgbOoW"
        }
    }
}
