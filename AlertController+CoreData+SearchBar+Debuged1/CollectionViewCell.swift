//
//  CollectionViewCell.swift
//  AlertController
//
//  Created by Egon Fiedler on 7/29/17.
//  Copyright © 2017 App Solutions. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    var taggedPhoto: TagedPhoto?
    var deletePhoto: ((TagedPhoto) -> Void)?
    
    @IBAction func Delete(_ sender: Any) {
        guard let taggedPhoto = taggedPhoto else {
            return
        }
        deletePhoto!(taggedPhoto)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        image.layer.cornerRadius = 5
        image.clipsToBounds = true
        
    }
}
