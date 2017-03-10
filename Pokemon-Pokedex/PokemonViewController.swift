//
//  ViewController.swift
//  Pokemon-Pokedex
//
//  Created by Toleen Jaradat on 8/7/16.
//  Copyright © 2016 Toleen Jaradat. All rights reserved.
//

import UIKit

class PokemonViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!

    var pokemons = [Pokemon]()
    
    var searchingForPokemon = false
    var filteredPokemon = [Pokemon]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.delegate = self
        collection.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        
        parsePokemonCSV()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            searchingForPokemon = false
            view.endEditing(true)
            collection.reloadData()
        } else {
            searchingForPokemon = true
            let str = searchBar.text!.lowercased()
            filteredPokemon = pokemons.filter({$0.name.range(of: str) != nil})
            collection.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        view.endEditing(true)
    }
    
    
    func parsePokemonCSV(){
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            
            for row in rows {
                
                let poke = Pokemon()
                poke.pokedexId = Int (row["id"]!)
                poke.name = row ["identifier"]
                self.pokemons.append(poke)
            }
            
        } catch let error as NSError {
            print (error.debugDescription)
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let poke: Pokemon!
        if searchingForPokemon {
            poke = filteredPokemon[indexPath.row]
            print(poke.name)
        } else {
            poke = pokemons[indexPath.row]
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToDetailedVC" {
            
            let detailVC = segue.destination as? DetailedTableViewController
            var indexpath =  self.collection.indexPathsForSelectedItems?[0]

            var selectedPokemon = Pokemon()
            if self.searchingForPokemon {
                selectedPokemon = self.filteredPokemon[(indexpath?.row)!]
            } else {
                selectedPokemon = self.pokemons[(indexpath?.row)!]
            }
            
            detailVC?.poke = selectedPokemon
            
            }
        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCellCollectionViewCell  {
            
            let poke: Pokemon!
            
            if self.searchingForPokemon {
                poke = self.filteredPokemon[indexPath.row]
            } else {
                poke = self.pokemons[indexPath.row]
            }
            
            cell.configureCell(poke)
            return cell
            
        } else {
            
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.searchingForPokemon {
            return self.filteredPokemon.count
        }
        return self.pokemons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 75,height: 75)
    }
    
}

