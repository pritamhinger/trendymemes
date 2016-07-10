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
    var fontName = StringConstants.Default.FontName
    var fontSize = StringConstants.Default.FontSize
    var strokeColor = StringConstants.Default.StrokeColor
    var foregroundColor = StringConstants.Default.ForegroungColor
    
    init(){
        
    }
    
    init(name:String, size:Int, strokeColor:UIColor, foregroundColor:UIColor){
        self.fontName = name
        self.fontSize = size
        self.strokeColor = strokeColor
        self.foregroundColor = foregroundColor
    }
}