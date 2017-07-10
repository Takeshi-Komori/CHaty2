//
//  Block.swift
//  ChatApp
//
//  Created by 小森武史 on 2017/06/24.
//  Copyright © 2017年 小森武史. All rights reserved.
//

import UIKit
import Firebase

class Block: NSObject, NSCoding {
    var userID: String!
    var userName: String!
    var createDate: Date!
    var isfromMe: String!
    
    //ローカルで保存
    init(userID: String, userName: String, isfromMe: String) {
        super.init()
        self.userID = userID
        self.createDate = Date()
        self.userName = userName
        self.isfromMe = isfromMe
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.userID = aDecoder.decodeObject(forKey: "userID") as! String
        self.createDate = aDecoder.decodeObject(forKey: "createDate") as! Date
        self.userName = aDecoder.decodeObject(forKey: "userName") as! String
        self.isfromMe = aDecoder.decodeObject(forKey: "isfromMe") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.userID, forKey: "userID")
        aCoder.encode(self.createDate, forKey: "createDate")
        aCoder.encode(self.userName, forKey: "userName")
        aCoder.encode(self.isfromMe, forKey: "isfromMe")
    }
    
    //firebase
    func createBlock(userID: String, userName: String) {
        let now = Date()
        let dateFormatter = DateFormatter()
        let date: String!
        
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale!
        dateFormatter.timeStyle = .medium
        dateFormatter.dateStyle = .medium
        date = dateFormatter.string(from: now)
        
        let ref = Database.database().reference()
        let blockRef4Me = ref.child("blocks").child(Me.sharedMe.returnInfo(key: "userID") as! String).child(userID)
        let blockRef4You = ref.child("blocks").child(userID).child(Me.sharedMe.returnInfo(key: "userID") as! String)
        
        let post4Me = [
            "date" : date,
            "userName" : userName,
            "isfromMe" : "true"
            ] as [String : AnyObject]
        
        let post4You = [
            "date" : date,
            "userName" : Me.sharedMe.returnInfo(key: "name"),
            "isfromMe" : "false"
            ] as [String : AnyObject]
        
        blockRef4Me.setValue(post4Me)
        blockRef4You.setValue(post4You)
    }
    
    static func readBlockFromFirebase() {
        let ref = Database.database().reference()
        let blockRef4You = ref.child("blocks").child(Me.sharedMe.returnInfo(key: "userID") as! String)
        blockRef4You.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            if snapshot.value is NSNull {
                return
            }
            let blockDataFromFirebase = snapshot.value as! [String : [String : AnyObject]]            
            for blockD in blockDataFromFirebase {
                let block = Block.init(userID: blockD.key, userName: blockD.value["userName"] as! String, isfromMe: blockD.value["isfromMe"] as! String)
                self.saveBlock(block: block)
            }
        })
    }
    
    static func deleteBlockData(userID: String) {
        let ref = Database.database().reference()
        let deleteRef = ref.child("blocks").child(Me.sharedMe.returnInfo(key: "userID") as! String).child(userID)
        let deleteRef2 = ref.child("blocks").child(userID).child(Me.sharedMe.returnInfo(key: "userID") as! String)
        deleteRef.removeValue()
        deleteRef2.removeValue()
        self.deleteBlockDataSource(userID: userID)
    }
    
    //local
    static func saveBlock(block: Block) {
        var archiveDataSource = Array<Data>()
        let archiveData = NSKeyedArchiver.archivedData(withRootObject: block)
        if (UserDefaults.standard.object(forKey: "BLOCK_LIST") != nil) {
            var blockDataSource = UserDefaults.standard.object(forKey: "BLOCK_LIST") as! Array<Data>
            blockDataSource.append(archiveData)
            UserDefaults.standard.set(blockDataSource, forKey: "BLOCK_LIST")
        } else {
            archiveDataSource.append(archiveData)
            UserDefaults.standard.set(archiveDataSource, forKey: "BLOCK_LIST")
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "blockCreate"), object: nil)
    }
    
    static func readBlockDataSource() -> Array<Block> {
        var dataSource = Array<Block>()
        if UserDefaults.standard.object(forKey: "BLOCK_LIST") != nil {
            let blockDataSource = UserDefaults.standard.object(forKey: "BLOCK_LIST") as! Array<Data>
            for block in blockDataSource {
                let d = NSKeyedUnarchiver.unarchiveObject(with: block) as! Block
                dataSource.append(d)
            }
        }
        return dataSource
    }
    
    static func deleteBlockDataSource(userID: String) {
        let blockDataSource = self.readBlockDataSource()
        UserDefaults.standard.removeObject(forKey: "BLOCK_LIST")
        for blockD in blockDataSource {
            if blockD.userID != userID {
                let block = Block.init(userID: blockD.userID, userName: blockD.userName, isfromMe: blockD.isfromMe)
                self.saveBlock(block: block)
            }
        }
    }
}
