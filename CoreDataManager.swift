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
    // Change the URL with new copy file's URL
    let backupURL = storeURL.deletingLastPathComponent().appendingPathComponent("PokeFinderDataModel_Backup.sqlite")
    let backupURLPath = backupURL.path

    // If copy file is already exist then delete the file
    if FileManager.default.fileExists(atPath: backupURLPath) {
      do {
        try FileManager.default.removeItem(at: backupURL)
      } catch {
        fatalError("Failed to remove existing backup file.")
      }
    }

    // Add copy file URL to persistent store coordinator's options
    let options = [NSPersistentStoreURLKey: backupURL]

    return container
  }()

  func getViewContext() -> NSManagedObjectContext {
    return persistentContainer.viewContext
  }
  // Add pokemons to database
  func addPokemon(id: Int, name: String, weight: Int, type: String) {
    let context = persistentContainer.viewContext

    // Check if the Pokemon already exists in the database
    let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "id == %@", NSNumber(value: id))

    do {
      let existingPokemons = try context.fetch(fetchRequest)
      if let existingPokemon = existingPokemons.first {
        // Pokemon already exists, no need to add it again
        print("Pokemon already exists in the database. ID: \(existingPokemon.id), Name: \(existingPokemon.name)")
        return
      }
    } catch {
      print("Error fetching existing pokemons: \(error)")
      return
    }

    let pokemonObject = Pokemon(context: context)
    pokemonObject.id = Int32(id)
    pokemonObject.name = name
    pokemonObject.weight = Int32(weight)
    pokemonObject.type = type
    
    saveContext()
  }
  // Save changes on database
  private func saveContext() {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
        /*
         Print database path
         print("path", URL.documentsDirectory) -- /Users/oguzyildirim/Library/Developer/CoreSimulator/Devices/35632F7E-4112-4B05-AAFA-FC2EEB54A5ED/data/Containers/Data/Application/50C171B9-006B-4A34-8C2E-2726180A0059/Library/Application Support/PokeFinderDataModel.sqlite
         */

      } catch {
        let nsError = error as NSError
        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
      }
    }
  }
  // fetch pokemons from database
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
