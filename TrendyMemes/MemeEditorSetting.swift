//
//  MemeEditorSetting.swift
//  TrendyMemes
//
//  Created by Pritam Hinger on 08/07/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import Foundation

class MemeEditorSetting {
    var fontSetting:FontSetting = FontSetting(){
        willSet(newValue){
            // TODO: Save new font setting to User Default
            print("Changing Font Setting")
        }
    }
    
    var templateSetting:TemplateSetting = TemplateSetting.TopBottom{
        willSet(newValue){
            // TODO: Save new template setting to User Default
            print("Changing Template Setting")
        }
    }
    
}