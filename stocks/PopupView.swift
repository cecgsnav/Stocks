//
//  PopupView.swift
//  stocks
//
//  Created by Cecilia Soto on 6/8/19.
//  Copyright © 2019 Cecilia Soto. All rights reserved.
//

import SwiftUI

struct PopupView: View {
    
    @EnvironmentObject private var viewModel: PopupViewModel
    var close: Binding<Bool>
    
    var body: some View {
        VStack {
            Text(self.viewModel.stock.symbol)
                .font(.title)
                .kerning(3)
                .padding(.bottom, 15)
            
            FieldView(title: "Company name:",
                      subtitle: self.viewModel.stock.name)
            
            FieldView(title: "Sector:",
                      subtitle: self.viewModel.stock.sector)
            
            Divider()
            
            VStack {
                Text("Stock value in the last week")
                    .font(.headline)
                    .bold()
                    .padding(.bottom, 10)
                
                ForEach(self.viewModel.fluctuation.sorted(by: ({ $0.date < $1.date})).identified(by: \.self)) { row in
                    HStack(alignment: .firstTextBaseline) {
                        Spacer()
                        Text(self.viewModel.getReadableDate(date: row.date))
                        Spacer()
                        self.viewModel.getDifferenceStockValue(fluctuation: row)
                        Spacer()
                    }
                }
            }
            
            Divider()
            
            Button(action: {
                withAnimation(.basic(duration: 1)) {
                    self.close.value.toggle()
                }
            }) {
                Text("Close")
                    .color(Color.blue)
                }
                .padding(.top, 15)
            
            }
            .frame(width: UIScreen.main.bounds.width * 0.7)
            .padding()
            .background(Color.white)
            .cornerRadius(5)
    }
}

struct FieldView: View {
    let title: String
    let subtitle: String?
    
    var body: some View {
        HStack {
            Text(title + " ")
            Text(subtitle ?? "").bold()
            //.relativeWidth(0.5).lineLimit(-1)
            }
            .padding(.bottom, 10)
    }
}
