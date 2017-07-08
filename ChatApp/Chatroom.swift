//
//  Chatroom.swift
//  ChatApp
//
//  Created by 小森武史 on 2017/06/24.
//  Copyright © 2017年 小森武史. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController

class Chatroom: NSObject {
    var chatRoomID: String?
    var name: String?
    var isAlreadyCreated: Bool!
    
    static func createChatroom(userIDs: [String], chatroomID: String) {
        let rootRef = Database.database().reference()
        let now = Date()
        let dateFormatter = DateFormatter()
        let date: String!
        
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale!
        dateFormatter.timeStyle = .medium
        dateFormatter.dateStyle = .medium
        date = dateFormatter.string(from: now)
        
        let post = [
            "createDate": date,
            "userIDs": userIDs
                ]
                as [String : Any]
        rootRef.child("chatrooms").child(chatroomID).setValue(post)
        
        var post4Me: [String : String]!
        var post4You: [String : String]!
        var opponentUserID = ""
        for userID in userIDs {
            if userID != Me.sharedMe.returnInfo(key: "userID") as! String {
                opponentUserID = userID
                post4Me = [
                    "chatroomID" : chatroomID,
                    "opponentUserID" : opponentUserID
                ]
            }else {
                post4You = [
                    "chatroomID" : chatroomID,
                    "opponentUserID" : Me.sharedMe.returnInfo(key: "userID") as! String
                ]
            }
        }
        rootRef.child("users").child(Me.sharedMe.returnInfo(key: "userID") as! String).child("chatroomIDs").child(chatroomID).setValue(post4Me)
        rootRef.child("users").child(opponentUserID).child("chatroomIDs").child(chatroomID).setValue(post4You)
    }
    
    // userID二つで取得(messagesVCで使用)
    static func readChatroom(userIDs: Set<String> ,completionHandler: @escaping (Chatroom) -> Void) {
        let ref = Database.database().reference()
        var chatrooms = [String : AnyObject]()
        ref.child("chatrooms").observeSingleEvent(of:DataEventType.value, with: { (snapshot) in
            let chatroom = Chatroom()
            chatroom.chatRoomID = NSUUID().uuidString
            if !(snapshot.value is NSNull) {
                chatrooms = snapshot.value as! [String : [String : AnyObject]] as [String : AnyObject]
                var flag = true
                for item in chatrooms {
                    let userIDs2 = item.value["userIDs"] as! [String]
                    if userIDs == castToSet(array: userIDs2) {
                        chatroom.chatRoomID = item.key
                        chatroom.isAlreadyCreated = true
                        flag = false
                    }
                }
                if flag != false {
                    self.createChatroom(userIDs: castToArray(set: userIDs), chatroomID: chatroom.chatRoomID!)
                }
            }else {
                self.createChatroom(userIDs: castToArray(set: userIDs), chatroomID: chatroom.chatRoomID!)
            }
            completionHandler(chatroom)
        })
    }
    
    // ローカルの自分のUserIDを使って、ChatroomIDを使う
    static func readChatroomIDFromUser(completionHandler: @escaping ([User]) -> Void) {
        let ref = Database.database().reference()
        var userDataSource = [User]()
        var chatroomIDs = [String : AnyObject]()
        if Me.sharedMe.isResistered() {
            ref.child("users").child(Me.sharedMe.returnInfo(key: "userID") as! String).child("chatroomIDs").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                if !(snapshot.value is NSNull) {
                    chatroomIDs = snapshot.value as! [String : [String : String]] as [String : AnyObject]
                    for chatroomID in chatroomIDs {
                        readChatroom2(chatroomID: chatroomID.key , completionHandler: { (user) in
                            userDataSource.append(user)
                            if userDataSource.count == chatroomIDs.count {
                                completionHandler(userDataSource)
                            }
                        })
                    }
                }else {
                    completionHandler(userDataSource)
                }
            })
        }else {
            completionHandler(userDataSource)
        }
    }
    
    //readChatroomIDFromUserから飛んできて、chatrooms配下のuserIDsの二つのuserIDから自分のではないuserIDをreaduserに渡す
    static func readChatroom2(chatroomID: String, completionHandler: @escaping (User) -> Void) {
        let ref = Database.database().reference()
        ref.child("chatrooms").child(chatroomID).child("userIDs").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            if !(snapshot.value is NSNull) {
                let userIDs = snapshot.value as! [String]
                for userID in userIDs {
                    if userID != Me.sharedMe.returnInfo(key: "userID") as! String {
                        User.readUser(userID: userID, chatroomID: chatroomID, completionHandler: { (user) in
                            completionHandler(user)
                        })
                    }
                }
            }
        })
    }
    
    //usersの中にある自分と相手のChatroomID削除, chatroomsの中にあるmessageとかあるやつ削除
    func deleteChatroom(opponentUserID2: String, chatroomID: String) {
        let ref = Database.database().reference()
        ref.child("users").child(opponentUserID2).child("chatroomIDs").child(chatroomID).removeValue()
        ref.child("users").child(Me.sharedMe.returnInfo(key: "userID") as! String).child("chatroomIDs").child(chatroomID).removeValue()
        ref.child("chatrooms").child(chatroomID).removeValue()
        if UserDefaults.standard.object(forKey: opponentUserID2) != nil {
            UserDefaults.standard.removeObject(forKey: opponentUserID2)
        }
    }
    
    //ArrayをSetに変換(其の場凌ぎ)
    static func castToSet(array: [String]) -> Set<String> {
        var set = Set<String>()
        for arr in array {
            set.insert(arr)
        }
        return set
    }
    
    static func castToArray(set: Set<String>) -> [String] {
        var array = [String]()
        for s in set {
            array.append(s)
        }
        return array
    }
}
