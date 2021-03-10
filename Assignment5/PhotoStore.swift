//
//  PhotoStore.swift
//  Assignment5
//
//  Created by ThanhTy  on 26/11/20.
//  Copyright © 2020 thanhty. All rights reserved.
//

import UIKit

enum PhotosResult {
    case success([Photo])
    case failure(Error)
}

enum ImageResult {
    case success(UIImage)
    case failure(Error)
}

enum PhotoError : Error {
    case photoCreationError
}

enum JSONError : Error {
    case invalidJSONData
}

class PhotoStore {
    var result : PhotosResult!
    
    let session :  URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func getAllPhotos(completion: @escaping(PhotosResult)->Void){
        let components = URLComponents(string: "http://localhost:3000/root")
        let url = components!.url
        let request = URLRequest(url: url!)
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            if let jsonData = data {
                self.result = self.photosCall(fromJSON: jsonData)
            } else if let requestError = error {
                print("Error fetching interesting photos: \(requestError)")
            } else {
                print("Unexpected error with the request")
            }
            OperationQueue.main.addOperation {
                completion(self.result)
            }
        }
        task.resume()
        
    }
    
    func photosCall(fromJSON data: Data) -> PhotosResult {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            guard
                let jsonDictionary = jsonObject as? [AnyHashable:Any],
                let photosArray = jsonDictionary["photos"] as? [[String:Any]]
                else {
                    return .failure(JSONError.invalidJSONData)
            }
            var finalPhotos = [Photo]()
            for photoJSON in photosArray {
                if let photo = photo(fromJSON: photoJSON) {
                    finalPhotos.append(photo)
                }
            }
            if finalPhotos.isEmpty && !photosArray.isEmpty {
                return .failure(JSONError.invalidJSONData)
            }
            return .success(finalPhotos)
            
        } catch let error {
            return .failure(error)
        }
    }
    
    func photo(fromJSON json: [String:Any])->Photo? {
        guard
            let id = json["id"] as! Int?,
            let title = json["title"] as! String?,
            let remoteURL = json["url"] as! String?,
            let description = json["description"] as! String?
        else {
            return nil
        }
        return Photo(id: id, remoteURL: remoteURL, title: title, description: description)
    }
    
    func fetchImage(for photo: Photo, completion: @escaping (ImageResult)->Void){
        let photoURL = photo.remoteURL
        let request = URLRequest(url: URL(string: photoURL)!)
        let task = session.dataTask(with: request){
            (data, response, error)->Void in
            let result = self.processImageResult(data: data, error: error)
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        task.resume()
    }
    
    func processImageResult(data: Data?, error: Error?)->ImageResult {
        guard
            let imageData = data,
            let image = UIImage(data: imageData)
        else {
            if (data == nil) {
                return .failure(error!)
            } else {
                return .failure(PhotoError.photoCreationError)
            }
        }
        return .success(image)
    }
}

