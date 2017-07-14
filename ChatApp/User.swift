//
//  User.swift
//  ChatApp
//
//  Created by 小森武史 on 2017/07/01.
//  Copyright © 2017年 小森武史. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorageUI

class User: NSObject {
    var name: String!
    var gender: String!
    var age: Int!
    var place: String!
    var biography: String!
    var userID: String!
    var chatroomID: String! //Meに対してのチャットルームID
    var token: String!
    
    init(attributed: [String : AnyObject], key: String) {
        super.init()
        let userInfo = attributed["info"]
        
        self.name = userInfo?["name"] as! String
        self.gender = userInfo?["gender"] as! String
        self.age = userInfo?["age"] as! Int!
        self.place = userInfo?["place"] as! String
        self.biography = userInfo?["biography"] as! String
        self.token = userInfo?["token"] as! String
        self.userID = key
    }
    
    static func readUsers(isBlockingSomeone: Bool ,completionHandler: @escaping (Array<Any>) -> Void) {
        let ref = Database.database().reference()
        var users = [String : AnyObject]()
        var userDataSource = Array<User>()
        DispatchQueue.main.async {
            ref.child("users").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                print(snapshot)
                if !(snapshot.value is NSNull) {
                    users = snapshot.value as! [String : [String : AnyObject]] as [String : AnyObject]
                    for item in users {
                        let user = User.init(attributed: item.value as! [String : AnyObject], key: item.key)
                        //自分だったら外す
                        if Me.sharedMe.isResistered() {
                            if user.userID == Me.sharedMe.returnInfo(key: "userID") as! String {
                                continue
                            }
                        }
                        //ブロックしているユーザーだったらはずす
                        if isBlockingSomeone {
                            let blockDataSource = Block.readBlockDataSource()
                            var addFlg = true
                            for block in blockDataSource {
                                if block.userID == user.userID {
                                    addFlg = false
                                }
                            }
                            if addFlg {
                                userDataSource.append(user)
                            }
                        } else {
                            userDataSource.append(user)
                        }
                    }
                }else {
                    completionHandler(userDataSource)
                }
                completionHandler(userDataSource)
            })
        }
    }
    
    
    //以下二つのメソッド要検討ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
    //chatroomクラス内で使ってる
    static func readUser(userID: String, chatroomID: String, completionHandler: @escaping (User) -> Void) {
        let ref = Database.database().reference()
        var userInfo = [String : Any]()
        ref.child("users").child(userID).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            userInfo = snapshot.value as! [String : [String : AnyObject]]
            let user = User(attributed: userInfo as [String : AnyObject], key: userID)
            user.chatroomID = chatroomID
            completionHandler(user)
        })
    }
    
    //userSpec内で使っている(割とシンプルなやつ)
    static func readUser4UserSpec(userID: String ,completionHandler: @escaping (User) -> Void) {
        let ref = Database.database().reference()
        var userInfo = [String : Any]()
        ref.child("users").child(userID).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            userInfo = snapshot.value as! [String : [String : AnyObject]]
            print(userInfo)
            let user = User(attributed: userInfo as [String : AnyObject], key: userID)
            completionHandler(user)
        })
    }
    
    //ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
    
    
    static func returnImgStrorageRef(userID: String) -> StorageReference {
        let storage = Storage.storage()
        let storageRef = storage.reference(forURL: "gs://chaty-d559d.appspot.com")
        let imagesRef = storageRef.child("profile_image/\(userID).png")
        return imagesRef
    }

    //重複のある要素を削除する
    static func deleteSameValueAndReturnArray(dataSource: Array<User>) -> Array<User> {
        let orderedSet = NSOrderedSet(array: dataSource)
        let uniqueValues = orderedSet.array as! Array<User>
        return uniqueValues
    }
    
}
