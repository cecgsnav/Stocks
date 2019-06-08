//
//  StockRowView.swift
//  stocks
//
//  Created by Cecilia Soto on 6/8/19.
//  Copyright © 2019 Cecilia Soto. All rights reserved.
//

import SwiftUI

struct StockRowView: View {
    let symbol: Symbol
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(symbol.symbol).font(.body)
            Text(symbol.name).font(.footnote)
        }
    }
}
