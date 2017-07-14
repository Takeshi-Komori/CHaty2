//
//  ProfileView.swift
//  ChatApp
//
//  Created by 小森武史 on 2017/06/24.
//  Copyright © 2017年 小森武史. All rights reserved.
//

import UIKit

protocol ProfileViewDelegate {
    func profileEditBtnTapped()
    func talkingBtnTapped()
}

class ProfileView: UIView {
    let screenWidth = CGFloat( UIScreen.main.bounds.size.width);

    var delegate: ProfileViewDelegate?
    var me: NSDictionary?
    
    //Labalの値
    var name: String!
    var gender: String!
    var age: String!
    var place: String!
    var biography: String!
    
    //諸々部品
    var profImageView: UIImageView!
    var funcButton: UIButton!
    var nameLabel: UILabel!
    var genderLabel: UILabel!
    var ageLabel: UILabel!
    var placeLabel: UILabel!
    var biographyTextView: UITextView!
    var user: User!
    
    func profileEditBtnTap(sender: UIButton) {
        self.delegate?.profileEditBtnTapped()
    }
    
    func talkingBtn(sender: UIButton) {
        self.delegate?.talkingBtnTapped()
    }
    
    func setValueUserInfo2(user: User) {
        self.user = user
        genderLabel.text = user.gender != "" ? user.gender : "未設定"
        ageLabel.text = user.age != 0 ? String(user.age) : "未設定"
        placeLabel.text = user.place != "" ? user.place : "未設定"
        biographyTextView.text = user.biography != "" ? user.biography : "未設定"
    }
    
    func setUI2(user: User, isMe: Bool) {
        self.backgroundColor = UIColor.rgb(r: 241, g: 248, b: 255, alpha: 1.0)
        
        profImageView = UIImageView(frame: CGRect(x: (self.frame.width - 150)/2, y: 85, width: 150, height: 150))
        profImageView.layer.cornerRadius = 75
        profImageView.clipsToBounds = true
        profImageView.contentMode = UIViewContentMode.scaleAspectFill
        self.addSubview(profImageView)
        
        funcButton = UIButton(frame: CGRect(x: (self.frame.width - 200)/2, y: profImageView.bottom + 30, width: 200, height: 30))
        funcButton.backgroundColor = UIColor.rgb(r: 27, g: 149, b: 224, alpha: 1.0)
        funcButton.layer.cornerRadius = 3.0
        self.addSubview(funcButton)
        
        let horizontalLine = UIView(frame: CGRect(x: 0, y: funcButton.bottom + 30, width: screenWidth, height: 0.3))
        horizontalLine.backgroundColor = UIColor.rgb(r: 192, g: 192, b: 192, alpha: 1.0)
        self.addSubview(horizontalLine)
        
        genderLabel = UILabel(frame: CGRect(x: funcButton.left, y: horizontalLine.bottom + 30, width: 70, height: 15))
        genderLabel.textColor = UIColor.rgb(r: 192, g: 192, b: 192, alpha: 1.0)
        genderLabel.textAlignment = NSTextAlignment.center
        genderLabel.font = UIFont.systemFont(ofSize: 13)
        self.addSubview(genderLabel)
        
        ageLabel = UILabel(frame: CGRect(x: genderLabel.right, y: genderLabel.top, width: 60, height: 15))
        ageLabel.textColor = UIColor.rgb(r: 192, g: 192, b: 192, alpha: 1.0)
        ageLabel.textAlignment = NSTextAlignment.center
        ageLabel.font = UIFont.systemFont(ofSize: 13)
        self.addSubview(ageLabel)
        
        placeLabel = UILabel(frame: CGRect(x: ageLabel.right, y: genderLabel.top, width: 70, height: 15))
        placeLabel.textColor = UIColor.rgb(r: 192, g: 192, b: 192, alpha: 1.0)
        placeLabel.textAlignment = NSTextAlignment.center
        placeLabel.font = UIFont.systemFont(ofSize: 13)
        self.addSubview(placeLabel)
        
        biographyTextView = UITextView(frame: CGRect(x: 50, y: genderLabel.bottom + 20, width: screenWidth - 100, height: 200))
        biographyTextView.backgroundColor = UIColor.clear
        biographyTextView.textColor = UIColor.rgb(r: 192, g: 192, b: 192, alpha: 1.0)
        biographyTextView.textAlignment = NSTextAlignment.center
        biographyTextView.font = UIFont.systemFont(ofSize: 13)
        biographyTextView.isEditable = false
        self.addSubview(biographyTextView)
        
        setValueUserInfo2(user: user)
        separateUIDependentUser(isMe: isMe)
    }
    
    func separateUIDependentUser(isMe: Bool) {
        if isMe {
            funcButton.addTarget(self, action: #selector(profileEditBtnTap(sender:)), for: .touchUpInside)
            setSeparateImageDependentUser(isMe: isMe, orAfterDeleting: false)
        }else {
            funcButton.setTitle("トークする", for: .normal)
            funcButton.addTarget(self, action: #selector(talkingBtn(sender:)), for: .touchUpInside)
            setSeparateImageDependentUser(isMe: isMe, orAfterDeleting: false)
        }
    }
    
    func setSeparateImageDependentUser(isMe: Bool, orAfterDeleting: Bool) {
        if isMe || orAfterDeleting {
            if Me.sharedMe.isResistered() {
                funcButton.setTitle("プロフ編集する", for: .normal)
            } else {
                funcButton.setTitle("新規登録する", for: .normal)
            }
            profImageView.image = Me.sharedMe.returnLocalImage()
        } else {
            profImageView.sd_setImage(with: User.returnImgStrorageRef(userID: user.userID), placeholderImage: UIImage(named: "hinako.jpg"))
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
