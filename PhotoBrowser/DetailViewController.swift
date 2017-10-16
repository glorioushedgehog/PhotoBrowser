//
//  DetailViewController.swift
//  PhotoBrowser
//
//  Created by Paul Devlin on 10/14/17.
//  Copyright © 2017 Paul Devlin. All rights reserved.
//

import UIKit

// a detail view the user sees after pressing
// an image in the collection view
class DetailViewController: UIViewController {
    
    var photo: Photo?
    
    @IBOutlet weak var photoView: UIImageView!
    
    @IBOutlet weak var titleView: UILabel!
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // load the image from ImageService
    override func viewDidLoad() {
        super.viewDidLoad()
        titleView.text = self.photo?.title
        ImageService.shared.imageForURL(url: self.photo?.imageURL) { (image, url) in
            DispatchQueue.main.async {
                self.photoView.image = image
            }
        }
    }

}
