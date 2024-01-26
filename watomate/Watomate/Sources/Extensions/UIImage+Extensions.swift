//
//  UIImage+Extensions.swift
//  Watomate
//
//  Created by 이지현 on 1/27/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

extension UIImage{
    func resizeImage(newWidth: CGFloat) -> UIImage {
        let image = self
        let scale = newWidth / image.size.width // 새 이미지 확대/축소 비율
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.draw(in: CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}
