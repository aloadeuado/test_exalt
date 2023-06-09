//
//  ListRecipes.swift
//  test_empowermentlabs
//
//  Created by iMac on 9/02/23.
//

import Foundation

// MARK: - ListRecipes
struct ListRecipes: Codable {
    let results: [Result]?
    let baseURI: String?
    let offset, number, totalResults, processingTimeMS: Int?
    let expires: Int?
    let isStale: Bool?

    enum CodingKeys: String, CodingKey {
        case results
        case baseURI = "baseUri"
        case offset, number, totalResults
        case processingTimeMS = "processingTimeMs"
        case expires, isStale
    }
}

// MARK: - Result
struct Result: Codable {
    let id: Int?
    let title: String?
    let readyInMinutes, servings: Int?
    let sourceURL: String?
    let image: String?

    enum CodingKeys: String, CodingKey {
        case id, title, readyInMinutes, servings
        case sourceURL = "sourceUrl"
        case image
    }
}

