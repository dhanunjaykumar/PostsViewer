//
//  Protocols.swift
//  PostsViewer
//
//  Created by Dhanunjay Kumar on 25/04/24.
//

import Foundation

// MARK: - Network Manager Protocol
protocol NetworkManagerProtocol {
    func fetchData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}

