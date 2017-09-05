//
//  TagedPhotoEXT.swift
//  AlertController
//
//  Created by Egon Fiedler on 8/3/17.
//  Copyright © 2017 App Solutions. All rights reserved.
//

import Foundation

extension TagedPhoto {
    var tags: [String] {
        get {
            return tagsArray as? Array<String> ?? []
        }
        set {
            tagsArray = newValue as NSArray
        }
    }
}
