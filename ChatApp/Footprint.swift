//
//  Footprint.swift
//  ChatApp
//
//  Created by 小森武史 on 2017/06/24.
//  Copyright © 2017年 小森武史. All rights reserved.
//

import UIKit
import Firebase

class Footprint: NSObject {
    var userID: String!
    var createDate: NSDate?
    
    
    func createFootprint(userID: String) {
        let date = DateUtil.createDate()
        
        let ref = Database.database().reference()
        let refFootprint = ref.child("footprints").child(userID).child(userID)
        let post = [
            "userID" : userID,
            "data" : date
        ]
    }
    
    func readFootprint() {
        
    }
    
    func updateFootprint() {
        
    }
    
    func deleteFootprint() {
        
    }
}
