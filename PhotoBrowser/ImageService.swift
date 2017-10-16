//
//  ImageService.swift
//  PhotoBrowser
//
//  Created by Paul Devlin on 10/12/17.
//  Copyright © 2017 Paul Devlin. All rights reserved.
//

import UIKit

class ImageService {
    
    let imageCache = URLCache()
    var numCached: CGFloat = 0.0
    var mainViewController = ViewController()
    static var shared = ImageService()
    //var cache:[URL:UIImage] = [:] /// CHANGE FROM DICT TO CACHE
    func imageForURL(url: URL?, completion: @escaping (UIImage?, URL?) -> ()) {
        self.numCached = self.numCached + 1
        let progress = self.numCached / CGFloat(self.mainViewController.photos.count)
        //self.mainViewController.downloadProgressBar.progress = Float(progress)
        self.mainViewController.updateDownloadProgress(progress: progress)
        guard let url = url else { completion(nil, nil); return }
        //if let image = cache[url] {
        
        if let aCachedResponse = imageCache.cachedResponse(for: URLRequest(url: url)) {
            let image = UIImage(data: aCachedResponse.data)
            completion(image, url)
            return
        }
        let task = URLSession(configuration: .ephemeral).dataTask(with: url) { (data, response, error) in
            guard data != nil else { completion(nil, nil); return }
            guard error != nil else { completion(nil, nil); return }
            let image = UIImage(data: data!)
            let cacheResponse = CachedURLResponse(response: response!, data: data!)
            self.imageCache.storeCachedResponse(cacheResponse, for: URLRequest(url: url))
            //if let img = image {
                //self.cache[url] = img
            //}
            DispatchQueue.main.async {
                completion(image, url)
            }
        }
        
        task.resume()
    }
    
}

