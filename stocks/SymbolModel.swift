//
//  SymbolModel.swift
//  stocks
//
//  Created by Cecilia Soto on 6/8/19.
//  Copyright © 2019 Cecilia Soto. All rights reserved.
//

import Foundation

let dummySymbol = Symbol(symbol: "AAPL", name: "Apple Inc.", sector: "Technology")
let dummyFluctuation = Fluctuation(date: Date(), open: 10, close: 20)

struct Symbol: Decodable, Hashable {
    let symbol: String
    let name: String
    let sector: String
    
    enum CodingKeys: String, CodingKey {
        case symbol, name = "companyName", sector
    }
}

struct Fluctuation: Decodable, Hashable {
    let date: Date
    let open: Double
    let close: Double
}
