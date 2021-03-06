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
    @IBOutlet weak var movieTitleValue: UILabel!
    @IBOutlet weak var yearValue: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var yearTitle: UILabel!
    
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        movieTitle.text = "MovieListScreen.movieTitle".localized
        yearTitle.text = "MovieListScreen.movieYear".localized
    }
    
    func setCell(title: String,
                 year: String,
                 image: Data?) {
        self.movieTitleValue.text = title
        self.yearValue.text = year
        if let image = image {
            let imageView = UIImage(data: image)
            self.moviewImageView.image = imageView
            
            // the image that we are getting is too big to display on the phone.
            // It seems to be designed for a web app on desktop. So, we need
            // to resize it preserving image aspect ratio.
            self.resizeImage()
        }
    }
    
    private func resizeImage() {
        let imageView = self.moviewImageView.image
        let ratio = imageView!.size.width/imageView!.size.height
        imageWidthConstraint.constant = self.moviewImageView.frame.size.height * ratio
    }
    
    override func prepareForReuse() {
        // need to reset image to nill. So, when the cell is being re-used
        // the image from older cell is not shown in the current cell that does not
        // have an image.
        self.moviewImageView.image = nil
    }
}
