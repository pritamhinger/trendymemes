//
//  FontNames.swift
//  TrendyMemes
//
//  Created by Pritam Hinger on 10/07/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import Foundation
import UIKit

class FontsManager {
    static let sharedInstance = FontsManager()
    
    private var fonts = [String:[String]]()
    
    private init(){
        let fontFamilyNames = UIFont.familyNames()
        var fontsArray = [String]()
        for fontFamily in fontFamilyNames {
            let fontsInFamily = UIFont.fontNamesForFamilyName(fontFamily)
            for font in fontsInFamily {
                fontsArray.append(font)
            }
            
            fonts[fontFamily] = fontsArray
        }
    }
}