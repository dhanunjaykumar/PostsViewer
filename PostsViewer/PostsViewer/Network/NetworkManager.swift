//
//  NetworkManager.swift
//  PostsViewer
//
//  Created by Dhanunjay Kumar on 25/04/24.
//

import Foundation


// MARK: - Network Manager
final class NetworkManager: NetworkManagerProtocol {
    
    static let shared = NetworkManager()
    
    private init() {
        
    }
    
    func fetchData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                completion(.success(data))
            }
        }.resume()
    }
    
}
