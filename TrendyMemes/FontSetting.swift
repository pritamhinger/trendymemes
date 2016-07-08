//
//  FontSetting.swift
//  TrendyMemes
//
//  Created by Pritam Hinger on 08/07/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import Foundation
import UIKit

class FontSetting{
    var fontName = "MarkerFelt-Wide"
    var fontSize = 40
    var strokeColor = UIColor.blackColor()
    var foregroundColor = UIColor.whiteColor()
    
    init(){
        
    }
    
    init(name:String, size:Int, strokeColor:UIColor, foregroundColor:UIColor){
        self.fontName = name
        self.fontSize = size
        self.strokeColor = strokeColor
        self.foregroundColor = foregroundColor
    }
//    
//    public required init?(coder aDecoder: NSCoder) {
//        self.fontName = aDecoder.decodeObjectForKey("FontName") as! String
//        self.fontSize = aDecoder.decodeIntegerForKey("FontSize")
//        self.strokeColor = aDecoder.decodeObjectForKey("StrokeColor") as! UIColor
//        self.foregroundColor = aDecoder.decodeObjectForKey("ForegroundColor") as! UIColor
//    }
//    
//    public func encodeWithCoder(aCoder: NSCoder) {
//        aCoder.encodeObject(self.fontName, forKey: "CompanyId")
//        aCoder.encodeObject(self.fontSize, forKey: "Name")
//        aCoder.encodeObject(self.strokeColor, forKey: "Contact")
//        aCoder.encodeObject(self.foregroundColor, forKey: "Address")
//    }
}