//
//  DateFormatter+.swift
//  CautionMemo
//
//  Created by juhee on 20/07/2019.
//  Copyright © 2019 caution-dev. All rights reserved.
//

import Foundation

extension DateFormatter {
    static let shared: DateFormatter = {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter
    }()
}

extension NSDate {
    var memoDate: String {
        let formatter = DateFormatter.shared
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        
        return formatter.string(from: self as Date)
    }
}
