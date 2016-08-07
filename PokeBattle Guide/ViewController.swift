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

    @IBOutlet var collectionView: UICollectionView!
    
    var selectedPokemon: Pokemon?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = UIColor.whiteColor()
        PokemonManager.sharedInstance
        self.automaticallyAdjustsScrollViewInsets = false
        //typeCounters(PokemonManager.sharedInstance.pokemons[1])
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! PokemonDetailsViewController
        vc.selectedPokemon = selectedPokemon
    }

    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBarHidden = true
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PokemonManager.sharedInstance.pokemons.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let reuseIdentifier = "cell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! PokemonCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.imageView.image = PokemonManager.sharedInstance.pokemons[indexPath.item].image
        cell.backgroundColor = UIColor.whiteColor()
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.mainScreen().scale
        cell.layer.masksToBounds = false
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedPokemon = PokemonManager.sharedInstance.pokemons[indexPath.item]
        performSegueWithIdentifier("details", sender: self)
    }
}

extension Double {
    var roundTo2f: Double {return Double(round(100*self)/100)  }
    var roundTo3f: Double {return Double(round(1000*self)/1000) }
}
