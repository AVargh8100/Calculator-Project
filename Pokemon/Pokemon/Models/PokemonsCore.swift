//
//  PokemonCore.swift
//  Pokemon
//
//  Created by Consultant on 6/24/22.
//

import Foundation
import CoreData

public class PokemonsCore: NSManagedObject{
    @NSManaged var name: String
    @NSManaged var imageUrl: String
    @NSManaged var types: String
    @NSManaged var baseExperience: Int64
    @NSManaged var hp: Int16
    @NSManaged var attack: Int16
    @NSManaged var defense: Int16
    @NSManaged var specialAttack: Int16
    @NSManaged var specialDefense: Int16
    @NSManaged var speed: Int16
    @NSManaged var height: Int64
    @NSManaged var weight: Int64
}
