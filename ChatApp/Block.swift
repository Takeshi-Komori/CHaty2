//
//  Block.swift
//  ChatApp
//
//  Created by 小森武史 on 2017/06/24.
//  Copyright © 2017年 小森武史. All rights reserved.
//

import UIKit

class Block: NSObject, NSCoding {
    var userID: String!
    var userName: String!
    var createDate: Date!
    
    //ローカルで保存
    init(userID: String, userName: String) {
        self.userID = userID
        self.createDate = Date()
        self.userName = userName
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.userID = aDecoder.decodeObject(forKey: "userID") as! String
        self.createDate = aDecoder.decodeObject(forKey: "createDate") as! Date
        self.userName = aDecoder.decodeObject(forKey: "userName") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.userID, forKey: "userID")
        aCoder.encode(self.createDate, forKey: "createDate")
        aCoder.encode(self.userName, forKey: "userName")
    }
    
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
        let blockDataSource = UserDefaults.standard.object(forKey: "BLOCK_LIST") as! Array<Data>
        for block in blockDataSource {
            let d = NSKeyedUnarchiver.unarchiveObject(with: block) as! Block
            dataSource.append(d)
        }
        return dataSource
    }
    
    func deleteBlock() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "blockDelete"), object: nil)
    }
    
    static func checkBlockSomeone() {
      
    }
}
