//
//  AttackManager.swift
//  PokeBattle Guide
//
//  Created by Julien Saad on 2016-08-06.
//  Copyright © 2016 Julien Saad. All rights reserved.
//

import Foundation

class AttackManager {
    static let sharedInstance = AttackManager()
    
    var attacksByName: [String : Attack] = [:]
    
    init() {
        if let path = NSBundle.mainBundle().pathForResource("attacks2", ofType: "json") {
            if let jsonData = NSData(contentsOfFile: path) {
                if let jsonResult: NSArray = try! NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as? NSArray  {
                    for attackJson in jsonResult as! [NSDictionary] {
                        let attack = Attack(attackJson)
                        attacksByName[attack.name] = attack
                    }
                }
            }
        }
    }
}