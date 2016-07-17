//
//  MemeHelper.swift
//  TrendyMemes
//
//  Created by Pritam Hinger on 17/07/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import Foundation

class MemeHelper {
    static var sharedInstance = MemeHelper()
    
    private init(){
        
    }
    
    func getDateStringFromDate(date:NSDate) -> String{
        let dateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss";
        return dateFormatter.stringFromDate(date);
    }
}