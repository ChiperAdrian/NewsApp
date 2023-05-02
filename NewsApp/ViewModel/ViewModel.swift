//
//  ViewModel.swift
//  NewsApp
//
//  Created by Adrian Gabriel Chiper on 28.04.2023.
//

import Foundation
import Combine
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class ViewModel: ObservableObject {
    let db = Firestore.firestore()
    
    @Published var news: [NewsModel] = []
    @Published var myNews: [NewsModel] = []
    var cancellable: AnyCancellable?
    
    init() {
        fetchAllNews()
    }
    
    func fetchAllNews() {
        var allnews: [NewsModel] = []
        var mynews: [NewsModel] = []
        
        let url = URL(string: "https://rss.nytimes.com/services/xml/rss/nyt/World.xml")!
        cancellable?.cancel()
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .sink { failure in
                print("FAIL")
            } receiveValue: {[weak self] result in
                print("SUCCESS")
                let parser = XMLParser(data: result.data)
                let delegate = XMLParserC()
                parser.delegate = delegate
                if parser.parse() {
                    print("Parsing succeded")
                    allnews = delegate.news
                    allnews.remove(at: 0)
                    self?.db.collection("news").getDocuments { snapshop, error in
                        guard let documents = snapshop?.documents else {
                            print("Error fetching documents: \(String(describing: error))")
                            return
                        }
                        documents.forEach { document in
                            if let entry = try? document.data(as: NewsModel.self) {
                                mynews.append(entry)
                            }
                        }
                        allnews.removeAll(where: { news in
                            mynews.contains(where: {$0.id == news.id}) })
                        self?.myNews = mynews
                        self?.news = allnews
                    }
                }
            }
    }
    
//    func fetchNews() {
//        let url = URL(string: "https://rss.nytimes.com/services/xml/rss/nyt/World.xml")!
//        cancellable?.cancel()
//        cancellable = URLSession.shared.dataTaskPublisher(for: url)
//            .receive(on: DispatchQueue.main)
//            .sink { failure in
//                print("FAIL")
//            } receiveValue: {[weak self] result in
//                print("SUCCESS")
//                let parser = XMLParser(data: result.data)
//                let delegate = XMLParserC()
//                parser.delegate = delegate
//                if parser.parse() {
//                    print("Parsing succeded")
//                    self?.news = delegate.news
//                    self?.news.remove(at: 0)
//                }
//            }
//    }
    
    func getNewsSortedByDate(ascending:Bool = true) -> [NewsModel] {
        return (self.news + self.myNews).sorted(by: {ascending ? $0.publicationDate < $1.publicationDate : $0.publicationDate > $1.publicationDate})
    }
    
    func getNewsSortedAlphabetically(ascending:Bool = true) -> [NewsModel] {
        return (self.news + self.myNews).sorted(by: {ascending ? $0.title < $1.title : $0.title > $1.title})
    }
    
//    func fetchMyNews() {
//        db.collection("news").getDocuments { snapshop, error in
//            guard let documents = snapshop?.documents else {
//                print("Error fetching documents: \(String(describing: error))")
//                return
//            }
//            documents.forEach { document in
//                if let entry = try? document.data(as: NewsModel.self) {
//                    self.myNews.append(entry)
//                }
//            }
//        }
//    }
//
    func save(news: NewsModel) {
        do {
            try db.collection("news").document(String(news.id)).setData(from: news) { _ in
                print("Successfully created document!")
                self.fetchAllNews()
            }
        }
        catch {
            print("Error creating document:")
        }
    }
    
    func getMyNewsSortedByDate(ascending:Bool = true) -> [NewsModel] {
        return self.myNews.sorted(by: {ascending ? $0.publicationDate < $1.publicationDate : $0.publicationDate > $1.publicationDate})
    }
    
    func getMyNewsSortedAlphabetically(ascending:Bool = true) -> [NewsModel] {
        return self.myNews.sorted(by: {ascending ? $0.title < $1.title : $0.title > $1.title})
    }
    
    func delete(id: String) {
        db.collection("news").document(id).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")

            }
            else {
                self.myNews.removeAll(where: {$0.id == id})
//                self.fetchMyNews()
                self.fetchAllNews()
                print("Document successfully removed!")
            }
        }
    }
}
