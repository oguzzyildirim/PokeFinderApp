//
//  CoreDataManager.swift
//  PokeFinder
//
//  Created by Oğuz Yıldırım on 1.07.2023.
//

import Foundation
import CoreData

class CoreDataManager {
  static let shared = CoreDataManager()

  private lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "PokeFinderDataModel")
    container.loadPersistentStores { _, error in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }

    guard let storeURL = container.persistentStoreDescriptions.first?.url else {
      fatalError("Persistent store URL not found.")
    }

    // URL'yi yeni bir kopya dosya URL'siyle değiştirin
    let backupURL = storeURL.deletingLastPathComponent().appendingPathComponent("PokeFinderDataModel_Backup.sqlite")
    let backupURLPath = backupURL.path

    // Eğer kopya dosyası zaten varsa silin
    if FileManager.default.fileExists(atPath: backupURLPath) {
      do {
        try FileManager.default.removeItem(at: backupURL)
      } catch {
        fatalError("Failed to remove existing backup file.")
      }
    }

    // Persistent store coordinator'ın options'larına kopya dosya URL'sini ekleyin
    let options = [NSPersistentStoreURLKey: backupURL]

    return container
  }()
  func getViewContext() -> NSManagedObjectContext {
    return persistentContainer.viewContext
  }
  // Diğer Core Data yöntemlerini burada tanımlayabilirsiniz
  // Örneğin, veri ekleme, sorgulama, güncelleme, silme işlemleri

  // Örnek bir işlem metodu
  func addPokemon(id: Int, name: String, weight: Int, type: String) {
    let context = persistentContainer.viewContext
    let pokemonObject = Pokemon(context: context)
    pokemonObject.id = Int32(id)
    pokemonObject.name = name
    pokemonObject.weight = Int32(weight)
    pokemonObject.type = type
    
    saveContext()
  }

  private func saveContext() {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
        //print("path", URL.documentsDirectory) -- /Users/oguzyildirim/Library/Developer/Xcode/UserData/Previews/Simulator Devices/8FE28E56-498D-4B79-B8AB-FCFC3EA55419/data/Containers/Data/Application/A463C7F9-E62B-40C5-A0D7-6B029E74A7B3/Library/Application Support/PokeFinderDataModel.sqlite
      } catch {
        let nsError = error as NSError
        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
      }
    }
//    if context.hasChanges {
//      do {
//        try context.save()
//      } catch {
//        let nsError = error as NSError
//        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//      }
//    }
  }
  func fetchPokemonsFromDatabase() {
    let context = persistentContainer.viewContext
    let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()

    do {
      let pokemons = try context.fetch(fetchRequest)
      for pokemon in pokemons {
        print("ID: \(pokemon.id), Name: \(pokemon.name), Weight: \(pokemon.weight), Type: \(pokemon.type)")
      }
    } catch {
      print("Error fetching pokemons: \(error)")
    }
  }
}


//class CoreDataManager {
//  static let shared = CoreDataManager()
//
//  lazy var persistentContainer: NSPersistentContainer = {
//    let container = NSPersistentContainer(name: "PokemonDataModel")
//    container.loadPersistentStores { _, error in
//      if let error = error as NSError? {
//        fatalError("Unresolved error \(error), \(error.userInfo)")
//      }
//    }
//    return container
//  }()
//
//  var mainContext: NSManagedObjectContext {
//    return persistentContainer.viewContext
//  }
//
//  func saveContext() {
//    if mainContext.hasChanges {
//      do {
//        try mainContext.save()
//      } catch {
//        print("Core Data save error: \(error)")
//      }
//    }
//  }
//}
