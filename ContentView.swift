//
//  ContentView.swift
//  PokeFinder
//
//  Created by Oğuz Yıldırım on 26.06.2023.
//

import SwiftUI
struct ContentView: View {
  @State private var searchText: String = ""
  @StateObject private var pokemonViewModel = PokemonViewModel()
  var filteredPokemons: [PokemonBrain?] {
    guard !searchText.isEmpty else{return pokemonViewModel.pokemons}
    return pokemonViewModel.pokemons.filter{$0?.name?.localizedCaseInsensitiveContains(searchText) ?? false}
  }
  //var count: [Int] = Array(1...151)
  //adaptiveColumns minimum değerimle frame değerimin width'i aynı olmalı
  private let adaptiveColumns = [
    GridItem(.adaptive(minimum: 170))
  ]

  var body: some View {
    NavigationStack{
      ZStack{
        Color("BackgroundColor").ignoresSafeArea()
        VStack{
          Spacer()
          ScrollView{
            LazyVGrid(columns: adaptiveColumns, spacing: 20){
              if pokemonViewModel.isFetchingComplete {
                ForEach(filteredPokemons, id: \.self){pokemon in
                  ZStack{
                    Rectangle()
                      .frame(width: 170, height: 250)
                      .cornerRadius(30)
                      .foregroundColor(Color.init(hex: (pokemonViewModel.Colors[pokemon?.types?[0].type?.name ?? ""]) ?? "#FFFFFF"))

                    AsyncImage(url: URL(string: "https://assets.pokemon.com/assets/cms2/img/pokedex/full/\(String(pokemon?.id ?? 1).padStart(toLength: 3, withPad: "0")).png")){ phase in
                      switch phase {
                      case .empty:
                        // Placeholder görüntü
                        Image("pokeBall")
                          .resizable()
                          .frame(width: 100, height: 120)
                          .cornerRadius(10)
                          .padding(.bottom, 100)
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
                    Text(pokemon?.name ?? "Not Found")
                      .foregroundColor(.black)
                      .bold()
                      .padding(.top, 50)
                    Text("#\(String(pokemon?.id ?? 0).padStart(toLength: 3, withPad: "0"))")
                      .foregroundColor(.black)
                      .padding(.top, 100)
                    Text("\(String(pokemon?.weight ?? 404)) Kg")
                      .foregroundColor(.black)
                      .padding(.top, 150)
                    Text(pokemon?.types?[0].type?.name ?? "Not Found")
                      .foregroundColor(.black)
                      .padding(.top, 200)
                  }
                }
              }
              else{
                ProgressView()
                  .progressViewStyle(CircularProgressViewStyle())
              }
            }
            .padding(.horizontal, 20)
          }
        }
      }
      .navigationTitle("PokeFinder")
      .searchable(text: $searchText, prompt: "Search")
        .onAppear{
          pokemonViewModel.fetchPost()
        }
    }
  }
}


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}




//          HStack{
//            ZStack{
//              Rectangle()
//                .foregroundColor(Color(red: 222/255, green: 253/255, blue: 224/255))
//                .cornerRadius(30)
//              Image("sample-image")
//                .resizable()
//                .frame(width: 105, height: 130)
//                .padding(.bottom, 85)
//              Text("Bulbausar")
//                .foregroundColor(.black)
//                .bold()
//                .padding(.top, 90)
//            }
//            .frame(width: 170, height: 250, alignment: .center)
//            ZStack{
//              Rectangle()
//                .foregroundColor(Color(red: 222/255, green: 253/255, blue: 224/255))
//                .cornerRadius(30)
//              Image("sample-image")
//                .resizable()
//                .frame(width: 105, height: 130)
//                .padding(.bottom, 85)
//              Text("Bulbausar")
//                .foregroundColor(.black)
//                .bold()
//                .padding(.top, 90)
//            }
//            .frame(width: 170, height: 250, alignment: .center)
//
//          }
//          Spacer(minLength: 335)





//          Text("PokeFinder")
//            .font(.system(size: 35))
//            .foregroundColor(Color("TextColor"))
//            .bold()
//            .padding()
//            .frame(minWidth: 400, alignment: .leading)
//            .padding(.vertical, 10)
//          HStack{
//            TextField("Find Pokemon..", text: $searchText)
//              .padding()
//              .background(Color("BackgroundColor").cornerRadius(20))
//              .padding(.horizontal, 10)
//              .foregroundColor(Color("TextColor"))
//              .bold()
//              .multilineTextAlignment(.center)
//
//
//            Button(action: {
//              searchText = ""
//            }, label: {
//              Text("Cancel")
//                .foregroundColor(Color("TextColor"))
//                .padding(.trailing, 18)
//            })
//          }.padding(.bottom, 10)
