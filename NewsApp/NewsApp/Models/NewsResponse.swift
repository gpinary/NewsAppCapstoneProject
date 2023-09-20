//
//  NewsResponse.swift
//  NewsApp
//
//  Created by Gökçe Pınar Yıldız on 9.09.2023.
//

import Foundation

struct NewsResponse:Decodable{
    let status: String?
    let totalResults: Int?
    let articles: [Article]?
}

struct Article:Decodable{
    let author,title,description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}

struct Source:Decodable {
    let id: String?
    let name: String?
}
