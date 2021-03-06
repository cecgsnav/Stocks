//
//  PopupViewModel.swift
//  stocks
//
//  Created by Cecilia Soto on 6/8/19.
//  Copyright © 2019 Cecilia Soto. All rights reserved.
//

import SwiftUI
import Combine

typealias StockDetailViewModel = (stock: Symbol, fluctuation: [Fluctuation])

final class PopupViewModel: BindableObject {
    let didChange = PassthroughSubject<PopupViewModel, Never>()
    
    var isDoneLoading = false {
        didSet {
            didChange.send(self)
        }
    }
    
    let stock: Symbol
    
    var fluctuation: [Fluctuation] = [] {
        didSet {
            isDoneLoading = true
            didChange.send(self)
        }
    }
    
    private var cancellable: Cancellable? {
        didSet { oldValue?.cancel() }
    }
    
    init(stock: Symbol) {
        self.stock = stock
        getDetailInfo(for: stock)
    }
    
    func getReadableDate(date: Date) -> String {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        
        return dateFormatterPrint.string(from: date)
    }
    
    func getDifferenceStockValue(fluctuation: Fluctuation) -> Text {
        let difference = fluctuation.close - fluctuation.open
        let differenceRounded = String(format: "%.2f", difference)
        switch difference {
        case ...0:
            return Text("↓ \(differenceRounded)").color(.red)
        case 0...:
            return Text("↑ \(differenceRounded)").color(.green)
        case 0:
            return Text("\(differenceRounded)").color(.black)
        default:
            return Text("Range error")
        }
    }
    
    func getDetailInfo(for stock: Symbol) {
        guard var urlComponents = URLComponents(string: "https://api.iextrading.com/1.0/stock/\(stock.symbol)/chart/1m") else {
            print("Corrupt URL")
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "chartLast", value: "8")
        ]
        
        guard let url = urlComponents.url else { return }
        
        let request = URLRequest(url: url,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 60)
        
        let assign = Subscribers.Assign(object: self, keyPath: \.fluctuation)
        cancellable = assign
        
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD"
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        URLSession.shared.send(request: request)
            .map { $0.data }
            .decode(type: [Fluctuation].self, decoder: decoder)
            .replaceError(with: [])
            .receive(subscriber: assign)
    }
    
}
