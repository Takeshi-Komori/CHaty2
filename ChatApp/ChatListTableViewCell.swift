//
//  ChatListTableViewCell.swift
//  ChatApp
//
//  Created by 小森武史 on 2017/06/21.
//  Copyright © 2017年 小森武史. All rights reserved.
//

import UIKit
import FirebaseStorageUI

class ChatListTableViewCell: UITableViewCell {
    var userImageView: UIImageView?
    var nameLabel: UILabel?
    var messageLabel: UILabel?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUI(user: User, message: String) {
        userImageView = UIImageView(frame: CGRect(x: 5, y: 10, width: 40, height: 40))
        userImageView?.sd_setImage(with: User.returnImgStrorageRef(userID: user.userID))
        userImageView?.layer.cornerRadius = 20
        userImageView?.clipsToBounds = true
        userImageView?.contentMode = UIViewContentMode.scaleAspectFill
        self.contentView.addSubview(userImageView!)
        
        nameLabel = UILabel(frame: CGRect(x: (userImageView?.right)! + 10, y: (userImageView?.top)!, width: 200, height: 20))
        nameLabel?.text = user.name
        nameLabel?.font = UIFont.systemFont(ofSize: 14)
        self.contentView.addSubview(nameLabel!)
        
//        messageLabel = UILabel(frame: CGRect(x: (userImageView?.right)! + 10, y: (nameLabel?.bottom)! + 4, width: 200, height: 15))
//        messageLabel?.text = message
//        messageLabel?.textColor = UIColor.lightGray
//        messageLabel?.font = UIFont.systemFont(ofSize: 13)
//        self.contentView.addSubview(messageLabel!)
   
    }

}
