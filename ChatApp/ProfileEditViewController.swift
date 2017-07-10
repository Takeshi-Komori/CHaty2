//
//  ProfileEditViewController.swift
//  ChatApp
//
//  Created by 小森武史 on 2017/06/24.
//  Copyright © 2017年 小森武史. All rights reserved.
//

import UIKit
import SVProgressHUD

class ProfileEditViewController: UITableViewController ,UIPickerViewDelegate, UIPickerViewDataSource, ImageEditTableViewCellDelegate, UIImagePickerControllerDelegate, NameEditTableViewCellDelegate, UINavigationControllerDelegate, BiographyEditTableViewCellDelegate {
    
//    private var tableView: UITableView!
    private var pickerView: UIPickerView!
    private let pickerViewHeight: CGFloat = 160
    private var pickerToolbar: UIToolbar!
    private let toolbarHeight: CGFloat = 40.0
    private var pickerIndexPath: IndexPath!
    private var genderArray = [String]()
    private var ageArray = [Int]()
    private var placeArray = [String]()
    private var currentName: String!
    private var currentGender: String!
    private var currentAge: String!
    private var currentPlace: String!
    private var currentBiography: String!
    private var textView: UITextView!
    private var editImageFlg: Bool!
    private var afterResistering: Bool!
    private var textViewEditing: Bool!
    private var bioEditCell: BiographyEditTableViewCell!
    private var window: UIWindow!
    
    let sectionTitles = ["","基本情報","自己紹介文"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        // Do any additional setup after loading the view, typically from a nib.
        self.title = "プロフィール設定"
        self.tableView = UITableView(frame: CGRect(x:0,y:0,width:self.view.frame.width,height:self.view.frame.height), style: .grouped)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(ImageEditTableViewCell.self, forCellReuseIdentifier: "ImageEditTableViewCell")
        self.tableView.register(NameEditTableViewCell.self, forCellReuseIdentifier: "NameEditTableViewCell")
        self.tableView.register(SubInfoEditTableViewCell.self, forCellReuseIdentifier: "SubInfoEditTableViewCell")
        self.tableView.register(BiographyEditTableViewCell.self, forCellReuseIdentifier: "BiographyEditTableViewCell")
        
        setBarButtonItem()
        setWindow()
        setPickerView()
        setPickerItems()
        
        self.tableView.backgroundColor = UIColor.rgb(r: 241, g: 248, b: 255, alpha: 1.0)
        
        //profileimageを編集するかどうか
        editImageFlg = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadSections(NSIndexSet.init(index: 0) as IndexSet, with: UITableViewRowAnimation.fade)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
//        
//        if Me.sharedMe.isResistered() {
//            
//        }
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidHide, object: nil)
//    }
//    
//    func keyboardWillBeShown(notification: Notification) {
//        if textViewEditing != nil && textViewEditing {
//            if let userInfo = notification.userInfo {
//                if let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey], let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] {
//                    let keyboardFrame4normal = (keyboardFrame as AnyObject).cgRectValue
//                    
//                    print(keyboardFrame4normal)
//                    
//                    UIView.animate(withDuration: animationDuration as! TimeInterval, animations: { 
//                        
//                    })
//                    
//                    let convertedKeyboardFrame = bioEditCell.textView.convert(keyboardFrame4normal!, to: nil)
////                    let offsetY: CGFloat = bioEditCell.textView.frame.maxY - convertedKeyboardFrame.minY
//                    let offsetY: CGFloat = convertedKeyboardFrame.minY - bioEditCell.frame.maxY
//                    print(keyboardFrame4normal)
//                    print(convertedKeyboardFrame.minY)
//                    print(bioEditCell.top)
//                    print(bioEditCell.frame.maxY)
//                    if offsetY < 0 { return }
//                    updateScrollViewSize(moveSize: offsetY, duration: animationDuration as! TimeInterval)
//                }
//            }
//        }
//    }

//    func updateScrollViewSize(moveSize: CGFloat, duration: TimeInterval) {
//        UIView.beginAnimations("ResizeForKeyboard", context: nil)
//        UIView.setAnimationDuration(duration)
//        let contentInsets = UIEdgeInsetsMake(0, 0, moveSize, 0)
//        self.tableView.contentInset = contentInsets
//        self.tableView.scrollIndicatorInsets = contentInsets
//        self.tableView.contentOffset = CGPoint(x: 0, y: moveSize)
//        UIView.commitAnimations()
//    }
//    
//    func keyboardWillBeHidden(notification: Notification) {
//        if textViewEditing != nil && textViewEditing {
//            self.tableView.contentInset = UIEdgeInsets.zero
//            self.tableView.scrollIndicatorInsets = UIEdgeInsets.zero
//            textViewEditing = false
//        }
//    }
    
    private func setWindow() {
        window = UIWindow.init(frame: self.view.bounds)
        window.backgroundColor = UIColor.clear
//        window.makeKeyAndVisible()
    }
    
    private func setPickerItems() {
        genderArray = SourceItem.createGenderArray()
        ageArray = SourceItem.createNumberArray()
        placeArray = SourceItem.createPlaceArray()
        currentName = Me.sharedMe.isResistered() ? Me.sharedMe.returnInfo(key: "name") as! String : ""
        currentGender = Me.sharedMe.isResistered() ? Me.sharedMe.returnInfo(key: "gender") as! String : genderArray[0]
        currentAge = Me.sharedMe.isResistered() ? String(describing: Me.sharedMe.returnInfo(key: "age")) : String(ageArray[0])
        currentPlace = Me.sharedMe.isResistered() ? Me.sharedMe.returnInfo(key: "place") as! String : placeArray[0]
        currentBiography = Me.sharedMe.isResistered() ? Me.sharedMe.returnInfo(key: "biography") as! String : ""
    }
    
    private func setPickerView() {
        let width = self.view.frame.width
        let height = self.tableView.bottom
        
        pickerView = UIPickerView(frame: CGRect.init(x: 0, y: height + toolbarHeight, width: width, height: pickerViewHeight))
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.backgroundColor = UIColor.gray
        self.window.addSubview(pickerView)
        
        pickerToolbar = UIToolbar(frame: CGRect.init(x: 0, y: height, width: width, height: toolbarHeight))
        let flexible = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let doneBtn = UIBarButtonItem(title: "完了", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.doneBtnTapped))
        pickerToolbar.items = [flexible, doneBtn]
        self.window.addSubview(pickerToolbar)
    }
    
    @objc private func doneBtnTapped() {
        UIView.animate(withDuration: 0.2) {
            UIView.animate(withDuration: 0.2){
                self.pickerToolbar.frame = CGRect(x:0,y:self.view.frame.height,
                                                  width:self.view.frame.width,height:self.toolbarHeight)
                self.pickerView.frame = CGRect(x:0,y:self.view.frame.height + self.toolbarHeight,
                                               width:self.view.frame.width,height:self.pickerViewHeight)
            }
            //選択を解除する
            self.tableView.deselectRow(at: self.pickerIndexPath, animated: true)
            let window = UIApplication.shared.delegate?.window
            window??.makeKeyAndVisible()
        }
    }
    
    private func setBarButtonItem() {
        let leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(ProfileEditViewController.tapLeftBarButton(sender:)))
        leftBarButtonItem.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(ProfileEditViewController.tapRightSaveBarButton(sender:)))
        rightBarButtonItem.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc private func tapLeftBarButton(sender: UIButton) {
        if !Me.sharedMe.isResistered() {
            UserDefaults.standard.removeObject(forKey: "ME_IMAGE")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func tapRightSaveBarButton(sender: UIButton) {
        if currentName == ""{
            profileNameRequireAlert()
            return
        }else if ( !(Me.sharedMe.isResistered()) && self.editImageFlg != true ){
            imageRequireAlert()
            return
        }
        
        if Me.sharedMe.isResistered() {
            Me.sharedMe.updateMe(name: currentName, gender: currentGender, age: Int(currentAge)!, place: currentPlace, biography: currentBiography, editImage: editImageFlg)
        } else {
            Me.sharedMe.createMe(name: currentName, gender: self.currentGender, age: Int(currentAge)!, place: currentPlace, biography: currentBiography)
        }
        let tab = self.presentingViewController as! TabbarViewController
        let navi4ProfileVC = tab.viewControllers?[(tab.viewControllers?.count)! - 1] as! UINavigationController
        let profileVC = navi4ProfileVC.viewControllers[0] as! ProfileViewController
        profileVC.isAfterSavingProfile = true
        profileVC.user.userID = Me.sharedMe.returnInfo(key: "userID") as! String
        
        self.dismiss(animated: true, completion: nil)
    }
    
    private func profileNameRequireAlert() {
        var alert: UIAlertController!
        var action: UIAlertAction!
            alert = UIAlertController(title:"名前を入力してください", message: "", preferredStyle: UIAlertControllerStyle.alert)
        action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
        })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func imageRequireAlert() {
        var alert: UIAlertController!
        var action: UIAlertAction!
        alert = UIAlertController(title:"画像を設定してください", message: "", preferredStyle: UIAlertControllerStyle.alert)
        action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
        })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 4
        case 2:
            return 1
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            
        case 0:
            let cell: ImageEditTableViewCell = ImageEditTableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "ImageEditTableViewCell")
            cell.setUI()
            cell.delegate = self
            return cell
        case 1:
            switch indexPath.row {
            case 0:
                let cell: NameEditTableViewCell = NameEditTableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "NameEditTableViewCell")
                cell.setUI()
                cell.delegate = self
                return cell
            case 1:
                let cell: SubInfoEditTableViewCell = SubInfoEditTableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "SubInfoEditTableViewCell")
                cell.setUI(cellNumber: indexPath.row)
                cell.infoLabel.text = currentGender
                return cell
            case 2:
                let cell: SubInfoEditTableViewCell = SubInfoEditTableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "SubInfoEditTableViewCell")
                cell.setUI(cellNumber: indexPath.row)
                cell.infoLabel.text = currentAge
                return cell
            case 3:
                let cell: SubInfoEditTableViewCell = SubInfoEditTableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "SubInfoEditTableViewCell")
                cell.setUI(cellNumber: indexPath.row)
                cell.infoLabel.text = currentPlace
                return cell
            default: break
            }
        case 2:
            let cell: BiographyEditTableViewCell = BiographyEditTableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "BiographyEditTableViewCell")
            cell.setUI()
            cell.delegate = self
            self.bioEditCell = cell
            return cell
            
        default: break
        }
        let cell: UITableViewCell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 120
        case 1:
            return 50
        case 2:
            return 250
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pickerIndexPath = indexPath
        
        switch indexPath.section {
        case 0:
            print("保留")
        case 1:
            switch indexPath.row {
            case 0:
                print("保留")
            case 1...3:
                window.makeKeyAndVisible()
                pickerView.reloadAllComponents()
                UIView.animate(withDuration: 0.2, animations: {
                    self.pickerToolbar.frame = CGRect(x: 0, y: self.view.frame.height - self.pickerViewHeight - self.toolbarHeight, width: self.view.frame.width, height: self.toolbarHeight)
                    self.pickerView.frame = CGRect(x: 0, y: self.view.frame.height - self.pickerViewHeight, width: self.view.frame.width, height: self.pickerViewHeight)
                })
            default:
                print("特になし")
            }
        case 2:
            print("特になし")
        default:
            print("特になし")
        }
    }
    
    // delegate method
    func imgBtnTapped() {
        let actionSheet = UIAlertController(title: "画像選択", message: "どっちにしますか", preferredStyle: UIAlertControllerStyle.actionSheet)
        let action1 = UIAlertAction(title: "写真を撮る", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .camera
            imagePickerController.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePickerController.allowsEditing = true
            self.present(imagePickerController, animated: true, completion: nil)
        })
        
        let action2 = UIAlertAction(title: "アルバムから選択する", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePickerController.allowsEditing = true
            
            self.present(imagePickerController, animated: true, completion: nil)
        })
        
        let cancel = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler: {
            (action: UIAlertAction!) in
        })
        
        actionSheet.addAction(action1)
        actionSheet.addAction(action2)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if info[UIImagePickerControllerOriginalImage] != nil {
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            Me.sharedMe.resisterLocalImage(image: image)
            self.editImageFlg = true
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //    pickerview
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerIndexPath != nil) {
            switch (pickerIndexPath.row) {
            case 1:
                return genderArray.count
            case 2:
                return ageArray.count
            case 3:
                return placeArray.count
            default:
                return 0
            }
        }else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // ここでラベル上のテキストだけを返す
        switch (pickerIndexPath.row){
        case 1:
            return genderArray[row]
        case 2:
            return String(ageArray[row])
        case 3:
            return placeArray[row]
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let cell = tableView.cellForRow(at:pickerIndexPath) as! SubInfoEditTableViewCell
        switch (pickerIndexPath.row) {
        case 1:
            cell.infoLabel.text = genderArray[row]
            currentGender = genderArray[row]
        case 2:
            cell.infoLabel.text = String(ageArray[row])
            currentAge = String(ageArray[row])
        case 3:
            cell.infoLabel.text = placeArray[row]
            currentPlace = placeArray[row]
        default:
            cell.infoLabel.text = ""
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //Textfield
    func textFieldDidEndEditing(cell: NameEditTableViewCell, value: String) {
        currentName = value
        cell.textfield.text = currentName
    }
    
    //BiographyEditTableViewCellDelegate ---------
    func textViewDidEndEditing(cell: BiographyEditTableViewCell, value: String) {
        currentBiography = value
        cell.textView.text = currentBiography
    }
    
    //--------------------------------------------
    func textViewTapped() {
        self.textViewEditing = true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
