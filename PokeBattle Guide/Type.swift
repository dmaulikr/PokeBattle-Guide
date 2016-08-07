//
//  Type.swift
//  PokeBattle Guide
//
//  Created by Julien Saad on 2016-08-01.
//  Copyright © 2016 Julien Saad. All rights reserved.
//

import Foundation
import SwiftyJSON

enum TypeError: ErrorType {
    case UnknownPokemonType
}

public enum Type: String, CustomStringConvertible {
    case Normal
    case Fighting
    case Flying
    case Poison
    case Ground
    case Rock
    case Bug
    case Ghost
    case Steel
    case Fire
    case Water
    case Grass
    case Electric
    case Psychic
    case Ice
    case Dragon
    case Dark
    case Fairy
    
    init(name: String) throws {
        guard let type = Type(rawValue: name) else {
            throw TypeError.UnknownPokemonType
        }
        self = type
    }
    
    func susceptibleTo() -> [Type] {
        
        var counters: [Type] = []
        guard let typeJson = TypeLoader.sharedInstance.typeData[self] else {
            return counters
        }
        
        guard let succeptableTo = typeJson["succeptableTo"].array else {
            return counters
        }
        
        for stringType in succeptableTo {
            try! counters.append(Type(name: stringType.stringValue))
        }
        return counters
    }
    
    func resistantTo() -> [Type] {
        
        var counters: [Type] = []
        guard let typeJson = TypeLoader.sharedInstance.typeData[self] else {
            return counters
        }
        
        guard let resistantTo = typeJson["resistantTo"].array else {
            return counters
        }
        
        for stringType in resistantTo {
            try! counters.append(Type(name: stringType.stringValue))
        }
        return counters
    }
    
    func bonusDamageTo() -> [Type] {
        
        var counters: [Type] = []
        
        for type in TypeLoader.sharedInstance.typeData.keys {
            if type.susceptibleTo().contains(self) {
                counters.append(type)
            }
        }
        
        return counters
    }
    
    func reducedDamageTo() -> [Type] {
        var counters: [Type] = []
        
        for type in TypeLoader.sharedInstance.typeData.keys {
            if type.resistantTo().contains(self) {
                counters.append(type)
            }
        }
        
        return counters
    }
    
    public var description: String {
        return self.rawValue
    }
}