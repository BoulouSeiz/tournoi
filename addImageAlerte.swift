//
//  addImageAlerte.swift
//  TournoiATP
//
//  Created by François LIEURY on 15/03/2018.
//  Copyright © 2018 François LIEURY. All rights reserved.
//

import UIKit

extension UIAlertController {
  func addImage(image: UIImage) {
    
    let maxSize = CGSize(width: 245, height: 300)
    let imageSize = image.size
    
    var ratio: CGFloat!
    if (imageSize.width > imageSize.height) {
      ratio = maxSize.width / imageSize.width
    } else {
      ratio = maxSize.height / imageSize.height
    }
    
    let scaledSize = CGSize(width: imageSize.width * ratio, height: imageSize.height * ratio)
    
    var resizedImage = image.imageWithSize(scaledSize)
    
    if (imageSize.height > imageSize.width) {
      let left = (maxSize.width - resizedImage.size.width) / 2
      resizedImage = resizedImage.withAlignmentRectInsets(UIEdgeInsetsMake(0, -left , 0, 0))
    }
    
    let imageAction = UIAlertAction(title: "", style: .default, handler: nil)
    imageAction.isEnabled = false
    imageAction.setValue(resizedImage.withRenderingMode(.alwaysOriginal), forKey: "image")
    self.addAction(imageAction)
  }
  
}
