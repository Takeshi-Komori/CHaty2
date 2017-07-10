//
//  SubInfoEditTableViewCell.swift
//  ChatApp
//
//  Created by 小森武史 on 2017/06/24.
//  Copyright © 2017年 小森武史. All rights reserved.
//

import UIKit

class SubInfoEditTableViewCell: UITableViewCell {
    let screenWidth = CGFloat( UIScreen.main.bounds.size.width);
    
    var infoLabel: UILabel!
    
    let subinfoCellTitles = ["性別","年齢","場所"]

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUI(cellNumber: Int) {
        let label = UILabel(frame: CGRect.init(x: 15, y: 12.5, width: 50, height: 25))
        label.text = subinfoCellTitles[cellNumber - 1]
        label.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(label)
        infoLabel = UILabel(frame: CGRect.init(x: label.right + 15, y: label.top, width: screenWidth - label.right - 35, height: 25))
        infoLabel.textAlignment = NSTextAlignment.right
        contentView.addSubview(infoLabel)
    }


}
