//
//  SendNotificationHelper.swift
//  ChatApp
//
//  Created by KomoriTakeshi on 2017/07/10.
//  Copyright © 2017年 小森武史. All rights reserved.
//

import UIKit
import Alamofire

class SendNotificationHelper: NSObject {
    static let API_URL = "https://fcm.googleapis.com/fcm/send"
    static let FB_DEVELOP_SERVER_KEY = "AAAA5MD6prc:APA91bHsTFGm7-Bl4vFu3XJauQ4z_sAvf_B-JYG-x4pcXzMirRmATDvwF7lpB-VxOsRimZXwu5cT10UtM76oiZ7CLg8SdofN5AeHyBFLWXbBYwds1u8XigvY_bnII3j2k6aYLGMu5wAg"
    
    static func sendNotification(contents: String, token: String, userName: String) {
         print(token)
        
        let notificationDetail = [
            "body" : contents,
            "title" : userName
        ]
        let data = [
            "to" : token,
            "notification" : notificationDetail,
            "data" : notificationDetail,
            "priority" : "high"
        ] as [String : Any]


        let headers: HTTPHeaders = [
            "Authorization":"key=" + FB_DEVELOP_SERVER_KEY,
            "Content-Type": "application/json"
        ]
                
        Alamofire.request(API_URL, method: .post, parameters: data, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .failure(let error) :
                print(error)
            case .success(let success) :
                print(success)
            }
        }
    }

}
