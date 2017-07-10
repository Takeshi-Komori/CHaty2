//
//  ImageEditTableViewCell.swift
//  ChatApp
//
//  Created by 小森武史 on 2017/06/24.
//  Copyright © 2017年 小森武史. All rights reserved.
//

import UIKit

protocol ImageEditTableViewCellDelegate {
    func imgBtnTapped()
}

class ImageEditTableViewCell: UITableViewCell {
    
    var delegate: ImageEditTableViewCellDelegate!
    var button: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUI() {

        button = UIButton(frame: CGRect(x: 10, y: 10, width: 100, height: 100))
        button.setImage(Me.sharedMe.returnLocalImage(), for: .normal)
        button.layer.cornerRadius = 50
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(imgBtnTap(sender:)), for: .touchUpInside)
        button.imageView?.contentMode = UIViewContentMode.scaleAspectFill
        self.contentView.addSubview(button)
        
        let label = UILabel(frame: CGRect.init(x: button.right + 15, y: 45, width: 200, height: 30))
        label.text = "プロフィール画像(必須)"
        self.contentView.addSubview(label)
        
    }
    
    
    func imgBtnTap(sender: UIButton) {
        delegate.imgBtnTapped()
    }
    

}
