//
//  ContentView.swift
//  stocks
//
//  Created by Cecilia Soto on 6/8/19.
//  Copyright © 2019 Cecilia Soto. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    
    @EnvironmentObject private var viewModel: ListViewModel
    @State private var shouldShowPopup: Bool = false
    @State private var searchText: String = ""
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    SegmentedControl(selection: self.$viewModel.selectedListMode) {
                        ForEach(ListMode.allCases.identified(by: \.self)) {
                            Text($0.title)
                        }
                    }
                        .padding()
                    
                    if self.viewModel.isInSearchMode() {
                        SearchBarView(text: self.$searchText) {
                            self.viewModel.getList(for: .Search, searchText: self.searchText)
                        }
                    }
                    
                    List {
                        ForEach(self.viewModel.list.identified(by: \.self)) { symbol in
                            Button(action: {
                                withAnimation(.basic(duration: 1)) {
                                    self.shouldShowPopup.toggle()
                                }
                            }) {
                                StockRowView(symbol: symbol)
                            }
                        }
                    }
                    
                    }
                    .navigationBarTitle(Text(self.viewModel.selectedListMode.title))
            }
            
            if self.shouldShowPopup {
                PopupView(close: self.$shouldShowPopup).environmentObject(PopupViewModel(stock: dummySymbol))
                    .frame(width: UIScreen.main.bounds.width,
                           height: UIScreen.main.bounds.height)
                    .background(Color.black.opacity(0.4))
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
