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
    
    /**
     Convert passed date into a formatted String equivalent
     
     - Parameter date: Input date which is to be converted to String
     - Returns: Input date formatted as per predefined date format
     */
    func getDateStringFromDate(date:NSDate) -> String{
        let dateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss";
        return dateFormatter.stringFromDate(date);
    }
}