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
        return VStack {
            Text(self.viewModel.detailInfo.stock.symbol)
                .font(.title)
                .padding(.bottom, 15)

            FieldView(title: "Company name:",
                      subtitle: self.viewModel.detailInfo.stock.name)
            
            FieldView(title: "Sector:",
                      subtitle: self.viewModel.detailInfo.stock.sector)

            VStack {
            ForEach(self.viewModel.detailInfo.fluctuation.identified(by: \.self)) { row in
                HStack(alignment: .firstTextBaseline) {
                    Text(self.viewModel.getReadableDate(date: row.date))
                    Text(row.open.description)
                    Text(row.close.description)
                }
            }
            }
            
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
            .padding()
    }
}
