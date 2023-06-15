//
//  Store.swift
//  JMT
//
//  Created by 원찬주 on 2023/06/14.
//

struct SearchResult: Decodable {
    let lastBuildDate: String
    let total: Int
    let start: Int
    let display: Int
    let items: [Item]
}

struct Item: Decodable {
    let title: String?
    let link: String?
    let category: String?
    let description: String?
    let telephone: String?
    let address: String?
    let roadAddress: String?
    let mapx: String?
    let mapy: String?
}
