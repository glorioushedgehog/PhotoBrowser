//
//  PhotoCell.swift
//  PhotoBrowser
//
//  Created by Paul Devlin on 10/12/17.
//  Copyright © 2017 Paul Devlin. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    var photo: Photo?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var photoView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoView.image = nil
    }
    
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
