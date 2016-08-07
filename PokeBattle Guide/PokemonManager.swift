//
//  PokemonManager.swift
//  PokeBattle Guide
//
//  Created by Julien Saad on 2016-08-02.
//  Copyright © 2016 Julien Saad. All rights reserved.
//

import Foundation

class PokemonManager {
    static let sharedInstance = PokemonManager()
    
    var pokemons: [Pokemon] = []
    
    init() {
        if let path = NSBundle.mainBundle().pathForResource("pokemon2", ofType: "json") {
            if let jsonData = NSData(contentsOfFile: path) {
                if let jsonResult: NSArray = try! NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as? NSArray  {
                    for pokemonJson in jsonResult as! [NSDictionary] {
                        let pokemon = Pokemon(pokemonJson)
                        pokemons.append(pokemon)
                    }
                }
            }
        }
    }
}