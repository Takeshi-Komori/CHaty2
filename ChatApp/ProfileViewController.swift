//
//  ProfileViewController.swift
//  ChatApp
//
//  Created by 小森武史 on 2017/06/19.
//  Copyright © 2017年 小森武史. All rights reserved.
//

import UIKit


class ProfileViewController: UIViewController , ProfileViewDelegate {
    var profileImageView: UIImageView!
    var profileView: ProfileView!
    let editVC: ProfileEditViewController? = nil
    var isMe: Bool!
    var isAfterSavingProfile: Bool!
    var isAfterDeletingProfile: Bool!
    var user: User!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nil, bundle: nil)
        
    }
    
    convenience init(user: User) {
        self.init(nibName: nil, bundle: nil)
        self.user = user
        isAfterSavingProfile = false
        isAfterDeletingProfile = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = user.name == "" ? "未設定" : user.name
        profileView = ProfileView()
        profileView.frame = view.frame
        profileView.setUI2(user: self.user, isMe: isMyPage())
        profileView.delegate = self
        self.view.addSubview(profileView)
        
        navigationBarBtnSetup()
        // Do any additional setup after loading the view.
    }
    
    func navigationBarBtnSetup() {
        if isMyPage() {
            let rightBarButtonItem = UIBarButtonItem(title: "設定", style: UIBarButtonItemStyle.plain, target: self, action: #selector(rightBarbuttonTapped(sender:)))
            rightBarButtonItem.tintColor = UIColor.white
            self.navigationItem.rightBarButtonItem = rightBarButtonItem
        } else {
            navigationItem.setHidesBackButton(true, animated: false)
            let leftBarButtonItem = UIBarButtonItem(title: "戻る", style: UIBarButtonItemStyle.plain, target: self, action: #selector(leftBarbuttonTapped(sender:)))
            leftBarButtonItem.tintColor = UIColor.white
            self.navigationItem.leftBarButtonItem = leftBarButtonItem
            
            let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icons8-danger-30"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(rightBarbuttonTapped(sender:)))
            rightBarButtonItem.tintColor = UIColor.white
            self.navigationItem.rightBarButtonItem = rightBarButtonItem
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isAfterSavingProfile || isAfterDeletingProfile {
            profileView.setValueUserInfo2(user: Me.sharedMe.returnMe4User())
            profileView.setSeparateImageDependentUser(isMe: isMyPage(), orAfterDeleting: isAfterDeletingProfile)
            navigationItem.title = Me.sharedMe.returnInfo(key: "name") as? String
            isAfterSavingProfile = false
            isAfterDeletingProfile = false
        }
    }
    
    func profileEditBtnTapped() {
        let profileEditVC = ProfileEditViewController()
        let naviVC = UINavigationController(rootViewController: profileEditVC)
        self.navigationController?.present(naviVC, animated: true, completion: nil)
    }
    
    func talkingBtnTapped() {
        if Me.sharedMe.isResistered() {
            let messageVC = MessagesViewController.init(user: self.user)
            messageVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(messageVC, animated: true)
        } else {
            showAlert()
        }
    }
    
    func rightBarbuttonTapped(sender: UIButton) {
        if isMyPage() {
            let settingVC = SettingTableViewController()
            let naviVC = UINavigationController(rootViewController: settingVC)
            self.navigationController?.present(naviVC, animated: true, completion: nil)
        } else {
            if Me.sharedMe.isResistered() {
                ReportUtil.reportAlert(vc: self, user: self.user)
            }else {
                showAlert()
            }
        }
    }
    
    func leftBarbuttonTapped(sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func isMyPage() -> Bool {
        return (user.userID == "00000000-0000-0000-0000-000000000000" && !Me.sharedMe.isResistered())
            || (Me.sharedMe.isResistered() && Me.sharedMe.returnInfo(key: "userID") as! String == user.userID)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlert() {
        let alert = UIAlertController(title:"登録してください", message: "この機能はまだ使えません", preferredStyle: UIAlertControllerStyle.alert)
        
        let action = UIAlertAction(title: "登録する", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            let profileEditVC = ProfileEditViewController()
            let navi = UINavigationController(rootViewController: profileEditVC)
            self.present(navi, animated: true, completion: nil)
        })
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
