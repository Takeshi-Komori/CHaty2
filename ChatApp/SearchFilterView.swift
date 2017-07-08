//
//  SearchFilterView.swift
//  ChatApp
//
//  Created by KomoriTakeshi on 2017/07/06.
//  Copyright © 2017年 小森武史. All rights reserved.
//

import UIKit

class HorizontalLineView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.rgb(r: 192, g: 192, b: 192, alpha: 1.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol SearchFilterViewDelegate {
    func cancelBtnTapped()
    func labelTapped()
}

class SearchFilterView: UIView {
    var naviBar: UIView!
    var cancelBtn: UIButton!
    var delegate: SearchFilterViewDelegate!
    var genderSegmentValue: String!
    var ageSegmentValue: String!
    var placeLabelValue: String!
    var placeLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        genderSegmentValue = "未設定"
        ageSegmentValue = "20-29歳"
        placeLabelValue = "設定しない"
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        self.backgroundColor = UIColor.rgb(r: 241, g: 248, b: 255, alpha: 1.0)
        naviBar = UIView.init(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 40))
        naviBar.backgroundColor = UIColor.rgb(r: 27, g: 149, b: 224, alpha: 1)
        self.addSubview(naviBar)
        
        cancelBtn = UIButton.init(frame: CGRect(x: self.frame.width - 30, y: 0, width: 30, height: 40))
        cancelBtn.setTitle("×", for: UIControlState.normal)
        cancelBtn.addTarget(self, action: #selector(cancelBtnTap), for: UIControlEvents.touchDown)
        self.addSubview(cancelBtn)
        
        let label = UILabel.init(frame: CGRect(x: (self.bounds.width - 100)/2, y: 7.5, width: 100, height: 25))
        label.text = "ユーザー検索"
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 16)
        naviBar.addSubview(label)
        
        let genderLabel = UILabel(frame: CGRect(x: 10, y: naviBar.bottom + 7, width: 30, height: 25))
        genderLabel.text = "性別"
        genderLabel.textAlignment = NSTextAlignment.left
        genderLabel.font = UIFont.systemFont(ofSize: 13)
        genderLabel.textColor = UIColor.lightGray
        self.addSubview(genderLabel)
        
        let genderSegment = UISegmentedControl.init(items: SourceItem.createGenderArray())
        genderSegment.frame = CGRect(x: 30, y: genderLabel.bottom + 7, width: self.bounds.width - 60, height: 25)
        genderSegment.selectedSegmentIndex = 0
        genderSegment.tintColor = UIColor.rgb(r: 27, g: 149, b: 224, alpha: 1)
        genderSegment.addTarget(self, action: #selector(genderSegmentChange), for: UIControlEvents.valueChanged)
        self.addSubview(genderSegment)
        
        let horizontalSectionView = HorizontalLineView(frame: CGRect(x: 0, y: (self.bounds.height - 40)/3 + 40, width: self.bounds.width, height: 0.3))
        self.addSubview(horizontalSectionView)
        
        let ageLabel = UILabel(frame: CGRect(x: 10, y: horizontalSectionView.bottom + 7, width: 30, height: 25))
        ageLabel.text = "年齢"
        ageLabel.textAlignment = NSTextAlignment.left
        ageLabel.font = UIFont.systemFont(ofSize: 13)
        ageLabel.textColor = UIColor.lightGray
        self.addSubview(ageLabel)
        
        let ageSegment = UISegmentedControl.init(items: SourceItem.createGenerationArray())
        ageSegment.frame = CGRect(x: 10, y: ageLabel.bottom + 7, width: self.bounds.width - 20, height: 25)
        ageSegment.selectedSegmentIndex = 0
        ageSegment.tintColor = UIColor.rgb(r: 27, g: 149, b: 224, alpha: 1)
        ageSegment.addTarget(self, action: #selector(ageSegmentChange), for: UIControlEvents.valueChanged)
        self.addSubview(ageSegment)
        
        let horizontalSectionView2 = HorizontalLineView(frame: CGRect(x: 0, y: horizontalSectionView.bottom + (self.bounds.height - 40)/3, width: self.bounds.width, height: 0.3))
        self.addSubview(horizontalSectionView2)
        
        let placeTitleLabel = UILabel(frame: CGRect(x: 10, y: horizontalSectionView2.bottom + 7, width: 30, height: 25))
        placeTitleLabel.text = "場所"
        placeTitleLabel.textAlignment = NSTextAlignment.left
        placeTitleLabel.font = UIFont.systemFont(ofSize: 13)
        placeTitleLabel.textColor = UIColor.lightGray
        self.addSubview(placeTitleLabel)
        
        placeLabel = UILabel(frame: CGRect(x: (self.bounds.width - 100) / 2, y: horizontalSectionView2.bottom + ((self.bounds.height - 40)/3 - 25)/2 , width: 100, height: 25))
        placeLabel.text = placeLabelValue
        placeLabel.textAlignment = NSTextAlignment.center
        placeLabel.textColor = UIColor.lightGray
        placeLabel.tag = 1
        placeLabel.isUserInteractionEnabled = true
        self.addSubview(placeLabel)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let t: UITouch = touch as! UITouch
            if t.view?.tag == self.placeLabel.tag {
                delegate.labelTapped()
            }
        }
    }
    
    func genderSegmentChange(sender: UISegmentedControl) {
        genderSegmentValue = SourceItem.createGenderArray()[sender.selectedSegmentIndex]
    }
    
    func ageSegmentChange(sender: UISegmentedControl) {
        ageSegmentValue = SourceItem.createGenerationArray()[sender.selectedSegmentIndex]
    }
    
    func cancelBtnTap() {
        delegate.cancelBtnTapped()
    }
}
