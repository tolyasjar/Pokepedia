//
//  PokeCellCollectionViewCell.swift
//  Pokemon-Pokedex
//
//  Created by Toleen Jaradat on 8/11/16.
//  Copyright © 2016 Toleen Jaradat. All rights reserved.
//

import UIKit

class PokeCellCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellThumbImg: UIImageView!
    @IBOutlet weak var cellNameLbl: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5.0
    }
    
    func configureCell(_ pokemon: Pokemon){
        
        cellNameLbl.text = pokemon.name.capitalized
        cellThumbImg.image = UIImage(named: String(pokemon.pokedexId))
    }
    
}
