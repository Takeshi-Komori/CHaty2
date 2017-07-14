//
//  SearchViewController.swift
//  ChatApp
//
//  Created by 小森武史 on 2017/06/20.
//  Copyright © 2017年 小森武史. All rights reserved.
//

import UIKit
import SVProgressHUD

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SearchCollectionViewCellDelegate, UIViewControllerTransitioningDelegate, SearchFilterViewDelegate ,UIPickerViewDelegate, UIPickerViewDataSource{
    
    let screenWidth = UIScreen.main.bounds.width
    let screeenHeight = UIScreen.main.bounds.height
    
    var searchCollectionView: UICollectionView?
    var refreshControl: UIRefreshControl!
    var userBox: [String : Any]!
    var dataSource: Array<User>!
    var indexPath: IndexPath!
    var user: User!
    var window: UIWindow! = nil
    var viewOnWindow: UIView!
    var searchFilterView: SearchFilterView!
    var researchButton: UIButton!
    var pickerView2: UIPickerView!
    var pickerItemsPlaceArray: [String]!
    var pickerToolbar: UIToolbar!
    var searchFlag: Bool!
    var isBlockingSomeone: Bool!
    var emptyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "ユーザーリスト"
//        self.isBlockingSomeone = Block.checkBlockSomeone()
        self.isBlockingSomeone = false
        let layout = UICollectionViewFlowLayout()
        let cellSize:CGFloat = self.view.frame.size.width / 2
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        
        self.searchCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        self.searchCollectionView?.delegate = self
        self.searchCollectionView?.dataSource = self
        self.searchCollectionView?.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: "SearchCollectionViewCell")
        
        searchCollectionView?.backgroundColor = UIColor.rgb(r: 241, g: 248, b: 255, alpha: 1.0)
        self.view.addSubview(searchCollectionView!)
        
        self.searchCollectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, (tabBarController?.tabBar.frame.size.height)!, 0)
        setupNavigationBarBtn()
        searchFlag = false
        getData()
        setupRefreshControl()
        setUpEmptyLabel()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(blockCreate),
                                               name: NSNotification.Name(rawValue: "blockCreate"),
                                            object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(blockDelete),
                                               name: NSNotification.Name(rawValue: "blockCreate"),
                                               object: nil)
    }
    
    func blockCreate() {
        self.isBlockingSomeone = true
    }
    
    func blockDelete() {
        if Block.readBlockDataSource().count != 0 {
            self.isBlockingSomeone = true
        }else {
             self.isBlockingSomeone = false
        }
    }
    
    func setupNavigationBarBtn() {
        let rightNavagationBarBtn = UIBarButtonItem(image: UIImage(named: "icons8-30"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(setUpSearchFilter))
        navigationItem.rightBarButtonItem = rightNavagationBarBtn
        rightNavagationBarBtn.tintColor = UIColor.white
        
        let leftNavagationBarBtn = UIBarButtonItem(image: UIImage(named: "icons8-reset30"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(getData))
        navigationItem.leftBarButtonItem = leftNavagationBarBtn
        leftNavagationBarBtn.tintColor = UIColor.white
    }
    
    func setUpSearchFilter() {
        if Me.sharedMe.isResistered() {
            window = UIWindow.init(frame: self.view.bounds)
            window.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            window.makeKeyAndVisible()
            showUpSearchFilter()
            setPickerView()
            searchFilterViewAnimation()
        } else {
            showAlert()
        }
    }
    
    func showUpSearchFilter() {
        searchFilterView = SearchFilterView(frame: CGRect(x: 50, y: screeenHeight, width: screenWidth - 100, height: screenWidth - 90))
        searchFilterView.backgroundColor = UIColor.white
        searchFilterView.delegate = self
        window.addSubview(searchFilterView)
        
        researchButton = UIButton(frame: CGRect(x: (screenWidth - 70) / 2, y: searchFilterView.bottom + 30, width: 70, height: 40))
        researchButton.backgroundColor = UIColor.rgb(r: 27, g: 149, b: 224, alpha: 1)
        researchButton.setTitle("検索", for: .normal)
        researchButton.addTarget(self, action: #selector(researchBtnTapped), for: UIControlEvents.touchDown)
        window.addSubview(researchButton)
    }
    
    func searchFilterViewAnimation() {
        UIView.animate(withDuration: 0.3) {
            self.searchFilterView.frame.origin.y = self.screeenHeight - self.screenWidth - 100
            self.researchButton.frame.origin.y = self.searchFilterView.bottom + 30
        }
    }
    
    func setUpEmptyLabel() {
        emptyLabel = UILabel(frame: CGRect(x: (UIScreen.main.bounds.width - 200) / 2,
                                           y: (UIScreen.main.bounds.height - 20) / 2 - 50,
                                           width: 200, height: 20))
        emptyLabel.textColor = UIColor.lightGray
        emptyLabel.textAlignment = NSTextAlignment.center
        emptyLabel.font = UIFont.systemFont(ofSize: 13)
        self.searchCollectionView?.addSubview(emptyLabel)
        
    }
    
    func setUpEmptyLabelValue() {
        if dataSource.count != 0 {
            emptyLabel.text = ""
        } else {
            emptyLabel.text = "ユーザーが見つかりません"
        }
    }
    
    func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        searchCollectionView?.addSubview(refreshControl)
    }
    
    func refresh() {
        User.readUsers(isBlockingSomeone: self.isBlockingSomeone, completionHandler: { dataSource in
            self.dataSource = dataSource as! Array<User>
            self.searchCollectionView?.reloadData()
            self.setUpEmptyLabelValue()
            self.refreshControl.endRefreshing()
        })
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func getData() {
        SVProgressHUD.show()
        User.readUsers(isBlockingSomeone: self.isBlockingSomeone, completionHandler: { dataSource in
            self.dataSource = dataSource as! Array<User>
            self.searchCollectionView?.reloadData()
            self.setUpEmptyLabelValue()
            SVProgressHUD.dismiss()
        })
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.dataSource != nil) ? self.dataSource.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        self.indexPath = indexPath as IndexPath
        let cell = searchCollectionView?.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell", for: indexPath) as! SearchCollectionViewCell
                
        cell.delegate = self
        //セルの画像が二重に表示されるのを防ぐ
        for subview in cell.contentView.subviews{
            subview.removeFromSuperview()
        }
        user = self.dataSource[indexPath.row] 
        cell.setValueUserInfo2(user: user)
        cell.setUI()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(ProfileViewController(), animated: true)
    }
    
    //delegate
    func imgViewTapped(cell: SearchCollectionViewCell) {
        let profileVC = ProfileViewController.init(user: cell.user)
        self.navigationController?.pushViewController(profileVC, animated: true)
    }

    func setPickerView() {
        pickerItemsPlaceArray = SourceItem.createPlaceArray2()
        pickerToolbar = UIToolbar(frame: CGRect.init(x: 0, y: screeenHeight, width: screenWidth, height: 30))
        let flexible = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let doneBtn = UIBarButtonItem(title: "完了", style: UIBarButtonItemStyle.plain, target: self, action: #selector(doneBtnTapped2))
        pickerToolbar.items = [flexible, doneBtn]
        self.window.addSubview(pickerToolbar)
        
        pickerView2 = UIPickerView(frame: CGRect(x: 0, y: screeenHeight + 30, width: screenWidth, height: 160))
        pickerView2.dataSource = self
        pickerView2.delegate = self
        pickerView2.backgroundColor = UIColor.gray
        self.window.addSubview(pickerView2!)
    }
    
    func doneBtnTapped2() {
        UIView.animate(withDuration: 0.2) {
            UIView.animate(withDuration: 0.2){
                self.pickerView2.frame.origin.y = self.screeenHeight + 30
                self.pickerToolbar.frame.origin.y = self.screeenHeight
            }
        }
    }
    
    //    pickerview
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerItemsPlaceArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // ここでラベル上のテキストだけを返す
        return pickerItemsPlaceArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.searchFilterView.placeLabel.text = pickerItemsPlaceArray[row]
        self.searchFilterView.placeLabelValue =  self.searchFilterView.placeLabel.text
    }
    
    //require
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //SearchFilterViewDelegate
    func cancelBtnTapped() {
        UIView.animate(withDuration: 0.3) {
            self.researchButton.frame.origin.y = self.screeenHeight + self.screenWidth - 70
            self.searchFilterView.frame.origin.y = self.screeenHeight
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                let window = UIApplication.shared.delegate?.window
                window??.makeKeyAndVisible()
            }
        }
    }
    
    func labelTapped() {
        UIView.animate(withDuration: 0.3) {
            self.pickerToolbar.frame.origin.y = self.screeenHeight - self.pickerView2.bounds.height - self.pickerToolbar.bounds.height
            self.pickerView2.frame.origin.y = self.screeenHeight - self.pickerView2.bounds.height
        }
    }
    
    //ブロックの時の挙動
    func researchBtnTapped() {
        SVProgressHUD.show()
        UserSpec.researchUserSpec(isBlocingSomeone: self.isBlockingSomeone, gender: self.searchFilterView.genderSegmentValue, age: self.searchFilterView.ageSegmentValue, place: self.searchFilterView.placeLabelValue, completionHandler: { (dataSource) in
            self.dataSource = dataSource as! Array<User>
            self.searchCollectionView?.reloadData()
            UIView.animate(withDuration: 0.3) {
                self.researchButton.frame.origin.y = self.screeenHeight + self.screenWidth - 70
                self.searchFilterView.frame.origin.y = self.screeenHeight
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    let window = UIApplication.shared.delegate?.window
                    window??.makeKeyAndVisible()
                    self.setUpEmptyLabelValue()
                    SVProgressHUD.dismiss()
                }
            }
        })
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
    
    deinit {
        print("呼ばれた")
    }
    
}
