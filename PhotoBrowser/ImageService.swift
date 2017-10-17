//
//  ImageService.swift
//  PhotoBrowser
//
//  Created by Paul Devlin on 10/12/17.
//  Copyright © 2017 Paul Devlin. All rights reserved.
//

import UIKit
// download and cache images
class ImageService {
    
    let imageCache = URLCache()
    
    // keeps track of the number of things cached, whether or not an image
    // was found at the desired URL
    var numCached: CGFloat = 0.0
    
    // used to update the downloadProgressBar in ViewController
    var mainViewController = ViewController()
    
    // avoid making new instance of ImageService for every image request
    static var shared = ImageService()
    
    // return the image downloaded fromt he given url or from the cache if the image
    // is cached
    func imageForURL(url: URL?, completion: @escaping (UIImage?, URL?) -> ()) {
        
        // calculate new download progress and send it to mainViewController
        self.numCached = self.numCached + 1
        let progress = self.numCached / CGFloat(self.mainViewController.photos.count)
        self.mainViewController.updateDownloadProgress(progress: progress)
        
        guard let url = url else { completion(nil, nil); return }
        
        // check if the response to the url is already cached and return it if it is
        if let aCachedResponse = imageCache.cachedResponse(for: URLRequest(url: url)) {
            let image = UIImage(data: aCachedResponse.data)
            completion(image, url)
            return
        }
        let task = URLSession(configuration: .ephemeral).dataTask(with: url) { (data, response, error) in
            guard data != nil else { completion(nil, nil); return }
            if error != nil { completion(nil, nil); return }
            let image = UIImage(data: data!)
            
            // cache the data whether or not it contains an image
            let cacheResponse = CachedURLResponse(response: response!, data: data!)
            self.imageCache.storeCachedResponse(cacheResponse, for: URLRequest(url: url))
            
            DispatchQueue.main.async {
                completion(image, url)
            }
        }
        task.resume()
    }
    
}

