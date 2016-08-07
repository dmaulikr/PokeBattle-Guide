//
//  ViewController.swift
//  PokeBattle Guide
//
//  Created by Julien Saad on 2016-08-01.
//  Copyright © 2016 Julien Saad. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        PokemonManager.sharedInstance

        //typeCounters(PokemonManager.sharedInstance.pokemons[1])
        counters(PokemonManager.sharedInstance.pokemons[1])
    }
    
    private func typeCounters(pokemonToCounter: Pokemon) {
        print("Name: \(pokemonToCounter.name)")
        print("Type: \(pokemonToCounter.types)")
        
        for type in TypeLoader.sharedInstance.typeData.keys {
            let bonusDamageToTarget = Set(type.bonusDamageTo()).intersect(pokemonToCounter.types)
            let reducedDamageToTarget = Set(type.reducedDamageTo()).intersect(pokemonToCounter.types)
            let resistantToTarget = Set(type.resistantTo()).intersect(pokemonToCounter.types)
            let susceptibleToTarget = Set(type.susceptibleTo()).intersect(pokemonToCounter.types)
            
            let multiplier =
                pow(1.25, Double(bonusDamageToTarget.count)) *
                pow(0.80, Double(reducedDamageToTarget.count)) *
                pow(1.25, Double(resistantToTarget.count)) *
                pow(0.80, Double(susceptibleToTarget.count))
            
            print("\(type): \(multiplier)")
        }
    }
    
    private func counters(pokemonToCounter: Pokemon) {
        
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
        
        print("\(pokemonToCounter.name) matchups:")
        for rankedPokemon in rankedPokemons {
            print(rankedPokemon)
        }
    }
    
    

}

struct RankedPokemon: CustomStringConvertible {
    let pokemon: Pokemon
    let type: Type
    let multiplier: Double
    
    var description: String {
        return "\(pokemon.name) : \(type) - \(multiplier.roundTo2f)"
    }
}

extension Double {
    var roundTo2f: Double {return Double(round(100*self)/100)  }
    var roundTo3f: Double {return Double(round(1000*self)/1000) }
}
