//
//  Pokemon.swift
//  PokeBattle Guide
//
//  Created by Julien Saad on 2016-08-01.
//  Copyright © 2016 Julien Saad. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Pokemon: NSObject {
    let id : Int
    let name: String
    var types: Set<Type> = []
    var quickAttacks: [Attack] = []
    var specialAttacks: [Attack] = []
    let maxCP: Int
    
    var attacks: [Attack] {
        get {
            return quickAttacks + specialAttacks
        }
    }
    
    var attackTypes: Set<Type> {
        get {
            return Set(attacks.map({
                $0.type
            }))
        }
    }
    
    init(_ dictionary: NSDictionary) {
        
        let json = JSON(dictionary)
        
        id = json["id"].intValue
        name = json["name"].stringValue
        maxCP = json["maxCP"].intValue
        
        for typeName in json["types"].arrayValue {
            try! types.insert(Type(name: typeName.stringValue))
        }
        
        for attackName in json["quickAttacks"].arrayValue {
            let attack = AttackManager.sharedInstance.attacksByName[attackName.stringValue]!
            quickAttacks.append(attack)
        }
        
        for attackName in json["specialAttacks"].arrayValue {
            let attack = AttackManager.sharedInstance.attacksByName[attackName.stringValue]!
            specialAttacks.append(attack)
        }
    }
    
    public override var description: String {
        return "\(id): \(name)\nTypes: \(types)\n"
    }
    
    public override var hash: Int {
        return id
    }
}