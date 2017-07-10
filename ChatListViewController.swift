//
//  ChatListViewController.swift
//  ChatApp
//
//  Created by 小森武史 on 2017/06/21.
//  Copyright © 2017年 小森武史. All rights reserved.
//

import UIKit
import SVProgressHUD

class ChatListViewController: UITableViewController {

//    let messageTexts = ["あ","い","y","lllllゃ","kkk"]
    var chatroomBox: [String]!
    let screenWidth = CGFloat( UIScreen.main.bounds.size.width);
    let screenHeight = CGFloat( UIScreen.main.bounds.size.height);
    var emptyLabel: UILabel!
    var dataSource: [User]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "チャットリスト"
        tableView.delegate = self
        tableView.dataSource = self
        tableView = UITableView(frame: self.tableView.frame, style: .grouped)
        tableView.register(ChatListTableViewCell.self, forCellReuseIdentifier: "ChatListTableViewCell")
        tableView.backgroundColor = UIColor.rgb(r: 241, g: 248, b: 255, alpha: 1.0)
        
        emptyLabel = UILabel(frame: CGRect(x: (screenWidth - 200) / 2, y: (screenHeight - 20) / 2 - 50, width: 200, height: 20))
        emptyLabel.textColor = UIColor.lightGray
        emptyLabel.textAlignment = NSTextAlignment.center
        emptyLabel.font = UIFont.systemFont(ofSize: 13)
        self.view.addSubview(emptyLabel)

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getChatroomDataSource2()
    }
    
    private func settingEmtptyLabelText() {
        if dataSource == nil || dataSource.count == 0 {
            emptyLabel.text = "まだチャットルームがありません"
        } else {
            emptyLabel.text = ""
        }
    }
    
    private func getChatroomDataSource2() {
        SVProgressHUD.show()
        Chatroom.readChatroomIDFromUser { (dataSource) in
            self.dataSource = dataSource
            self.settingEmtptyLabelText()
            self.tableView.reloadData()
            SVProgressHUD.dismiss()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource != nil ? dataSource.count : 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ChatListTableViewCell = ChatListTableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "ChatListTableViewCell") 
        if dataSource.count > 0 {
//            cell.setUI(user: dataSource[indexPath.row], message: messageTexts[indexPath.row])
            cell.setUI(user: dataSource[indexPath.row], message: "")
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MessagesViewController(user: dataSource[indexPath.row])
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Chatroom().deleteChatroom(opponentUserID2: dataSource[indexPath.row].userID, chatroomID: dataSource[indexPath.row].chatroomID)
            self.dataSource.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
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
