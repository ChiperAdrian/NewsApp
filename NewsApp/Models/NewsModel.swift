//
//  NewsModel.swift
//  NewsApp
//
//  Created by Adrian Gabriel Chiper on 28.04.2023.
//

import Foundation

class NewsModel: Identifiable, Codable {
    var id = ""
    var title: String = ""
    var link: String = ""
    var description: String = ""
    var publicationDate: Date = Date.now
}
