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
    
    var fonts = [String:[String]]()
    
    private init(){
        let fontFamilyNames = UIFont.familyNames()
        for fontFamily in fontFamilyNames {
            let fontsInFamily = UIFont.fontNamesForFamilyName(fontFamily)
            var fontsArray = [String]()
            for font in fontsInFamily {
                fontsArray.append(font)
            }
            
            fonts[fontFamily] = fontsArray
        }
        
        print("Captured All fonts")
    }
}