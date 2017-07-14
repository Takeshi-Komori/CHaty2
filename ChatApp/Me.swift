//
//  User.swift
//  ChatApp
//
//  Created by 小森武史 on 2017/06/24.
//  Copyright © 2017年 小森武史. All rights reserved.
//

import UIKit
import Firebase

class Me: NSObject {
    var userDefaults = UserDefaults.standard
    let ref = Database.database().reference()
    let storageRef = Storage.storage().reference(forURL: "gs://chaty-d559d.appspot.com")
    var imageHaving: Bool!
    
    class var sharedMe : Me {
        struct Static {
            static let instance : Me = Me()
        }
        return Static.instance
    }
    
    func createMe(name: String, gender: String, age: Int, place: String, biography: String) {
        let uuid = NSUUID().uuidString
        imageHaving = false
        let date = DateUtil.createDate()
        
        //要検討
        let local_params = [
            "info": [
            "name": name,
            "gender": gender,
            "age": age,
            "place": place,
            "biography": biography,
            "token" : UserDefaults.standard.object(forKey: "token")!
            ],
            "userID": uuid
        ] as [String : AnyObject]
        
        userDefaults.set(local_params, forKey: "ME")
        
        let remote_params = [
            "info": [
            "name": name,
            "gender": gender,
            "age": age,
            "place": place,
            "biography": biography,
            "token" : UserDefaults.standard.object(forKey: "token")!
            ],
            "otherInfo" : [
            "deleteFlg": false,
            "logindate" : date,
            "createDate" : date
            ]] as [String : AnyObject]
        
        self.ref.child("users").child(uuid).setValue(remote_params)
        
        //profile画像アップロード
        uploadimage(userID: uuid, editImage: true)
        
        //サーチのために使うデータ
        UserSpec.createUserSpecData((gender: gender, age: age, place: place, userID: uuid))
    }
    
    func updateMe(name: String, gender: String, age: Int, place: String, biography: String, editImage: Bool) {
        let userID: String = Me.sharedMe.returnInfo(key: "userID") as! String
        imageHaving = userDefaults.object(forKey: "ME_IMAGE") != nil ? true : false
        UserSpec.updateSpecData(gender: gender, age: age, place: place)
        let me = [
            "info":[
            "name": name,
            "gender": gender,
            "age": age,
            "place": place,
            "biography": biography,
            "token" : UserDefaults.standard.object(forKey: "token")
            ],
            "userID" : userID
            ] as [String : Any]
        
        //local
        userDefaults.set(me, forKey: "ME")
        
        let userInfo = [
                    "name": name,
                    "gender": gender,
                    "age": age,
                    "place": place,
                    "biography": biography,
                    "token" : UserDefaults.standard.object(forKey: "token") as! String
            ] as [String : Any]
        
        let childUpdates = ["/users/\(userID)/info" : userInfo]
        
        ref.updateChildValues(childUpdates)
        //profile画像アップロード
        uploadimage(userID: userID, editImage: editImage)
    }
    
    func deleteMe() {
        let userID: String = middleUpdating()
        self.ref.child("users").child(userID).removeValue()
        self.ref.child("blocks").child(userID).removeValue()
        UserSpec.deleteUserSpecData()
    }
    
    func uploadimage(userID: String, editImage: Bool) {
        if editImage != true {
            return
        }
        let riversRef = storageRef.child("profile_image/\(userID).png")
        //登録している画像を削除してから、登録
        if imageHaving != false {
            riversRef.delete(completion: { (error) in
                if error != nil {
                    print("error")
                }else {
                    riversRef.putData(self.userDefaults.object(forKey: "ME_IMAGE") as! Data, metadata: nil)
                }
            })
        }else {
            riversRef.putData(self.userDefaults.object(forKey: "ME_IMAGE") as! Data, metadata: nil)
        }
    }
 
// ----------------------------------------------------この辺書き換えるーーーーーーーーーーーーー
    func isResistered() -> Bool {
        if userDefaults.object(forKey: "ME") != nil {
            return true
        }
        return false
    }
    
    private func middleUpdating() -> String {
        let myInfo: [String : Any] = userDefaults.object(forKey: "ME") as! [String : Any]
        if userDefaults.object(forKey: "ME_IMAGE") != nil {
            userDefaults.removeObject(forKey: "ME_IMAGE")
            storageRef.child("profile_image/\(Me.sharedMe.returnInfo(key: "userID")).png").delete(completion: { (error) in
                if error != nil {
                 print("error")
                }
            })
        }
        userDefaults.removeObject(forKey: "ME")
        return myInfo["userID"] as! String
    }
    
    func returnInfo(key: String) -> AnyObject {
        if isResistered() {
            let userInfo = userDefaults.object(forKey: "ME") as! [String : Any]
            if key == "userID" {
                return userInfo["userID"] as AnyObject
            }
            let info = userInfo["info"] as! [String : AnyObject]
            return info[key] as AnyObject
        }
        return "未設定" as AnyObject
    }
    
    func resisterLocalImage(image: UIImage) {
        if let data = UIImagePNGRepresentation(image) {
            userDefaults.set(data, forKey: "ME_IMAGE")
        }
    }
    
    func returnLocalImage() -> UIImage {
        userDefaults = UserDefaults.standard
        let image: UIImage = ((userDefaults.object(forKey: "ME_IMAGE") != nil) ? UIImage(data: userDefaults.object(forKey: "ME_IMAGE") as! Data) : UIImage(named: "hinako.jpg"))!
        print(image)
        return image
    }
// ----------------------------------------------------
    
    
    func returnMe4User() -> User {
        var me: User!
        if isResistered() {
            
            
            let userInfo = userDefaults.object(forKey: "ME") as! [String : Any]
            me = User(attributed: userInfo as [String : AnyObject], key: userInfo["userID"] as! String)
            return me
        }
        let defalut_params = [
            "info": [
                "name": "",
                "gender": "",
                "age": 0,
                "place": "",
                "biography": "",
                "token" : ""
            ]] as [String : AnyObject]
        me = User(attributed: defalut_params, key: "00000000-0000-0000-0000-000000000000")
        return me
    }
    
    
}
