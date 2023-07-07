//
//  PokemonViewModel.swift
//  PokeFinder
//
//  Created by Oğuz Yıldırım on 26.06.2023.
//

import SwiftUI
import Combine
import Alamofire

//bu kod şimdilik sadeve pokemonun api'dan name ve weight değerini çekmek için kullanılırken çalışıyor.
class PokemonViewModel: ObservableObject{
//  @Published var pokemons: [PokemonBrain?] = []
//  func fetchPost() {
//    for index in 1...151 {
//      AF.request("https://pokeapi.co/api/v2/pokemon/\(index)")
//        .validate()
//        .responseDecodable(of: PokemonBrain.self) { response in
//          if let pokemons = response.value {
//            //                let result = "[firstkey: \"\(pokemons.name)\"]"
//            //print(response.result)
//            self.pokemons.append(pokemons)
//          } else if let error = response.error {
//            print(error)
//          }
//        }
//    }
//  }
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

//  func fetchPost() {
//    let group = DispatchGroup()
//
//    for index in 1...151 {
//      group.enter()
//
//      AF.request("https://pokeapi.co/api/v2/pokemon/\(index)")
//        .validate()
//        .responseDecodable(of: PokemonBrain.self) { response in
//          defer {
//            group.leave()
//          }
//
//          if let pokemon = response.value {
//            DispatchQueue.main.async {
//              self.pokemons.append(pokemon)
//              //print(self.pokemons[index]?.name ?? "hata")
//            }
//          } else if let error = response.error {
//            print(error)
//          }
//        }
//
//    }
//
//    group.notify(queue: .main) {
//      self.isFetchingComplete = true
//      for (index, pokemon) in self.pokemons.enumerated() {
//          print("\(index + 1): \(pokemon?.id ?? 1)")
//        }
//    }
//  }
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

              //let pokemonObject = Pokemon(context: context)
              coreDataManager.addPokemon(id: pokemon.id ?? 404, name: pokemon.name ?? "Not Found", weight: pokemon.weight ?? 404, type: pokemon.types?[0].type?.name ?? "Not Found")
//              pokemonObject.id = Int32(pokemon.id ?? 404)
//              pokemonObject.name = pokemon.name
//              pokemonObject.weight = Int32(pokemon.weight ?? 404)
//              pokemonObject.type = pokemon.types?[0].type?.name
            }
          } else if let error = response.error {
            print(error)
          }
        }
    }

    group.notify(queue: .main) {
      self.isFetchingComplete = true

      // Pokemons dizisini id değerlerine göre sırala
      self.pokemons.sort { $0?.id ?? 0 < $1?.id ?? 0 }

      // Sıralanmış Pokémonların id değerlerini yazdır
      for (index, pokemon) in self.pokemons.enumerated() {
        print("\(index + 1): \(pokemon?.id ?? 1)")
      }
      //coreDataManager.fetchPokemonsFromDatabase()
    }
  }



//  func loadImages(){
//    guard let url = URL(string: "https://assets.pokemon.com/assets/cms2/img/pokedex/full/001.png") else {
//      return
//    }
////    AF.request(url).responseData { response in
////        switch response.result {
////        case .success(let data):
////            // Veriyi başarıyla aldınız.
////            // Data üzerinde işlemleri burada gerçekleştirin.
////            print("Data received successfully.")
////        case .failure(let error):
////            // Hata oluştu, hatayı burada kontrol edin ve sorunu belirleyin.
////            print("Error: \(error)")
////        }
////    }
//    AF.request(url).responseData {response in
//      if let data = response.value {
//        DispatchQueue.main.async {
//          if let image = UIImage(data: data) {
//            self.pokemons?.image = data
//          }
//          print(self.pokemons?.image)
//        }
//      }
//      else {
//        print("error!!!")
//
//      }
//    }
//  }
}



//class PokemonViewModel: ObservableObject {
//  @Published var pokemons: PokemonBrain?
//  func fetch() {
//    guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/1") else {
//      return
//    }
//    let task = URLSession.shared.dataTask(with: url) {data, _,
//      error in
//      guard let data = data, error == nil else {
//        return
//      }
//
//      // Convert to JSON
//      do {
//        let pokemons = try JSONDecoder().decode(PokemonBrain.self, from: data)
//        DispatchQueue.main.async {
//          self.pokemons = pokemons
//        }
//      }
//      catch{
//        print(error)
//      }
//    }
//    task.resume()
//  }
//}

//final class PokemonViewModel: ObservableObject {
//  @Published var pokemons: PokemonBrain?
//
//  @MainActor
//  func fetchPokemon() async {
//    let url = "https://pokeapi.co/api/v2/pokemon/1"
//
//    AF.request(url).responseDecodable(of: PokemonBrain.self) { response in
//      if let error = response.error {
//        print("API isteği sırasında hata oluştu: \(error.localizedDescription)")
//        return
//      }
//
//      guard let pokemon = response.value else {
//        print("Decode hatası: Veri boş")
//        return
//      }
//
//      DispatchQueue.main.async {
//        self.pokemons = pokemon
//      }
//    }
//  }
//
//  @MainActor
//  func loadImage() async {
//    guard let url = URL(string: "https://assets.pokemon.com/assets/cms2/img/pokedex/full/001.png") else {
//      return
//    }
//
//    AF.request(url).responseData { response in
//      if let data = response.value {
//        DispatchQueue.main.async {
//          self.pokemons?.image = data
//        }
//      }
//    }
//  }
//}

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
//  let sprites: SpriteDetails?
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

