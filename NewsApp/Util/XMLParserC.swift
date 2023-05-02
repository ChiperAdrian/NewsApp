//
//  XMLParserC.swift
//  NewsApp
//
//  Created by Adrian Gabriel Chiper on 28.04.2023.
//

import Foundation
import CryptoKit

class XMLParserC: NSObject, XMLParserDelegate {
    var currentElement = ""
    var currentValue = ""
    var currentNews: NewsModel?
    var news: [NewsModel] = []
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if elementName == "item" {
            currentNews = NewsModel()
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentValue += string
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if let news = currentNews {
            switch elementName {
            case "title":
                news.title = currentValue.trimmingCharacters(in: .whitespacesAndNewlines)
            case "link":
                news.link = currentValue.trimmingCharacters(in: .whitespacesAndNewlines)
            case "description":
                news.description = currentValue.trimmingCharacters(in: .whitespacesAndNewlines)
            case "pubDate":
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
                news.publicationDate =  dateFormatter.date(from: currentValue.trimmingCharacters(in: .whitespacesAndNewlines))!
            case "item":
                let data = Data((news.title+news.description).utf8)
                let hash = SHA256.hash(data: data)
                news.id = hash.description.replacingOccurrences(of: "SHA256 digest: ", with: "")
                self.news.append(news)
            default:
                break
            }
            
            currentElement = ""
            currentValue = ""
        }
    }
    
}
