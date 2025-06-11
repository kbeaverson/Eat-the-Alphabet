//
//  UIImageAverageColor.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/11.
//

import UIKit

extension UIImage {
    var averageColor: UIColor? {
        let size = CGSize(width: 1, height: 1)
        UIGraphicsBeginImageContext(size)

        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        self.draw(in: CGRect(origin: .zero, size: size))

        guard let pixelData = context.data else { return nil }
        let data = pixelData.bindMemory(to: UInt8.self, capacity: 4)

        let r = CGFloat(data[2]) / 255.0
        let g = CGFloat(data[1]) / 255.0
        let b = CGFloat(data[0]) / 255.0
        let a = CGFloat(data[3]) / 255.0

        UIGraphicsEndImageContext()

        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}
