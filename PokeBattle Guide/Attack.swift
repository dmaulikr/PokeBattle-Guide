//
//  Attack.swift
//  PokeBattle Guide
//
//  Created by Julien Saad on 2016-08-01.
//  Copyright © 2016 Julien Saad. All rights reserved.
//

import Foundation

enum AttackType {
    case Quick
    case Special
}

struct Attack {
    let name: String
    let type: [Type]
    let attackType: AttackType
}