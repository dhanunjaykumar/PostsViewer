//
//  PostsViewModel.swift
//  PostsViewer
//
//  Created by Dhanunjay Kumar on 25/04/24.
//

import Foundation

final class PostsViewModel {
    
    private let networkManager: NetworkManagerProtocol
    private var currentPage = 1
    private var isLoading = false
    private var posts: [Post] = []
    
    var onDataUpdate: (() -> Void)?
    var onError: ((Error) -> Void)?
    var onLoadingStatusChange: ((Bool) -> Void)?
    
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func fetchData() {
        guard !isLoading else { return }
        isLoading = true
        onLoadingStatusChange?(true)
        
        let start = (currentPage - 1) * APIConstants.pageSize
        let url = URL(string: "\(APIConstants.baseURL)\(APIConstants.postsEndpoint)?_start=\(start)&_limit=\(APIConstants.pageSize)")!
        
        networkManager.fetchData(from: url) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            self.onLoadingStatusChange?(false)
            
            switch result {
            case .success(let data):
                do {
                    let fetchedPosts = try JSONDecoder().decode([Post].self, from: data)
                    self.posts.append(contentsOf: fetchedPosts)
                    self.onDataUpdate?()
                } catch {
                    self.onError?(error)
                }
            case .failure(let error):
                self.onError?(error)
            }
        }
    }
    
    func fetchData(for indices: Range<Int>) {
        let start = indices.lowerBound
        let end = indices.upperBound
        let url = URL(string: "\(APIConstants.baseURL)\(APIConstants.postsEndpoint)?_start=\(start)&_limit=\(end - start)")!
        
        networkManager.fetchData(from: url) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            self.onLoadingStatusChange?(false)
            
            switch result {
            case .success(let data):
                do {
                    let fetchedPosts = try JSONDecoder().decode([Post].self, from: data)
                    self.posts.append(contentsOf: fetchedPosts)
                    self.onDataUpdate?()
                } catch {
                    self.onError?(error)
                }
            case .failure(let error):
                self.onError?(error)
            }
        }
    }
    
    func loadNextPage() {
        if currentPage >= APIConstants.totalPages {
            return
        }
        guard !isLoading else { return }
        isLoading = true
        onLoadingStatusChange?(true)
        
        let startIndex = posts.count
        let endIndex = startIndex + APIConstants.pageSize
        fetchData(for: startIndex..<endIndex)
        currentPage += 1
    }
    
    func post(at index: Int) -> Post {
        return posts[index]
    }
    
    func numberOfPosts() -> Int {
        return posts.count
    }
    
}
