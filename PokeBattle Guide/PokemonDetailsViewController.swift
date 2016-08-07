//
//  PokemonDetailsViewController.swift
//  PokeBattle Guide
//
//  Created by Julien Saad on 2016-08-07.
//  Copyright © 2016 Julien Saad. All rights reserved.
//

import UIKit

class PokemonDetailsViewController: UIViewController {

    var selectedPokemon: Pokemon!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var tableView: UITableView!
    
    var matchups: [RankedPokemon] = []
    var groupedMatchups: [[RankedPokemon]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        imageView.image = selectedPokemon.image
        
        matchups = PokemonManager.sharedInstance.matchups(selectedPokemon)
        
        var currentMultiplier = matchups[0].multiplier
        var index = 0
        
        for matchup in matchups {
            if matchup.multiplier != currentMultiplier {
                index += 1
                currentMultiplier = matchup.multiplier
            }
            if groupedMatchups.count <= index {
                groupedMatchups.append([])
            }
            groupedMatchups[index].append(matchup)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBarHidden = false
    }
    
}

extension PokemonDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let matchup = groupedMatchups[indexPath.section][indexPath.row]
        
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell!
        cell.imageView?.image = matchup.pokemon.image
        cell.textLabel?.text = "\(matchup.pokemon.name) using \(matchup.type)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Multiplier: \(groupedMatchups[section][0].multiplier.roundTo2f)"
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return groupedMatchups.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupedMatchups[section].count
    }
}
