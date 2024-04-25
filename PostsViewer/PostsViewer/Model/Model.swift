//
//  Models.swift
//  PostsViewer
//
//  Created by Dhanunjay Kumar on 25/04/24.
//

import Foundation

// MARK: - Post Model
struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
