//
//  ReportUtil.swift
//  ChatApp
//
//  Created by KomoriTakeshi on 2017/07/06.
//  Copyright © 2017年 小森武史. All rights reserved.
//

import UIKit

class ReportUtil: NSObject {
    static func reportAlert(vc: UIViewController, user: User, isOnChatroom: Bool) {
        let actionSheet = UIAlertController(title: "ユーザーレポート", message: "以下から選択してください", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let action1 = UIAlertAction(title: "ユーザー通報する", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            
        })
        
        let action2 = UIAlertAction(title: "ブロックする", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            print(user)
            let block = Block.init(userID: user.userID, userName: user.name)
            block.createBlock(userID: user.userID, userName: user.name)
            Block.saveBlock(block: block)
            
            if isOnChatroom {
                Chatroom().deleteChatroom(opponentUserID2: user.userID, chatroomID: user.chatroomID)
            }
        
        })
        
        let cancel = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler: {
            (action: UIAlertAction!) in
        })
        
        actionSheet.addAction(action1)
        actionSheet.addAction(action2)
        actionSheet.addAction(cancel)
        
        vc.present(actionSheet, animated: true, completion: nil)
    }
    
    
    
    
    
}
