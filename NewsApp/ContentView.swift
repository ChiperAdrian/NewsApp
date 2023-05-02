//
//  ContentView.swift
//  NewsApp
//
//  Created by Adrian Gabriel Chiper on 27.04.2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        TabView {
            FeedView()
                .environmentObject(viewModel)
                .tabItem {
                    Image(systemName: "house")
                    Text("News")
                }

            MyNews()
                .environmentObject(viewModel)
                .tabItem {
                    Image(systemName: "newspaper")
                    Text("My articles")
                }

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
