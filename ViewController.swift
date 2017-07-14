//
//  ViewController.swift
//  ChatApp
//
//  Created by 小森武史 on 2017/07/05.
//  Copyright © 2017年 小森武史. All rights reserved.
//

import UIKit
import FirebaseStorage

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let uiimageView = UIImageView.init(frame: CGRect(x: 100, y: 300, width: 100, height: 100))
        self.view.addSubview(uiimageView)
        let storage = Storage.storage()
        let storageRef = storage.reference(forURL: "gs://chaty-d559d.appspot.com")
        let imagesRef = storageRef.child("profile_image/957444D9-22F1-4A57-85B1-656651114848.png")
        
        imagesRef.getData(maxSize: 1 * 1400 * 1400) { (data, error) in
            uiimageView.image = UIImage(data: data!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
