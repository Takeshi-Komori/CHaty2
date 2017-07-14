//
//  DataUtil.swift
//  ChatApp
//
//  Created by KomoriTakeshi on 2017/07/10.
//  Copyright © 2017年 小森武史. All rights reserved.
//

import UIKit

class DateUtil: NSObject {
    static func createDate() -> String {
        let now = Date()
        let dateFormatter = DateFormatter()
        let date: String!
        
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale!
        dateFormatter.timeStyle = .medium
        dateFormatter.dateStyle = .medium
        date = dateFormatter.string(from: now)
        
        return date
    }
}
