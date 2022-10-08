//
//  Date.swift
//  RocketsSchedule
//
//  Created by Tetiana Nieizviestna 
//

import Foundation
enum DateFormat: String {
    case jsonDate = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z"
    case publishedDate = "yyyy-MM-dd"
    case printDate = "dd.MM.yyyy HH:mm:ss"
    case printMessageDate = "MMM d"
}

extension Date {
    static func getDateOfUnix(_ value: Int) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(value))
    }
    
    static func getPrintDate(date: Date) -> String {
        let dateFormatterResult = DateFormatter()
        dateFormatterResult.dateFormat = DateFormat.printDate.rawValue
        return dateFormatterResult.string(from: date)
    }
}
