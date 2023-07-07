//
//  PokemonBrainswift.swift
//  PokeFinder
//
//  Created by Oğuz Yıldırım on 26.06.2023.
//

import Foundation
import SwiftUI

//struct PokemonBrain: Decodable {
//  let name: String
//  let weight: Int
//  let types: [PokemonType]
//
//  struct PokemonType: Decodable {
//    let slot: Int
//    let type: TypeDetails
//
//    struct TypeDetails: Decodable {
//      let name: String
//      let url: String
//    }
//  }
//
//  let sprites: SpriteDetails
//
//  struct SpriteDetails: Decodable {
//    let frontDefault: String
//
//    enum CodingKeys: String, CodingKey {
//      case frontDefault = "front_default"
//    }
//  }
//
//  var image: Data?
//}


struct PokemonBrain: Decodable, Hashable, Equatable {
  static func == (lhs: PokemonBrain, rhs: PokemonBrain) -> Bool {
    return lhs.id == rhs.id
  }
  func hash(into hasher: inout Hasher) {
          hasher.combine(id)
  }
  let id: Int?
  let name: String?
  let weight: Int?
  let types: [type]?
  


  struct type: Decodable, Hashable {
    let type: typeInfo?
  }
  struct typeInfo: Decodable, Hashable {
    let name: String?
  }
}



