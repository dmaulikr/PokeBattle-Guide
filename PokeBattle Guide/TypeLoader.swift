//
//  TypeManager.swift
//  PokeBattle Guide
//
//  Created by Julien Saad on 2016-08-06.
//  Copyright © 2016 Julien Saad. All rights reserved.
//

import Foundation
import SwiftyJSON

class TypeLoader {
    static let sharedInstance = TypeLoader()
    
    var typeData: [Type: JSON] = [:]
    
    init() {
        if let path = NSBundle.mainBundle().pathForResource("types2", ofType: "json") {
            if let jsonData = NSData(contentsOfFile: path) {
                if let jsonResult: NSArray = try! NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as? NSArray  {
                    for typeDic in jsonResult as! [NSDictionary] {
                        let typeJson = JSON(typeDic)
                        try! typeData[Type(name: typeJson["name"].stringValue)] = typeJson;
                    }
                }
            }
        }

    }
}