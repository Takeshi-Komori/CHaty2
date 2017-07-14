//
//  MessagesViewController.swift
//  ChatApp
//
//  Created by 小森武史 on 2017/06/21.
//  Copyright © 2017年 小森武史. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase
import SVProgressHUD
import FirebaseStorageUI

class MessagesViewController: JSQMessagesViewController {

    var messages: [JSQMessage]?
    
    var incomingBubble: JSQMessagesBubbleImage!
    var outgoingBubble: JSQMessagesBubbleImage!
    var incomingAvatar: JSQMessagesAvatarImage!
    var outgoingAvatar: JSQMessagesAvatarImage!
    
    var opponentUser: User!
    var me: User!
    var chatroom: Chatroom!
    var chatroomUserIDs: Set<String>!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(user: User) {
        self.init(nibName: nil, bundle: nil)
        opponentUser = user
        me = Me.sharedMe.returnMe4User()
        chatroomUserIDs = [opponentUser.userID, me.userID]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callOrMakeChatroom()
        navigationItem.title = opponentUser.name
        
        senderId = me.userID
        senderDisplayName = me.name
        
        //吹き出しの設定
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        self.incomingBubble = bubbleFactory?.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
        self.outgoingBubble = bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
        
        //アバターの設定
        self.incomingAvatar = JSQMessagesAvatarImageFactory.avatarImage(with: Me.sharedMe.returnLocalImage(), diameter: 64)
        setUpOutgoingAvatarImg()
        messages = []
        setBarButtonItem()
        // Do any additional setup after loading the view.
    }
    
    func setBarButtonItem() {
        navigationItem.setHidesBackButton(true, animated: false)
        let leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(tapLeftBarButton(sender:)))
        leftBarButtonItem.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let rightBarBtnItem = UIBarButtonItem(image: UIImage(named: "icons8-danger-30"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(reportAlert))
        rightBarBtnItem.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = rightBarBtnItem
    }
    
    func tapLeftBarButton(sender: UIBarButtonItem) {
        if messages?.count == 0 && chatroom.isAlreadyCreated != true {
//            Chatroom().deleteChatroom(opponentUserID2: opponentUser.userID, chatroomID: opponentUser.chatroomID)
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func setUpMessage() {
        Message.messageSetupFirebase(chatroomID: chatroom.chatRoomID!, myname: me.name) { (message) in
            self.messages?.append(message)
            self.finishReceivingMessage()
        }
    }
    
    func setUpOutgoingAvatarImg() {
        if UserDefaults.standard.object(forKey: self.opponentUser.userID) != nil {
            self.outgoingAvatar = JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(data: UserDefaults.standard.object(forKey: self.opponentUser.userID) as! Data), diameter: 64)
        }else {
            SVProgressHUD.show()
            let imgRef = User.returnImgStrorageRef(userID: opponentUser.userID)
            imgRef.getData(maxSize: 1 * 4000 * 4000) { (data, error) in
                if error != nil {
                    self.outgoingAvatar = JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "hinako.jpg"), diameter: 64)
                    self.collectionView.reloadData()
                    SVProgressHUD.dismiss()
                    return
                }
                self.outgoingAvatar = JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(data: data!), diameter: 64)
                self.collectionView.reloadData()
                SVProgressHUD.dismiss()
                
            }
        }
    }
    
    private func callOrMakeChatroom() {
        Chatroom.readChatroom(userIDs: chatroomUserIDs) { (chatroom) in
            self.chatroom = chatroom
            self.opponentUser.chatroomID = chatroom.chatRoomID
            self.setUpMessage()
        }
    }
    
    func sendTextToDb(text: String) {
        Message.createMessage(message: text, senderID: self.senderId, chatroomID: chatroom.chatRoomID!)
        SendNotificationHelper.sendNotification(contents: text, token: opponentUser.token, userName: opponentUser.name)
        self.inputToolbar.contentView.textView.text = ""
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return self.messages![indexPath.item]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = self.messages?[indexPath.item]
        if message?.senderId == self.senderId {
            return self.outgoingBubble
        }
        return self.incomingBubble
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        if messages?[indexPath.row].senderId == senderId {
            cell.textView?.textColor = UIColor.white
        } else {
            cell.textView?.textColor = UIColor.darkGray
        }
        return cell
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        //senderId == 自分　だった場合表示しない
        let senderId = messages?[indexPath.item].senderId
        if senderId == me.userID {
            return self.incomingAvatar
        }
        //        return JSQMessagesAvatarImage.avatar(with: UIImage(named: "keita"))
        return self.outgoingAvatar
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        self.finishReceivingMessage(animated: true)
        sendTextToDb(text: text)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.messages!.count)
    }
    
    @objc func reportAlert() {
        ReportUtil.reportAlert(vc: self, user: opponentUser, isOnChatroom: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
