//
//  PhotosViewController.swift
//  Assignment5
//
//  Created by ThanhTy  on 26/11/20.
//  Copyright © 2020 thanhty. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    
    var store : PhotoStore!
    var photos = [Photo]()
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
    }
    
    @IBAction func getAllPhotos(_ sender: Any) {
        store.getAllPhotos {(photosResult)->Void in
            switch photosResult {
                case let .success(photos):
                    self.photos = photos
                    self.myCollectionView.reloadData()
                case let .failure(error):
                    print("Error fetching books \(error)")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch(segue.identifier){
        case "singlePhoto"?:
            if let selectedIndexPath = myCollectionView.indexPathsForSelectedItems?.first {
                let photo = photos[selectedIndexPath.row]
                let destinationVC = segue.destination as! PhotoInfoViewController
                destinationVC.photo = photo
                destinationVC.store = store
            }
        default:
            preconditionFailure("Unexpected segue ID")
        }
    }
}

extension PhotosViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "PhotoCollectionViewCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! PhotoCollectionViewCell
        return cell
    }
}

extension PhotosViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let photoIndex = indexPath.row
        let photo = photos[photoIndex]
        store.fetchImage(for: photo) { (result)->Void in
            guard let photoIndex = self.photos.firstIndex(where: {$0.id == photo.id}),
                case let .success(image) = result
                else {
                    return
            }
        
            let photoIndexPath = IndexPath(item: photoIndex, section: 0)
            if let cell = self.myCollectionView.cellForItem(at: photoIndexPath) as? PhotoCollectionViewCell {
                cell.update(with: image)
            }

        }
    }
}
