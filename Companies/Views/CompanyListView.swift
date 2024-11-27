//
//  CompanyListView.swift
//  Companies
//
//  Created by ETAY LUZ on 11/26/24.
//

import SwiftUI

struct CompanyListView: View {
    @StateObject private var viewModel = CompaniesViewModel()
    @State private var showingSettings = false
    @State private var searchText  = ""

    var body: some View {
        NavigationStack {
            List(viewModel.filteredCompanies) { company in
                NavigationLink(destination: CompanyDetailView(company: company)) {
                    HStack {
                        Text(company.name)
                        AsyncImage(url: nil) { image in
                            image.resizable().scaledToFit()
                        } placeholder: {
                            Image(systemName: "photo")
                        }
                        .frame(width: 50, height: 50)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Settings") {
                        showingSettings = true
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView(sortOrder: $viewModel.sortOrder, onUpdate: {
                    Task {
                        await MainActor.run {
                            viewModel.updateSortOrder()
                        }
                    }
                })
            }
        }
        .searchable(text: $searchText)
        .onChange(of: searchText) { _, newValue in
            viewModel.query = newValue
        }
        .task {
            await viewModel.loadCompanies()
        }
    }
}

struct CompanyListView_Previews: PreviewProvider {
    static var previews: some View {
        CompanyListView()
    }
}
