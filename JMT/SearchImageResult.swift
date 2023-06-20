//
//  SearchImageResult.swift
//  JMT
//
//  Created by 원찬주 on 2023/06/20.
//

struct SearchImageResult: Decodable {
    let lastBuildDate: String
    let total: Int
    let start: Int
    let display: Int
    let items: [ImageItem]
}

struct ImageItem: Decodable {
    let title: String
    let link: String
    let thumbnail: String
    let sizeheight: String
    let sizewidth: String
}
