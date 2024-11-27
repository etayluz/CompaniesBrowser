//
//  CompanyService.swift
//  Companies
//
//  Created by ETAY LUZ on 11/26/24.
//

import Foundation
import SwiftUI

class CompanyService {
    func fetchCompanies(page: Int) async throws -> [Company] {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "us-central1-fbconfig-90755.cloudfunctions.net"
        components.path = "/getAllCompanies"
        components.queryItems = [URLQueryItem(name: "page", value: String(page))]

        guard let url = components.url else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        if let responseString = String(data: data, encoding: .utf8) {
            let updatedString = responseString.replacingOccurrences(of: "null,", with: "")
            let fixedData = updatedString.data(using: .utf8)!
            let companies = try JSONDecoder().decode([Company].self, from: fixedData)
            return companies
        } else {
            print("Failed to fetch data")
            throw URLError(.badServerResponse)
        }
    }
}

