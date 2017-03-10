//
//  DetailedTableViewController.swift
//  Pokemon-Pokedex
//
//  Created by Toleen Jaradat on 3/7/17.
//  Copyright © 2017 Toleen Jaradat. All rights reserved.
//

import UIKit

class DetailedTableViewController: UITableViewController {

    @IBOutlet weak var pokeNameLbl: UILabel! 
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var baseAttackLabel: UILabel!
    
     var poke = Pokemon()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = poke.name
        print(poke.pokedexId)
        getPokemon()
    }
    
    private func getPokemon(){

        let pokemonAPI = "http://pokeapi.co/api/v1/pokemon/\(poke.pokedexId!)"
        
        guard let url = URL(string: pokemonAPI) else {
            fatalError("Invalid URL")
        }
        
        let session = URLSession.shared
        
        session.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?,err: Error?) in
            
            let jsonPokemonDictionary = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
            
            self.poke.height = jsonPokemonDictionary.value(forKey: "height") as! String
            self.poke.weight = jsonPokemonDictionary.value(forKey: "weight") as! String
            self.poke.attack = jsonPokemonDictionary.value(forKey: "attack") as! Int
            
            
            DispatchQueue.main.async(execute: {
                
                
                self.image.image = UIImage(named: String(self.poke.pokedexId))
                self.pokeNameLbl.text = "Name: " + self.poke.name
                self.weightLabel.text = "Weight: " + self.poke.weight
                self.heightLabel.text = "Height: " + self.poke.height
                self.baseAttackLabel.text = "Base Attack: " + String(self.poke.attack)
                
            })
            
        }) .resume()
       
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

   
}
