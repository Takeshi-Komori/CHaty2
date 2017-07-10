//
//  NameEditTableViewCell.swift
//  ChatApp
//
//  Created by 小森武史 on 2017/06/24.
//  Copyright © 2017年 小森武史. All rights reserved.
//

import UIKit

protocol NameEditTableViewCellDelegate {
    func textFieldDidEndEditing(cell: NameEditTableViewCell, value: String) -> ()
}

class NameEditTableViewCell: UITableViewCell , UITextFieldDelegate{
    let screenWidth = CGFloat( UIScreen.main.bounds.size.width);
    var delegate: NameEditTableViewCellDelegate!
    var textfield: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUI() {
        let label = UILabel(frame: CGRect.init(x: 15, y: 12.5, width: 80, height: 25))
        label.text = "名前(必須)"
        label.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(label)
        
        textfield = UITextField(frame: CGRect.init(x: label.right + 15, y: label.top, width: screenWidth - label.right - 35, height: 25))
        textfield.delegate = self
        textfield.placeholder = "名前を入力してください"
        textfield.text = Me.sharedMe.returnInfo(key: "name") as! String == "未設定" ? "": Me.sharedMe.returnInfo(key: "name") as! String
        textfield.textAlignment = NSTextAlignment.right
        textfield.returnKeyType = .done
        contentView.addSubview(textfield)
        
    }
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    internal func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate.textFieldDidEndEditing(cell: self, value: textField.text!)
    }
    
}
