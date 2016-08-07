//
//  Attack.swift
//  PokeBattle Guide
//
//  Created by Julien Saad on 2016-08-01.
//  Copyright © 2016 Julien Saad. All rights reserved.
//

import Foundation
import SwiftyJSON

enum AttackType: String {
    case quick
    case special
    
    init(_ attackType: String) {
        switch (attackType) {
        case "quick":
            self = .quick
        case "special":
            self = .special
        default:
            self = .quick
        }
    }
}

struct Attack {
    let name: String
    let type: Type
    let attackType: AttackType
    
    init(_ dictionary: NSDictionary) {
        
        let json = JSON(dictionary)
        
        name = json["name"].stringValue
        try! type = Type(name: json["type"].stringValue)
        
        attackType = AttackType(json["attackType"].stringValue);
    }
    
}