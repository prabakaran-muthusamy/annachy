//
//  ProductModel.swift
//  Annachy
//
//  Created by Prabakaran Muthusamy on 12/02/25.
//

import Foundation

struct ProductModel: Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
    let rating: Rating
}

struct Rating: Codable {
    let rate: Double
    let count: Int
}
