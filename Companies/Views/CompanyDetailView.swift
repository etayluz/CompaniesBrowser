//
//  CompanyDetailView.swift
//  Companies
//
//  Created by ETAY LUZ on 11/26/24.
//

import SwiftUI
import Foundation

struct CompanyDetailView: View {
    let company: Company
    @State private var isFavorite = false
    @AppStorage("favorite_companies") private var favoriteCompaniesData: Data?

    var body: some View {
        VStack {
            Button(action: {
                isFavorite.toggle()
                updateFavorites()
            }) {
                Label("Favorite", systemImage: isFavorite ? "star.fill" : "star")
            }

            AsyncImage(url: nil) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                Image(systemName: "photo")
            }
            .frame(width: 50, height: 50)

            Text("Name: \(company.name)")
            Text("Market Cap: $\(String(company.marketCap.fmt))")
        }
        .padding()
        .onAppear() {
            if let favoriteData = favoriteCompaniesData,
               let favorites = try? JSONDecoder().decode([String: Bool].self, from: favoriteData),
               let isFav = favorites[company.id] {
                isFavorite = isFav
            } else {
                isFavorite = false
            }
        }
    }

    private func updateFavorites() {
            var favorites = [String: Bool]()

            if let favoriteData = favoriteCompaniesData,
               let decodedFavorites = try? JSONDecoder().decode([String: Bool].self, from: favoriteData) {
                favorites = decodedFavorites
            }

            favorites[company.id] = isFavorite
            if let encoded = try? JSONEncoder().encode(favorites) {
                favoriteCompaniesData = encoded
            }
        }
}
