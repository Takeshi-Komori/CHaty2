//
//  SearchCollectionViewCell.swift
//  ChatApp
//
//  Created by 小森武史 on 2017/06/24.
//  Copyright © 2017年 小森武史. All rights reserved.
//

import UIKit
import SDWebImage
import FirebaseStorage
import FirebaseStorageUI

protocol SearchCollectionViewCellDelegate {
    func imgViewTapped(cell: SearchCollectionViewCell)
}

class SearchCollectionViewCell: UICollectionViewCell {
    var profImageView: UIImageView!
    var delegate: SearchCollectionViewCellDelegate!
    let cellWidth = CGFloat( UIScreen.main.bounds.size.width - 1) / 2 ;
    
    var userName: String!
    var userGender: String!
    var userAge: String!
    var userPlace: String!
    var userBiography: String!
    var imageUserID: String!
    var user: User!
    
    func setUI() {
        profImageView = UIImageView(frame: CGRect(x: 10, y: 10, width: cellWidth - 20, height: cellWidth - 20))
//        profImageView.sd_setImage(with: User.returnImgStrorageRef(userID: user.userID))
        profImageView.sd_setImage(with: User.returnImgStrorageRef(userID: user.userID), placeholderImage: UIImage(named: "hinako.jpg"))
        profImageView.layer.cornerRadius = (cellWidth - 20) / 2
        profImageView.clipsToBounds = true
        profImageView.contentMode = UIViewContentMode.scaleAspectFill
        profImageView.isUserInteractionEnabled = true
        profImageView.tag = 1
        
        contentView.addSubview(profImageView)
        contentView.backgroundColor = UIColor.rgb(r: 241, g: 248, b: 255, alpha: 1)
    }
    
    func setValueUserInfo2(user: User) {
        self.user = user
        userName = user.name
        userGender = user.gender
        userAge = String(user.age)
        userPlace = user.place
        userBiography = user.biography
        imageUserID = user.userID
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let t: UITouch = touch as! UITouch
            if t.view?.tag == self.profImageView.tag {
                delegate.imgViewTapped(cell: self)
            }
        }
    }
    
}
