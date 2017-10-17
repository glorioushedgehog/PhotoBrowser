//
//  PhotoCell.swift
//  PhotoBrowser
//
//  Created by Paul Devlin on 10/12/17.
//  Copyright © 2017 Paul Devlin. All rights reserved.
//

import UIKit

// a cell in the collection view
class PhotoCell: UICollectionViewCell {
    
    var photo: Photo?
    
    // tells the user the photo title while the photo hasn't been loaded
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var photoView: UIImageView!
    
    // tells the user the photo is being loaded
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    // get ready to load image into cell
    override func prepareForReuse() {
        super.prepareForReuse()
        self.photoView.image = nil
        // tell user the title of the image about to appear
        self.titleLabel.isHidden = false
        // tell user the image will appear
        self.loadingIndicator.isHidden = false
    }
    
    // retrieve the photo from ImageService
    func configure(photo: Photo) {
        self.photo = photo
        titleLabel.text = photo.title
        ImageService.shared.imageForURL(url: photo.imageURL) { (image, url) in
            if url == self.photo?.imageURL {
                // the photo has been loaded, so get rid of title and loading indicator
                self.titleLabel.isHidden = true
                self.loadingIndicator.isHidden = true
                self.photoView.image = image
            }
        }
    }
    
}
