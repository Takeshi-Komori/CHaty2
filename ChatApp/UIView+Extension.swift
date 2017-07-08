//
//  UIView+Extension.swift
//  ChatApp
//
//  Created by 小森武史 on 2017/06/23.
//  Copyright © 2017年 小森武史. All rights reserved.
//

import Foundation

import UIKit

extension UIView {
    
    var top : CGFloat{
        get{
            return self.frame.origin.y
        }
        set{
            var frame       = self.frame
            frame.origin.y  = newValue
            self.frame      = frame
        }
    }
    
    var bottom : CGFloat{
        get{
            return frame.origin.y + frame.size.height
        }
        set{
            var frame       = self.frame
            frame.origin.y  = newValue - self.frame.size.height
            self.frame      = frame
        }
    }
    
    var right : CGFloat{
        get{
            return self.frame.origin.x + self.frame.size.width
        }
        set{
            var frame       = self.frame
            frame.origin.x  = newValue - self.frame.size.width
            self.frame      = frame
        }
    }
    
    var left : CGFloat{
        get{
            return self.frame.origin.x
        }
        set{
            var frame       = self.frame
            frame.origin.x  = newValue
            self.frame      = frame
        }
    }
    
    func toImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        context!.translateBy(x: 0.0, y: 0.0)
        self.layer.render(in: context!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
