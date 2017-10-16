//
//  Photo.swift
//  PhotoBrowser
//
//  Created by Paul Devlin on 10/12/17.
//  Copyright © 2017 Paul Devlin. All rights reserved.
//

// needed UIKit because need UIImage
import UIKit

// store title along with url
struct Photo {
    let title: String
    let imageURL: URL?
    init(title: String, imageURL: URL?) {
        self.title = title
        self.imageURL = imageURL
    }
    
    // build url out of the dictionary from the json file
    init(dictionary: [String: Any]) {
        let title = dictionary["title"] as? String
        let farm = dictionary["farm"] as! Int
        let server = dictionary["server"] as! String
        let id = dictionary["id"] as! String
        let secret = dictionary["secret"] as! String
        let imageURL = URL(string: "https://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret).jpg")
        self.init(title: title ?? "", imageURL: imageURL)
    }
}
