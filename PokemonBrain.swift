//
//  PokemonBrainswift.swift
//  PokeFinder
//
//  Created by Oğuz Yıldırım on 26.06.2023.
//

import Foundation
import SwiftUI

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



