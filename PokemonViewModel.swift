//
//  PokemonViewModel.swift
//  PokeFinder
//
//  Created by Oğuz Yıldırım on 26.06.2023.
//

import SwiftUI
import Combine
import Alamofire

class PokemonViewModel: ObservableObject{
  
  @Published var pokemons: [PokemonBrain?] = []
  @Published var isFetchingComplete: Bool = false
  public let Colors: [String: String] =  [
    "fire" : "#FDDFDF",
    "grass" : "#DEFDE0",
    "electric" : "#FCF7DE",
    "water" : "#DEF3FD",
    "ground" : "#F4E7DA",
    "rock" : "#D5D5D4",
    "fairy" : "#FCEAFF",
    "poison" : "#D6B3FF",
    "bug" : "#F8D5A3",
    "dragon" : "#97B3E6",
    "psychic" : "#EAEDA1",
    "flying" : "#F5F5F5",
    "fighting" : "#E6E0D4",
    "normal" : "#F5F5F5",
    "ice" : "#E0F5FF"
  ]
  
  func fetchPost() {
    let coreDataManager = CoreDataManager.shared
    let context = coreDataManager.getViewContext()
    
    let group = DispatchGroup()
    
    for index in 1...151 {
      group.enter()
      
      AF.request("https://pokeapi.co/api/v2/pokemon/\(index)")
        .validate()
        .responseDecodable(of: PokemonBrain.self) { response in
          defer {
            group.leave()
          }
          
          if let pokemon = response.value {
            DispatchQueue.main.async {
              self.pokemons.append(pokemon)
              coreDataManager.addPokemon(id: pokemon.id ?? 404, name: pokemon.name ?? "Not Found", weight: pokemon.weight ?? 404, type: pokemon.types?[0].type?.name ?? "Not Found")
            }
          } else if let error = response.error {
            print(error)
          }
        }
    }
    
    group.notify(queue: .main) {
      self.isFetchingComplete = true
      
      // Sort pokemons by id
      self.pokemons.sort { $0?.id ?? 0 < $1?.id ?? 0 }
      
      // Print sorted pokemons id
      for (index, pokemon) in self.pokemons.enumerated() {
        print("\(index + 1): \(pokemon?.id ?? 1)")
      }
    }
  }
}

// The padStart func is provides that add zero front of a string with a number. So this func added to String as extension.
extension String {
  
  func padStart(toLength length: Int, withPad padCharacter: Character) -> String {
    let padCount = length - self.count
    if padCount <= 0 {
      return self
    }
    let padding = String(repeating: padCharacter, count: padCount)
    return padding + self
  }
}

//The init method is provides that an hex code convert to rgb color. So this method added to Color as extension.
extension Color {
  init?(hex: String) {
    var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
    hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
    
    var rgb: UInt64 = 0
    
    var r: CGFloat = 0.0
    var g: CGFloat = 0.0
    var b: CGFloat = 0.0
    var a: CGFloat = 1.0
    
    let length = hexSanitized.count
    
    guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
    
    if length == 6 {
      r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
      g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
      b = CGFloat(rgb & 0x0000FF) / 255.0
      
    } else if length == 8 {
      r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
      g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
      b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
      a = CGFloat(rgb & 0x000000FF) / 255.0
      
    } else {
      return nil
    }
    
    self.init(red: r, green: g, blue: b, opacity: a)
  }
}

