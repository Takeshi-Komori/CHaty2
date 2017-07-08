//
//  TabbarViewController.swift
//  ChatApp
//
//  Created by 小森武史 on 2017/06/24.
//  Copyright © 2017年 小森武史. All rights reserved.
//

import UIKit

class TabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setTabbarController()  {
        var viewControllers = [UIViewController]()
        
        let firstVC = SearchViewController()
        firstVC.tabBarItem = UITabBarItem(title: "検索", image: UIImage(named: "icons8-Search-50"), selectedImage: UIImage(named: "icons8-Search_Filled-50"))
        firstVC.tabBarItem.tag = 1
        let firstNaviVC = UINavigationController(rootViewController: firstVC)
        viewControllers.append(firstNaviVC)
        
        let secondVC = ChatListViewController()
        secondVC.tabBarItem = UITabBarItem(title: "トーク", image: UIImage(named: "icons8-Message-50"), selectedImage: UIImage(named: "icons8-Message_Filled-50"))
        secondVC.tabBarItem.tag = 2
        let secondNaviVC = UINavigationController(rootViewController: secondVC)
        viewControllers.append(secondNaviVC)
        
        let thirdVC = ProfileViewController(user: Me.sharedMe.returnMe4User())
        thirdVC.tabBarItem = UITabBarItem(title: "プロフ", image: UIImage(named: "icons8-User-50"), selectedImage: UIImage(named: "icons8-User_Filled-50"))
        thirdVC.tabBarItem.tag = 3
        
        let thirdNaviVC = UINavigationController(rootViewController: thirdVC)
        viewControllers.append(thirdNaviVC)
        
        self.setViewControllers(viewControllers, animated: true)
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
