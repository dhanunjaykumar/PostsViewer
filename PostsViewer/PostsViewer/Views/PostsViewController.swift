//
//  ViewController.swift
//  PostsViewer
//
//  Created by Dhanunjay Kumar on 25/04/24.
//

import UIKit

class PostsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    private var viewModel: PostsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                
        configure()
    }
    private func configure() {
        configureTableView()
        configureViewModel()
    }
    private func configureTableView() {
        
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "PostCell")
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func configureViewModel() {
        
        viewModel = PostsViewModel()
        viewModel.onDataUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.reloadTableView()
            }
        }
        viewModel.onError = { [weak self] error in
            DispatchQueue.main.async {
                self?.showErrorAlert(message: error.localizedDescription)
            }
        }
        viewModel.onLoadingStatusChange = { [weak self] isLoading in
            DispatchQueue.main.async {
                self?.showLoader(isLoading)
            }
        }
        viewModel.fetchData()
    }
    private func reloadTableView() {
        self.tableView.reloadData()
//        self.tableView.scrollToRow(at: IndexPath(row: viewModel.numberOfPosts() - 18, section: 0), at: .middle, animated: true)
    }
    private func showLoader(_ shouldShow: Bool) {
        
        if (shouldShow) {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
        } else {
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        }

    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}


// MARK: - Table View Data Source
extension PostsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfPosts()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: PostTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        let post = viewModel.post(at: indexPath.row)
        cell.configureCell(post: post)
        cell.layoutIfNeeded()

        if indexPath.row == viewModel.numberOfPosts() - 1 {
            viewModel.loadNextPage() // Load next page of data
        }
        
        return cell
    }
}

// MARK: - Table View Delegate
extension PostsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = viewModel.post(at: indexPath.row)
        showPostDetails(post: post)
    }
}

extension PostsViewController {
    
    func showPostDetails(post: Post) {
        
        let startTime = CFAbsoluteTimeGetCurrent()
        
        // Fetch post details and update UI
        let detailViewController: PostDetailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PostDetailsViewController") as! PostDetailsViewController
        detailViewController.post = post
        navigationController?.pushViewController(detailViewController, animated: true)
        
        let endTime = CFAbsoluteTimeGetCurrent()
        let timeElapsed = endTime - startTime
        
        print("Time taken to show post details: \(timeElapsed) seconds")
    }
    
}
// MARK: - Table View PreFetch API Call
extension PostsViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let lastIndexPath = indexPaths.last else { return }
        
        let nextIndex = lastIndexPath.row + 1
        if nextIndex >= viewModel.numberOfPosts() {
            viewModel.loadNextPage()
        }
    }
}
