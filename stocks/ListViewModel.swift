//
//  ViewModel.swift
//  stocks
//
//  Created by Cecilia Soto on 6/8/19.
//  Copyright © 2019 Cecilia Soto. All rights reserved.
//

import SwiftUI
import Combine

enum ListMode: String, CaseIterable, Equatable {
    case TopGain, MostActive, Search
    
    var title: String {
        switch self {
        case .TopGain: return "Top Gain"
        case .MostActive: return "Most Active"
        case .Search: return "Search"
        }
    }
}

final class ListViewModel: BindableObject {
    let didChange = PassthroughSubject<ListViewModel, Never>()
    
    var list: [Symbol] = [] {
        didSet {
            didChange.send(self)
        }
    }
    
    var selectedListMode: ListMode = .TopGain {
        didSet {
            getList(for: selectedListMode)
            didChange.send(self)
        }
    }
    
    private var cancellable: Cancellable? {
        didSet { oldValue?.cancel() }
    }
    
    init() {
        getList(for: selectedListMode)
    }
    
    func isInSearchMode() -> Bool {
        return selectedListMode == .Search
    }
    
    func getList(for mode: ListMode, searchText: String = "") {
        //list = [dummySymbol]
        list.removeAll()
        switch mode {
        case .TopGain:
            getTopGainList()
        case .MostActive:
            getMostActiveList()
        case .Search:
            getSearch(symbol: searchText)
        }
    }
    
    private func getTopGainList() {
        guard let url = URL(string: "https://api.iextrading.com/1.0/stock/market/list/gainers") else {
            print("Corrupt URL")
            return
        }
        
        let request = URLRequest(url: url,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 60)
        
        let assign = Subscribers.Assign(object: self, keyPath: \.list)
        cancellable = assign
        
        URLSession.shared.send(request: request)
            .map { $0.data }
            .decode(type: [Symbol].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .receive(subscriber: assign)
    }
    
    private func getMostActiveList() {
        guard let url = URL(string: "https://api.iextrading.com/1.0/stock/market/list/mostactive") else {
            print("Corrupt URL")
            return
        }
        
        let request = URLRequest(url: url,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 60)
        
        let assign = Subscribers.Assign(object: self, keyPath: \.list)
        cancellable = assign
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        URLSession.shared.send(request: request)
            .map { $0.data }
            .decode(type: [Symbol].self, decoder: decoder)
            .replaceError(with: [])
            .receive(subscriber: assign)
    }
    
    private func getSearch(symbol: String) {
        guard !symbol.isEmpty else { return }
        
        let cleanSymbol = symbol.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        guard let url = URL(string: "https://api.iextrading.com/1.0/stock/\(cleanSymbol)/company") else {
            print("Corrupt URL")
            return
        }
        
        let request = URLRequest(url: url,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 60)
        
        let assign = Subscribers.Assign(object: self, keyPath: \.list)
        cancellable = assign
        
        URLSession.shared.send(request: request)
            .map { $0.data }
            .decode(type: Symbol.self, decoder: JSONDecoder())
            .map({[$0]})
            .replaceError(with: [])
            .receive(subscriber: assign)
    }
    
}
