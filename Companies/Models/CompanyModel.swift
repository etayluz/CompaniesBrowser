//
//  CompanyModel.swift
//  Companies
//
//  Created by ETAY LUZ on 11/26/24.
//

import Foundation

struct MarketCap: Codable {
    let fmt: String
    let longFmt: String
    let raw: Int
}

struct Company: Identifiable, Codable, Equatable {
    var id: String { symbol }
    let symbol: String
    let name: String
    let marketCap: MarketCap
    let logoURL: URL?

    static func == (lhs: Company, rhs: Company) -> Bool {
        return lhs.name == rhs.name && lhs.marketCap.raw == rhs.marketCap.raw
    }
}
