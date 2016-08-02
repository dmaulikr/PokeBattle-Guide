//
//  Pokemon.swift
//  PokeBattle Guide
//
//  Created by Julien Saad on 2016-08-01.
//  Copyright © 2016 Julien Saad. All rights reserved.
//

import Foundation

struct Pokemon {
    let id : Int
    let name: String
    let types: [Type]
    let quickAttacks: [Attack]
    let specialAttacks: [Attack]
    
    init(_ dictionary: Dictionary<String, AnyObject>) {
        id = 3
        name = "HEllo"
        types = []
        quickAttacks = []
        specialAttacks = []
    }
}