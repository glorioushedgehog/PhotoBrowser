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
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var photoView: UIImageView!
    
    // remove the photo if the user scrolls past the cell
    override func prepareForReuse() {
        super.prepareForReuse()
        photoView.image = nil
    }
    
    // retrieve the photo from ImageService
    func configure(photo: Photo) {
        self.photo = photo
        titleLabel.text = photo.title
        ImageService.shared.imageForURL(url: photo.imageURL) { (image, url) in
            if url == self.photo?.imageURL {
                self.photoView.image = image
            }
        }
    }
    
}
