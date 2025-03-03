//
//  ContentView.swift
//  BasketballGames
//
//  Created by Samuel Shi on 2/27/25.
//

import SwiftUI

struct Response: Codable {
    var results: [Game]
}

struct Game: Codable, Identifiable {
    var id: Int
    var team: String
    var opponent: String
    var score: Score
    var date: String
    var isHomeGame: Bool
}

struct Score: Codable {
    var unc: Int
    var opponent: Int
}

struct ContentView: View {
    @State private var results = [Game]()
    
    var body: some View {
        List(results) { game in
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(game.team) vs. \(game.opponent)")
                            .fontWeight(.bold)
                        Text(game.date)
                            .font(.caption)
                    }
                    Spacer()
                    VStack(alignment: .trailing){
                        Text("\(game.score.unc) - \(game.score.opponent)")
                            .fontWeight(.bold)
                        Text((game.isHomeGame ? "Home" : "Away"))
                            .font(.caption)
                    }
                }
            }
        }
        .task {
            await loadData()
        }
    }
    
    func loadData() async {
        guard let url = URL(string: "https://api.samuelshi.com/uncbasketball") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResponse = try JSONDecoder().decode([Game].self, from: data)
            DispatchQueue.main.async {
                results = decodedResponse
            }
        } catch {
            print("Invalid Data")
        }
    }
}


#Preview {
    ContentView()
}
