//
//  CompaniesViewModel.swift
//  Companies
//
//  Created by ETAY LUZ on 11/26/24.
//

import SwiftUI

@MainActor
class CompaniesViewModel: ObservableObject {
    @Published var companies: [Company] = []
    @Published var query = ""
    @AppStorage("sortOrder") private var storedSortOrder: String?
    private let companiesService = CompanyService()
    private let companiesKey = "saved_companies"
    private var currentPage = 1


    init(companies: [Company] = [], currentPage: Int = 1) {
        self.companies = loadCompaniesFromLocalStorage()
        self.currentPage = currentPage
    }

    var sortOrder: String {
        get {
            storedSortOrder ?? "name" // Return the stored value or default to "name"
        }
        set {
            storedSortOrder = newValue // Store the new value
        }
    }

    func loadCompanies() async {
        do {
            let newCompanies = try await companiesService.fetchCompanies(page: currentPage)
            if currentPage > 1 {
                companies += newCompanies // Append new companies to companies from previous pages
            } else {
                companies = newCompanies // Override companies retrieved from Local Storage on first page
            }
            companies = sortCompanies(companies)
            currentPage += 1
            saveCompaniesToLocalStorage(companies)
        } catch {
            print("Failed to fetch Companies: \(error)")
        }
    }

    func sortCompanies(_ companies: [Company]) -> [Company] {
        switch sortOrder {
        case "name":
            return companies.sorted(by: { $0.name < $1.name })
        case "marketCap":
            return companies.sorted(by: { $0.marketCap.raw > $1.marketCap.raw })
        default:
            return companies
        }
    }

    func updateSortOrder() {
        companies = sortCompanies(companies)
    }

    var filteredCompanies: [Company] {
        let filteredCompanies = companies.filter { company in
            query.count == 0 ||
            company.symbol.lowercased().contains(query.lowercased()) ||
            company.name.lowercased().contains(query.lowercased())
        }
        return filteredCompanies
    }

    private func saveCompaniesToLocalStorage(_ companies: [Company]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(companies) {
            UserDefaults.standard.set(encoded, forKey: companiesKey)
        }
    }

    private func loadCompaniesFromLocalStorage() -> [Company] {
        if let savedData = UserDefaults.standard.data(forKey: companiesKey),
           let decodedCompanies = try? JSONDecoder().decode([Company].self, from: savedData) {
            return decodedCompanies
        }
        return []
    }
}
