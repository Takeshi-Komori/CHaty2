//
//  BlockListTableViewCell.swift
//  ChatApp
//
//  Created by KomoriTakeshi on 2017/07/07.
//  Copyright © 2017年 小森武史. All rights reserved.
//

import UIKit

class BlockListTableViewCell: UITableViewCell {
    var userImageView: UIImageView?
    var nameLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setUI(userName: String, userID: String) {
        userImageView = UIImageView(frame: CGRect(x: 5, y: 10, width: 40, height: 40))
        userImageView?.sd_setImage(with: User.returnImgStrorageRef(userID: userID))
        userImageView?.layer.cornerRadius = 20
        userImageView?.clipsToBounds = true
        userImageView?.contentMode = UIViewContentMode.scaleAspectFill
        self.contentView.addSubview(userImageView!)
        
        nameLabel = UILabel(frame: CGRect(x: (userImageView?.right)! + 10, y: (userImageView?.top)!, width: 200, height: 20))
        nameLabel?.text = userName
        nameLabel?.font = UIFont.systemFont(ofSize: 14)
        self.contentView.addSubview(nameLabel!)
        
    }

}
