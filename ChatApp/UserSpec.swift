//
//  Biography.swift
//  ChatApp
//
//  Created by KomoriTakeshi on 2017/07/08.
//  Copyright © 2017年 小森武史. All rights reserved.
//

import UIKit
import Firebase

class UserSpec: NSObject {
    static func createUserSpecData(gender: String, age: Int, place: String, userID: String) {
        let ref = Database.database().reference()
        let bioRef = ref.child("userSpecs").child(gender).child(SourceItem.changeAmbiguousAgeValue(age: age)).child(place).child(userID)
        let post = [
            "userID" : userID
        ]
        bioRef.setValue(post)
    }
    
    static func updateSpecData(gender: String, age: Int, place: String) {
        self.deleteUserSpecData()
        createUserSpecData(gender: gender, age: age, place: place, userID: Me.sharedMe.returnInfo(key: "userID") as! String)
    }
    
    static func deleteUserSpecData() {
        let ref = Database.database().reference()
        let specRef = ref.child("userSpecs").child(Me.sharedMe.returnInfo(key: "gender") as! String).child(SourceItem.changeAmbiguousAgeValue(age: Me.sharedMe.returnInfo(key: "age") as! Int)).child(Me.sharedMe.returnInfo(key: "place") as! String).child(Me.sharedMe.returnInfo(key: "userID") as! String)
        specRef.removeValue()
        
    }
    
    static func researchUserSpec(gender: String, age: String, place: String, completionHandler: @escaping (Array<Any>) -> Void) {
        var userDataSource = Array<User>()
        let ref = Database.database().reference()
        var specRef = ref.child("userSpecs").child(gender).child(age).child(place)
        if place != "設定しない" {
            specRef = ref.child("userSpecs").child(gender).child(age).child(place)
            specRef.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                if snapshot.value is NSNull {
                    completionHandler(userDataSource)
                }else {
                    let users = snapshot.value as! [String : [String : AnyObject]]
                    for user in users {
                        User.readUser4UserSpec(userID: user.key, completionHandler: { (user) in
                            userDataSource.append(user)
                            if userDataSource.count == users.count {
                                completionHandler(userDataSource)
                            }
                        })
                    }
                }
            })
            
        }else {
            specRef = ref.child("userSpecs").child(gender).child(age)
            specRef.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                if snapshot.value is NSNull {
                    completionHandler(userDataSource)
                }else {
                    let usersAllPrefecture = snapshot.value as! [String : [String : [String : AnyObject]]]
                    for usersInAnotherPrefecture in usersAllPrefecture {
                        for userSmallInfo in usersInAnotherPrefecture.value {
                            User.readUser4UserSpec(userID: userSmallInfo.key, completionHandler: { (user) in
                                userDataSource.append(user)
                                if userDataSource.count == checkArrayCount(array: usersAllPrefecture) {
                                    completionHandler(userDataSource)
                                }
                            })
                        }
                    }
                }
            })
        }
    }
    
    //其の場凌ぎ
    static func checkArrayCount(array : [String : [String : [String : AnyObject]]]) -> Int {
        var count = 0
        for arr in array {
            for _ in arr.value {
                count += 1
            }
        }
        return count
    }
}
