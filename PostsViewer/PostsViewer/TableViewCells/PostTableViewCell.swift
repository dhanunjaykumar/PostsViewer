//
//  PostTableViewCell.swift
//  PostsViewer
//
//  Created by Dhanunjay Kumar on 25/04/24.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(post: Post) {
        self.idLabel.text = String(post.id)
        self.titleLabel.text = post.title
        
    }
}
