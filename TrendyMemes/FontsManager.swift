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
        // Fetching all Font Family Names
        let fontFamilyNames = UIFont.familyNames()
        
        // Iterating over each family name
        for fontFamily in fontFamilyNames {
            // Fetching all font names in this font family
            let fontsInFamily = UIFont.fontNamesForFamilyName(fontFamily)
            var fontsArray = [String]()
            for font in fontsInFamily {
                // Preparing collection of all font names in this font family
                fontsArray.append(font)
            }
            
            // Setting font family name as key to dictionary Fonts with value for each key representing font names in that family
            fonts[fontFamily] = fontsArray
        }
    }
}