//
//  SettingTableViewController.swift
//  ChatApp
//
//  Created by 小森武史 on 2017/06/19.
//  Copyright © 2017年 小森武史. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {
    
    let settingTitles4Cell = [
        ["プロフィール編集", "ブロックリスト"],
        ["お問い合わせ", "アカウント削除"]
    ]
    
    let settingTitles4Section = ["メイン","サブ"]
    
    func returnPage(sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "設定"
        self.tableView = UITableView(frame: self.tableView.frame, style: .grouped)
         self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingTableViewCell")
        
        let leftBarbuttonItem = UIBarButtonItem(title: "戻る", style: UIBarButtonItemStyle.plain, target: self, action: #selector(returnPage(sender:)))
        leftBarbuttonItem.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = leftBarbuttonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.settingTitles4Cell.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.settingTitles4Cell[section].count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) 
        
        cell.textLabel?.text = self.settingTitles4Cell[indexPath.section][indexPath.row]
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settingTitles4Section[section]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
            case 0:
                let profileEditVC = ProfileEditViewController()
                self.navigationController?.pushViewController(profileEditVC, animated: true)
            case 1:
                print("")
                let blockListTableVC = BlockTableViewController()
                self.navigationController?.pushViewController(blockListTableVC, animated: true)
            default:
                break
            }
        case 1:
            switch (indexPath.row) {
            case 0:
                print("")
            case 1:
                showAlert()
            default:
                print("")
            }
        default:
            print("")
        }
    }
    
    func showAlert() {
        var alert: UIAlertController!
        var action: UIAlertAction!
        var cancel: UIAlertAction!
        if Me().isResistered() {
            alert = UIAlertController(title:"アカウント削除しますか？", message: "全てのデータが削除されます", preferredStyle: UIAlertControllerStyle.alert)
            
            action = UIAlertAction(title: "削除する", style: UIAlertActionStyle.default, handler: {
                (action: UIAlertAction!) in
                let tab = self.presentingViewController as! TabbarViewController
                for navi in tab.viewControllers! {
                    if navi.childViewControllers[0] is ProfileViewController {
                        let profileVC = navi.childViewControllers[0] as! ProfileViewController
                        profileVC.isAfterDeletingProfile = true
                    }
                }
                Me.sharedMe.deleteMe()
            })
            cancel = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.default, handler: {
                (action: UIAlertAction!) in
                print("キャンセルをタップした時の処理")
            })
            alert.addAction(cancel)
        } else {
            alert = UIAlertController(title:"この操作はできません", message: "アカウントを登録している必要があります", preferredStyle: UIAlertControllerStyle.alert)
            
            action = UIAlertAction(title: "了解", style: UIAlertActionStyle.default, handler: {
                (action: UIAlertAction!) in
                print("アクション１をタップした時の処理")
            })

        }
        
        alert.addAction(action)
        
        
        self.present(alert, animated: true, completion: nil)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
