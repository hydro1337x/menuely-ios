//
//  DateUtility.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 22.07.2021..
//

import Foundation

class DateUtility {
    
    let dateFormatter = DateFormatter()
    
    enum DateFormat: String {
        case full = "yyyy-MM-dd HH:mm:ss"
    }
    
    func formatToString(from timeInterval: TimeInterval, with dateFormat: DateFormat) -> String {
        dateFormatter.dateFormat = dateFormat.rawValue
        let date = Date(timeIntervalSince1970: timeInterval)
        return dateFormatter.string(from: date)
    }
    
}
