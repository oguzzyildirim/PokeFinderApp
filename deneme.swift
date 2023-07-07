//
//  deneme.swift
//  PokeFinder
//
//  Created by Oğuz Yıldırım on 26.06.2023.
//

import SwiftUI
// bu kod başarılı. pokemonun name ve weight değerlerini alamofire kullanarak api'dan çekebiliyorum

struct deneme: View {
  @StateObject var pokemonViewModell = PokemonViewModel()
  @State var searchTmp: String = ""

  var filteredNames: [PokemonBrain?] {
    guard !searchTmp.isEmpty else{return pokemonViewModell.pokemons}
    return pokemonViewModell.pokemons.filter{$0?.name?.localizedCaseInsensitiveContains(searchTmp) ?? false}
  }
  //@State var str: String?
  //@State var count: Int = 0
  var countt: [Int] = Array(1...151)
  var body: some View {
    NavigationStack{
      ScrollView{
        VStack {
          if pokemonViewModell.isFetchingComplete {
            ForEach(filteredNames, id: \.self) { pokemon in

              ZStack{
                HStack{
                  Text("BABA")
                    .font(.headline)
                  Text(pokemon?.types?[0].type?.name ?? "404")
                  Text(pokemon?.name ?? "404")
                  Button(action: {
                    searchTmp = ""
                  }, label: {
                    Text("cancel")
                  })
                  AsyncImage(url: URL(string: "https://assets.pokemon.com/assets/cms2/img/pokedex/full/\(String(1).padStart(toLength: 3, withPad: "0")).png")){ phase in
                    switch phase {
                    case .empty:
                      // Placeholder görüntü
                      Color.gray
                    case .success(let image):
                      // Başarılı şekilde indirilen görüntü
                      image
                        .resizable()
                        .frame(width: 100, height: 120)
                        .padding(.bottom, 100)
                    case .failure(_):
                      // Hata durumu için görüntü
                      Color.red
                    @unknown default:
                      // Bilinmeyen durum için görüntü
                      Color.gray
                    }
                  }

                }

              }
            }
          }
        }
      }
      .navigationTitle("hello")
      .searchable(text: $searchTmp)

    }
    .onAppear {
      pokemonViewModell.fetchPost()

    }
  }

}


struct deneme_Previews: PreviewProvider {
  static var previews: some View {
    deneme()
  }
}


//  fileprivate func banabasVStackView() -> some View {
//    return VStack {
//      Text(pokemonViewModell.pokemons?.types?[0].type?.name ?? "hello")
//      Text(pokemonViewModell.pokemons?.name ?? "hello")
//      Spacer().frame(height: 10)
//      Button(
//        action: {
//          count += 1
//        },
//        label: {
//          Text("banabaszzz")
//            .font(.system(size: 23))
//        }
//      )
//      Text("\(pokemonViewModell.pokemons?.weight ?? 23)")
//    }.onAppear{
//      pokemonViewModell.fetchPost()
//    }
//    //.padding()
//  }
//  fileprivate func countArttır() -> Int {
//    return pokemonViewModell.pokemons?.weight ?? 20
//  }
