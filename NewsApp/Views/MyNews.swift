//
//  MyNews.swift
//  NewsApp
//
//  Created by Adrian Gabriel Chiper on 28.04.2023.
//

import SwiftUI

struct MyNews: View {
    @State var searchTxt = ""
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                Image("MyArticles")
                    .resizable()
                    .scaledToFit()
                CustomSearchBar(text: $searchTxt).padding(.bottom)
                if viewModel.myNews.isEmpty {
                    Spacer()
                    Image("NoData")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                    Text("You have no articles saved")
                        .foregroundColor(Color(red: 230/255, green: 230/255, blue: 230/255))
                        .bold()
                        .font(.title3)
                    Spacer()
                }
                else {
                    LazyVStack {
                        ForEach(viewModel.myNews) { news in
                            VStack(alignment: .leading, spacing: 5) {
                                Text(news.title).bold().font(.title3).padding(.bottom, 10)
                                Text(news.description).font(.footnote).padding(.bottom, 10)
                                HStack {
                                    Text(news.publicationDate, style: .date).bold().font(.footnote).foregroundColor(Color(red: 130/255, green: 130/255, blue: 140/255))
                                    Spacer()
                                    Link("See more", destination: URL(string: news.link)!).bold().font(.footnote)
                                    Button {
                                        viewModel.delete(id: news.id)
                                    }label: {
                                        Image(systemName: "heart.fill") .foregroundColor(.red)
                                    }
                                }
                            }
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(red: 230/255, green: 230/255, blue: 230/255), lineWidth: 1)
                            )
                            .padding(.horizontal, 5)
                        }
                    }
                }

            }
        }
        .padding()
    }
}

struct MyNews_Previews: PreviewProvider {
    static var previews: some View {
        MyNews()
    }
}
