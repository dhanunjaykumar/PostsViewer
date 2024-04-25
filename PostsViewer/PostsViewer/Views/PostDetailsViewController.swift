//
//  PostDetailsViewController.swift
//  PostsViewer
//
//  Created by Dhanunjay Kumar on 25/04/24.
//

import UIKit

class PostDetailsViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!

    var post: Post?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let post = post {
            titleLabel.text = "Title:\n\n \(post.title)"
            bodyLabel.text = "Body:\n\n \(post.body)"
        }

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
