//
//  DateExtension.swift
//  FitsappTodos
//
//  Created by Luca Hagel on 3/14/17.
//  Copyright © 2017 Luca Hagel. All rights reserved.
//

import Foundation

// Provide an easy way to convert nsdate to a string, taken from http://stackoverflow.com/questions/28332946/nsdateformatter-stringfromdatensdate-returns-empty-string

extension DateFormatter {
    convenience init(dateStyle: DateFormatter.Style) {
        self.init()
        self.dateStyle = dateStyle
    }
    convenience init(timeStyle: DateFormatter.Style) {
        self.init()
        self.timeStyle = timeStyle
    }
    
}

extension Date {
    static let shortDate = DateFormatter(dateStyle: .short)
    static let fullDate = DateFormatter(dateStyle: .full)
    
    static let shortTime = DateFormatter(timeStyle: .short)
    static let fullTime = DateFormatter(timeStyle: .full)
    
    var fullDate:  String { return Date.fullDate.string(from: self) }
    var shortDate: String { return Date.shortDate.string(from: self) }
    
    var fullTime:  String { return Date.fullTime.string(from: self) }
    var shortTime: String { return Date.shortTime.string(from: self) }
}
