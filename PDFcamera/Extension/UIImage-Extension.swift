//
//  UIImage-Extension.swift
//  PDFcamera
//
//  Created by 浅野総一郎 on 2022/08/27.
//

import Foundation
import UIKit

extension UIView {
    func getImage(rect: CGRect) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: rect)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
