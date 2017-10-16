//
//  ViewController.swift
//  PhotoBrowser
//
//  Created by Paul Devlin on 10/12/17.
//  Copyright © 2017 Paul Devlin. All rights reserved.
//

//
//  PhotoCollectionViewController.swift
//  PhotoBrowser
//
//  Created by Paul Devlin on 10/12/17.
//  Copyright © 2017 Paul Devlin. All rights reserved.
//

import UIKit

// main view controller that just displays the collection view of photos
class ViewController: UIViewController {
    
    var photos: [Photo] = []
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    @IBOutlet weak var downloadProgressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.downloadProgressBar.progress = 0.0
        // give ImageService a reference to self
        // so that it can update the downloadProgressBar
        ImageService.shared.mainViewController = self
        photoCollectionView.dataSource = self
        fetchData()
    }
    
    func fetchData() {
        let url = URL(string: "https://api.flickr.com/services/rest/?format=json&sort=random&method=flickr.photos.search&tags=daffodil&tag_mode=all&api_key=0e2b6aaf8a6901c264acb91f151a3350&nojsoncallback=1")!
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, err) in
            // unwrap the json data to the necessary level of
            // specificity
            let data = data!
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            let theDict = json as! [String: Any]
            let aDict = theDict["photos"] as! [String: Any]
            let photoArray = aDict["photo"] as! [[String: Any]]
            self.photos = photoArray.map { Photo(dictionary: $0) }
            DispatchQueue.main.async {
                self.photoCollectionView.reloadData()
            }
        }
        task.resume()
    }
    
    // provide the correct photo to the detailViewController after the
    // user presses a photo in the collection view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue" {
            let detailViewController = segue.destination as! DetailViewController
            let photoCell = sender as! PhotoCell
            detailViewController.photo = photoCell.photo
        }
    }
    
    // called by ImageService when it has downloaded or tried to download
    // a new image
    func updateDownloadProgress(progress: CGFloat) {
        self.downloadProgressBar.progress = Float(progress)
        if progress == 1 {
            self.downloadProgressBar.isHidden = true
        }
    }
}

// provide the photos array to the collection view
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        cell.configure(photo: photos[indexPath.item])
        return cell
    }
}
