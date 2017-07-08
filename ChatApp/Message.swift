//
//  Message.swift
//  ChatApp
//
//  Created by 小森武史 on 2017/06/24.
//  Copyright © 2017年 小森武史. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase

class Message: JSQMessage {
//    var messageID: String?
//    var userID: String?
//    var createDate: NSDate?
//    var deleteFlg: Bool?
    
    static func createMessage(message: String, senderID: String, chatroomID: String) {
        let rootRef = Database.database().reference().child("chatrooms").child(chatroomID).child("messages").childByAutoId()
        let now = Date()
        let dateFormatter = DateFormatter()
        let date: String!
        
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale!
        dateFormatter.timeStyle = .medium
        dateFormatter.dateStyle = .medium
        date = dateFormatter.string(from: now)
        
        let post = ["from": senderID,
                    "text": message,
                    "createDate": date
        ]
        rootRef.setValue(post)
    }
    
    static func messageSetupFirebase(chatroomID: String, myname: String, completionHandler: @escaping (Message) -> Void) {
        let rootRef = Database.database().reference().child("chatrooms").child(chatroomID).child("messages")
        rootRef.queryLimited(toLast: 1000).observe(DataEventType.childAdded, with: { (snapshot) in
            guard let firebaseResponse = snapshot.value as? [String:Any] else
            {
                print("Snapshot is nil hence no data returned")
                return
            }
            let message = Message(senderId: firebaseResponse["from"] as! String, displayName: myname, text: firebaseResponse["text"] as! String)
            UserDefaults.standard.set(firebaseResponse["text"] as! String, forKey: chatroomID)
            completionHandler(message!)
        })
    }
    
    func deleteMessage() {
        
    }
    
}
