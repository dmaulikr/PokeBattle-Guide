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
    
    func matchups(pokemonToCounter: Pokemon) -> [RankedPokemon]  {
        let start = NSDate()
        var rankedPokemons: [RankedPokemon] = []
        
        for aPokemon in PokemonManager.sharedInstance.pokemons {
            
            for aPokemonAttackType in Set(aPokemon.attackTypes) {
                let bonusDamageToTarget = Set(aPokemonAttackType.bonusDamageTo()).intersect(pokemonToCounter.types)
                let reducedDamageToTarget = Set(aPokemonAttackType.reducedDamageTo()).intersect(pokemonToCounter.types)
                
                let defenseTypes = aPokemon.types;
                var resistances: [Type] = []
                for defenseType in defenseTypes {
                    resistances += defenseType.resistantTo()
                }
                
                var weaknesses: [Type] = []
                for defenseType in defenseTypes {
                    weaknesses += defenseType.susceptibleTo()
                }
                
                let resistantToTarget = Set(resistances).intersect(pokemonToCounter.types)
                let susceptibleToTarget = Set(weaknesses).intersect(pokemonToCounter.types)
                
                var stabBonus = 1.0
                let opponentStabBonus = 1.25
                
                if aPokemon.types.contains(aPokemonAttackType) {
                    stabBonus = 1.25
                }
                
                let multiplier = (stabBonus / opponentStabBonus) *
                    pow(1.25, Double(bonusDamageToTarget.count)) *
                    pow(0.80, Double(reducedDamageToTarget.count)) *
                    pow(1.25, Double(resistantToTarget.count)) *
                    pow(0.80, Double(susceptibleToTarget.count))
                
                //                print("")
                //                print("subkey: \(aPokemon.name)_\(aPokemonAttack.type). Ranking \(multiplier)")
                //                print("AttackType: \(aPokemonAttack.type)")
                //                print("subpokemon.types: \(aPokemon.types)")
                //                print("StabBonus: \(stabBonus)")
                //                print("bonusDamageToTarget: \(bonusDamageToTarget)")
                //                print("reducedDamageToTarget: \(reducedDamageToTarget)")
                //                print("resistantToTarget: \(resistantToTarget)")
                //                print("susceptibleToTarget: \(susceptibleToTarget)")
                
                rankedPokemons.append(RankedPokemon(pokemon: aPokemon, type: aPokemonAttackType, multiplier: multiplier))
            }
        }
        
        rankedPokemons.sortInPlace {
            if $0.multiplier == $1.multiplier {
                return $0.pokemon.maxCP > $1.pokemon.maxCP
            }
            return $0.multiplier > $1.multiplier
        }
        return rankedPokemons
    }
}