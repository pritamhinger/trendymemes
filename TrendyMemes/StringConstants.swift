//
//  StringConstants.swift
//  TrendyMemes
//
//  Created by Pritam Hinger on 08/07/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import Foundation

struct StringConstants {
    struct CellIdentifiers {
        static let MemeImageCellIdentifier = "memeImageCellIdentifier"
        static let TemplateTypeCellIdentifier = "templateTypeCellIdentifier"
        static let FontFamilyNameCellIdentifier = "fontFamilyNameCellIdentifier"
        static let FontNameCellIdentifier = "fontNameCellIdentifier"
    }
    
    struct Segues {
        static let ShowTemplatesSegue = "showTemplatesSegue"
        static let ShowFontsFamilySegue = "showFontsFamilySegue"
        static let ShowFontsSegue = "showFontsSegue"
    }
    
    struct DictionaryKeys {
        static let FontName = "FontName"
        static let FontSize = "FontSize"
        static let StrokeColor = "StrokeColor"
        static let ForegroundColor = "ForeGroundColor"
        static let TemplateType = "TemplateType"
    }
    
}