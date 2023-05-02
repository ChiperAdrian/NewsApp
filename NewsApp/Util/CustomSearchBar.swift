//
//  CustomSearchBar.swift
//  NewsApp
//
//  Created by Adrian Gabriel Chiper on 27.04.2023.
//

import SwiftUI

struct CustomSearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass").foregroundColor(.gray)
            TextField("Search", text: $text)
                .font(Font.system(size: 21))
        }
        .padding(7)
        .background(Color(red: 230/255, green: 230/255, blue: 230/255))
        .cornerRadius(50)
    }
}
