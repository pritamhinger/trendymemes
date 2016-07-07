//
//  Meme.swift
//  TrendyMemes
//
//  Created by Pritam Hinger on 07/07/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import Foundation
import UIKit

class Meme {
    var topTitle:String
    var bottomTitle:String
    var originalImage:UIImage
    var memedImage:UIImage
    var createdDateTime:NSDate
    
    init(titleAtTop:String, titleAtBottom:String, imageToBeMemed:UIImage, memedImage:UIImage){
        self.topTitle = titleAtTop
        self.bottomTitle = titleAtBottom
        self.originalImage = imageToBeMemed
        self.memedImage = memedImage
        self.createdDateTime = NSDate()
    }
}