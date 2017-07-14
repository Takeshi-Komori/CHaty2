//
//  BlockTableViewController.swift
//  ChatApp
//
//  Created by 小森武史 on 2017/06/25.
//  Copyright © 2017年 小森武史. All rights reserved.
//

import UIKit

class BlockTableViewController: UITableViewController {
    var emptyLabel: UILabel!
    var blockDataSource: Array<Block>!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "ブロックリスト"
        //ローカルにあるBlockリストを呼び出す
        createBlockDataSourceInVC()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView = UITableView(frame: self.tableView.frame, style: .grouped)
        tableView.register(BlockListTableViewCell.self, forCellReuseIdentifier: "BlockListTableViewCell")
        tableView.backgroundColor = UIColor.rgb(r: 241, g: 248, b: 255, alpha: 1.0)
        setEmptyLabel()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(blockCreate),
                                               name: NSNotification.Name(rawValue: "blockCreate"),
                                               object: nil)
        self.setUpNavigationBarItemBtn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingEmtptyLabelText()
    }
    
    func blockCreate() {
        tableView.reloadData()
    }
    
    func refresh() {

    }
    
    func createBlockDataSourceInVC() {
        let dataSource = Block.readBlockDataSource()
        var dataSource2 = Array<Block>()
        for d in dataSource {
            if d.isfromMe != "false" {
                dataSource2.append(d)
            }
        }
        self.blockDataSource = dataSource2
        
    }
    
    func setUpNavigationBarItemBtn() {
        navigationItem.setHidesBackButton(true, animated: false)
        let leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(tapLeftBarButton(sender:)))
        leftBarButtonItem.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    func tapLeftBarButton(sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    

    func setEmptyLabel() {
        emptyLabel = UILabel(frame: CGRect(x: (UIScreen.main.bounds.width - 200) / 2,
                                           y: (UIScreen.main.bounds.height - 20) / 2 - 50,
                                           width: 200, height: 20))
        emptyLabel.textColor = UIColor.lightGray
        emptyLabel.textAlignment = NSTextAlignment.center
        emptyLabel.font = UIFont.systemFont(ofSize: 13)
        self.tableView.addSubview(emptyLabel)
    }
    
    func settingEmtptyLabelText() {
        if blockDataSource == nil || blockDataSource.count == 0 {
            emptyLabel.text = "ブロック中のユーザーはいません"
        } else {
            emptyLabel.text = ""
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return blockDataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BlockListTableViewCell = BlockListTableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "BlockListTableViewCell")
        if blockDataSource.count > 0 {
            cell.setUI(userName: blockDataSource[indexPath.row].userName, userID: blockDataSource[indexPath.row].userID)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Block.deleteBlockData(userID: self.blockDataSource[indexPath.row].userID)
            self.blockDataSource.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            blockDataSource = Block.readBlockDataSource()
            settingEmtptyLabelText()
            tableView.reloadData()
        }
    }
    
    deinit {
        
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
