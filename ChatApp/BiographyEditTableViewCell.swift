//
//  BiographyEditTableViewCell.swift
//  ChatApp
//
//  Created by 小森武史 on 2017/06/24.
//  Copyright © 2017年 小森武史. All rights reserved.
//

import UIKit

protocol BiographyEditTableViewCellDelegate {
    func textViewDidEndEditing(cell: BiographyEditTableViewCell, value: String) -> ()
}

class BiographyEditTableViewCell: UITableViewCell ,UITextViewDelegate{
    let screenWidth = CGFloat( UIScreen.main.bounds.size.width);
    var textView: UITextView!
    var delegate: BiographyEditTableViewCellDelegate!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUI() {
        textView = UITextView(frame: CGRect.init(x: 20, y: 20, width: screenWidth - 40, height: 200))
        textView.layer.borderWidth = 0.1
        textView.layer.cornerRadius = 2.5
        textView.text = Me.sharedMe.returnInfo(key: "biography") as! String == "未設定" ? "": Me.sharedMe.returnInfo(key: "biography") as! String
        textView.returnKeyType = .done
        textView.delegate = self
        contentView.addSubview(textView)
    }
    
    internal func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
           textView.resignFirstResponder()
        }
        return true
    }
    
    internal func textViewDidEndEditing(_ textView: UITextView) {
        self.delegate.textViewDidEndEditing(cell: self, value: textView.text!)
    }
    
    

}
