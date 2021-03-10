//
//  PhotoinfoViewController.swift
//  Assignment5
//
//  Created by ThanhTy  on 26/11/20.
//  Copyright © 2020 thanhty. All rights reserved.
//

import UIKit

class PhotoInfoViewController: UIViewController {
    
    @IBOutlet weak var imageTitle: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var imageDescription: UILabel!
    
    var store: PhotoStore!
    var photo: Photo!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageTitle.text = photo.title
        imageDescription.text = photo.description
        store.fetchImage(for: photo) { (result)->Void in
            switch(result) {
            case let .success(image):
                self.image.image = image
            case let .failure(error):
                print("Error fetching image for photo: \(error)")
            }
        }
    }
    
    
    
    


}
