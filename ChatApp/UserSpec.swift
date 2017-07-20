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
    
    
    //検索 blockしていた場合や自分を含めないなど考慮すると、長くなった
    static func researchUserSpec(isBlocingSomeone: Bool ,gender: String, age: String, place: String, completionHandler: @escaping (Array<Any>) -> Void) {
        let brockDataSource = Block.readBlockDataSource()
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
                            if user.userID != Me.sharedMe.returnInfo(key: "userID") as? String {
                                if isBlocingSomeone {
                                    var count = 0
                                    for blockD in brockDataSource {
                                        if blockD.userID != user.userID {
                                            count += 1
                                            if brockDataSource.count == count {
                                                userDataSource.append(user)
                                            }
                                        }
                                    }
                                }else {
                                    userDataSource.append(user)
                                }
                            }
                            if isBlocingSomeone {
                                if userDataSource.count == users.count || userDataSource.count == users.count - brockDataSource.count || userDataSource.count == users.count - brockDataSource.count - 1 {
                                    completionHandler(userDataSource)
                                }
                            } else {
                                if userDataSource.count == users.count || userDataSource.count == users.count - 1 {
                                    completionHandler(userDataSource)
                                }
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
                                if user.userID != Me.sharedMe.returnInfo(key: "userID") as? String {
                                    if isBlocingSomeone {
                                        var count2 = 0
                                        for blockD in brockDataSource {
                                            if blockD.userID != user.userID {
                                                count2 += 1
                                                if brockDataSource.count == count2 {
                                                    userDataSource.append(user)
                                                }
                                            }
                                        }
                                    }else {
                                        userDataSource.append(user)
                                    }
                                }
                                if isBlocingSomeone {
                                    if userDataSource.count == checkArrayCount(array: usersAllPrefecture) || userDataSource.count == checkArrayCount(array: usersAllPrefecture) - brockDataSource.count || userDataSource.count == checkArrayCount(array: usersAllPrefecture) - brockDataSource.count - 1 {
                                        completionHandler(userDataSource)
                                    }
                                } else {
                                    if userDataSource.count == checkArrayCount(array: usersAllPrefecture) ||
                                        userDataSource.count == checkArrayCount(array: usersAllPrefecture) - 1 {
                                        completionHandler(userDataSource)
                                    }
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
