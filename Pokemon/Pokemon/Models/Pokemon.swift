//
//  Pokemon.swift
//  Pokemon
//
//  Created by Consultant on 6/17/22.
//

import Foundation

struct Pokemon{
    let name: String
    let imageUrl: String
    let types: [String]
    let baseExperience: Int
    let hp: Int
    let attack: Int
    let defense: Int
    let specialAttack: Int
    let specialDefense: Int
    let speed: Int
    let height: Int
    let weight: Int
    
    static let database = DatabaseHandler.shared
    func store(){
        guard let favorite = Pokemon.database.add(PokemonsCore.self) else {
            print("Problem adding the pokemon to favorites in Pokemon model")
            return
        }
        var stringStyles = ""
        guard let data = try? JSONEncoder().encode(types),
                    let string = String(data: data, encoding: .utf8) else { return stringStyles = "" }
        stringStyles = string
        favorite.name = name
        favorite.imageUrl = imageUrl
        favorite.types = stringStyles
        favorite.baseExperience = Int64(baseExperience)
        favorite.hp = Int16(hp)
        favorite.attack = Int16(attack)
        favorite.defense = Int16(defense)
        favorite.specialAttack = Int16(specialAttack)
        favorite.specialDefense = Int16(specialDefense)
        favorite.speed = Int16(speed)
        favorite.height = Int64(height)
        favorite.weight = Int64(weight)
        Pokemon.database.save()
    }
}
