//
//  FeedView.swift
//  NewsApp
//
//  Created by Adrian Gabriel Chiper on 28.04.2023.
//

import SwiftUI
import CryptoKit

struct FeedView: View {
    @State var searchTxt = ""
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Image("Articles")
                    .resizable()
                    .scaledToFit()
                CustomSearchBar(text: $searchTxt).padding(.bottom)
                LazyVStack {
                    ForEach(viewModel.getNewsSortedByDate(ascending: false)) { news in
                        VStack(alignment: .leading, spacing: 5) {
                            Text(news.title).bold().font(.title3).padding(.bottom, 10)
                            Text(news.description).font(.footnote).padding(.bottom, 10)
                            HStack {
                                Text(news.publicationDate, style: .date).bold().font(.footnote).foregroundColor(Color(red: 130/255, green: 130/255, blue: 140/255))
                                Spacer()
                                Link("See more", destination: URL(string: news.link)!).bold().font(.footnote)
                                Button {
                                    if viewModel.myNews.contains(where: {$0.id == news.id}) {
                                        viewModel.delete(id: news.id)
                                    }
                                    else {
                                        viewModel.save(news: news)
                                    }
                                }label: {
                                    Image(systemName: viewModel.myNews.contains(where: {$0.id == news.id}) ? "heart.fill" : "heart")
                                        .foregroundColor(viewModel.myNews.contains(where: {$0.id == news.id}) ? .red : .gray)
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
        .padding()
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView().environmentObject(ViewModel())
    }
}
