//
//  ProfilePickerItem.swift
//  ChatApp
//
//  Created by 小森武史 on 2017/06/24.
//  Copyright © 2017年 小森武史. All rights reserved.
//

import UIKit

class SourceItem: NSObject {
    
    static func createGenderArray() -> [String] {
        let gender = ["未設定","男性","女性"]
        return gender
    }
    
    static func createNumberArray() -> [Int] {
        var i = 20
        var number = [Int]()
        while i <= 80 {
            number.append(i)
            i += 1
        }
        return number
    }
    
    static func createPlaceArray() -> [String] {
        let place = ["未設定","北海道地方","東北地方","関東地方","中部地方","近畿地方","四国地方","中国地方","九州地方","海外"]
        return place
    }
    
    static func createPlaceArray2() -> [String] {
        let place = ["設定しない","未設定","北海道地方","東北地方","関東地方","中部地方","近畿地方","四国地方","中国地方","九州地方","海外"]
        return place
    }
    
    static func createGenerationArray() -> [String] {
        let generation = ["20-29歳","30-39歳","40-49歳","50歳~"]
        return generation
    }
    
    static func changeAmbiguousAgeValue(age: Int) -> String {
        let geneSource = self.createGenerationArray()
        if age >= 20 && age < 30 {
            return geneSource[0]
        }else if age >= 30 && age < 40 {
            return geneSource[1]
        }else if age >= 40 && age < 50 {
            return geneSource[2]
        }
        return geneSource[3]
    }
    
}
