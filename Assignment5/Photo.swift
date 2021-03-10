//
//  Photo.swift
//  Assignment5
//
//  Created by ThanhTy  on 26/11/20.
//  Copyright © 2020 thanhty. All rights reserved.
//

import Foundation

class Photo {
    
    let id: Int
    let remoteURL: String
    let title: String
    let description: String
    
    init(id: Int, remoteURL: String, title: String, description: String) {
        self.id = id
        self.remoteURL = remoteURL
        self.title = title
        self.description = description
    }
}
