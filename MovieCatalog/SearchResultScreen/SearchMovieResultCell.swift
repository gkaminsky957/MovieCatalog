//
//  SearchMovieResultCell.swift
//  MovieCatalog
//
//  Created by Gennady Kaminsky on 4/14/20.
//  Copyright © 2020 Gennady Kaminsky. All rights reserved.
//

import UIKit

class SearchMovieResultCell: UITableViewCell {

    @IBOutlet weak var moviewImageView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setCell(title: String,
                 year: String,
                 image: Data?) {
        self.movieTitle.text = title
        self.year.text = year
        if let image = image {
            let imageView = UIImage(data: image)
            self.moviewImageView.image = imageView
            
            let height = imageView!.size.height
            let width = imageView!.size.width
            
            imageWidthConstraint.constant = width
            imageHeightConstraint.constant = height
        }
    }
}
