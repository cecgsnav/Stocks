//
//  SearchBarView.swift
//  stocks
//
//  Created by Cecilia Soto on 6/8/19.
//  Copyright © 2019 Cecilia Soto. All rights reserved.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var text: String
    @State var action: () -> Void
    
    var body: some View {
        HStack {
            TextField(
                $text,
                placeholder: Text("Write Symbol")
                    .color(Color.black))
                .padding([.leading, .trailing], 8)
                .frame(height: 32)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            
            Button(
                action: action,
                label: { Text("Search")
            .color(Color.blue) }
                )
            }
            .padding()
    }
}
