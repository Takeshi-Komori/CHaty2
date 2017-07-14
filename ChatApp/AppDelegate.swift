//
//  AppDelegate.swift
//  ChatApp
//
//  Created by 小森武史 on 2017/06/15.
//  Copyright © 2017年 小森武史. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch
        
        FirebaseApp.configure()
        
        let tabbarVC = TabbarViewController()
        tabbarVC.setTabbarController()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = tabbarVC
        
        UINavigationBar.appearance().barTintColor = UIColor.rgb(r: 27, g: 149, b: 224, alpha: 0)
        UITabBar.appearance().tintColor = UIColor.rgb(r: 27, g: 149, b: 224, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
//      //アプリ立ち上げ時に、ローカルにブロックの情報を追加
        if Me.sharedMe.isResistered() {
            UserDefaults.standard.removeObject(forKey: "BLOCK_LIST")
            Block.readBlockFromFirebase()
        }
        //リモート通知に登録する
        settingrRegisterRemoteNotifications(application: application)
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(tokenRefreshNotification),
                                               name: NSNotification.Name.InstanceIDTokenRefresh,
                                               object: nil)
        return true
    }
    
    func settingrRegisterRemoteNotifications(application: UIApplication) {
        //起動時またはアプリケーション フローの必要な時点で、リモート登録にアプリを登録します。次のように registerForRemoteNotifications を呼び出します。
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
            // For iOS 10 data message (sent via FCM)
            Messaging.messaging().remoteMessageDelegate = self as? MessagingDelegate
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
    }
    
    //token生成
    func createToken() {
        let token = InstanceID.instanceID().token()
        UserDefaults.standard.set(token, forKey: "token");
    }
    
    //token生成のモニタリング
    func tokenRefreshNotification(_ notification: Notification) {
        if let refreshedToken = InstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
            if UserDefaults.standard.object(forKey: "token") != nil {
                UserDefaults.standard.removeObject(forKey: "token")
            }
            UserDefaults.standard.set(refreshedToken, forKey: "token");
        }
        
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    
    func connectToFcm() {
        Messaging.messaging().connect { (error) in
            if error != nil {
                print("Unable to connect with FCM. \(String(describing: error))")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    
    func application(_ application: UIApplication,didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        createToken()
        Messaging.messaging().apnsToken = deviceToken
    }
    
    //フォアグラウンドの際に通知が来た場合
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        let statusHeight = UIApplication.shared.statusBarFrame.height
        
        let alertView = UIView.init(frame: CGRect(x: 0, y: -statusHeight - 44, width: UIScreen.main.bounds.width, height: statusHeight + 44))
        alertView.backgroundColor = UIColor.black
        window?.addSubview(alertView);
        let notificationLabel = UILabel.init(frame: CGRect(x: (UIScreen.main.bounds.width - 300) / 2, y: (alertView.frame.height - 20)/2 + 10, width: 300, height: 20));
        notificationLabel.text = "チャット : \(String(describing: userInfo["body"] as! String))"
        notificationLabel.textAlignment = NSTextAlignment.center
        notificationLabel.font = UIFont.systemFont(ofSize: 12)
        notificationLabel.textColor = UIColor.white
        alertView.addSubview(notificationLabel);
        
        UIView.animate(withDuration: 0.5) {
            alertView.frame.origin.y = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                UIView.animate(withDuration: 0.5, animations: {
                    alertView.frame.origin.y = -statusHeight - 44
                })
            }
        }
    }
    
    //iOS10でフォアグラウンドの際に通知が来た場合の処理
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
    
    //MessagigDelegateこれ実装しないとエラーが出る。
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

