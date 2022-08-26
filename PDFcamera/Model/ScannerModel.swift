//
//  ScannerModel.swift
//  PDFcamera
//
//  Created by 浅野総一郎 on 2022/08/27.
//

import Foundation
import VisionKit

final class ScannerModel: NSObject, ObservableObject {
    @Published var imageArray: [UIImage] = []
    
    func getDocumentCameraViewController() -> VNDocumentCameraViewController {
        let vc = VNDocumentCameraViewController()
        vc.delegate = self
        return vc
    }
}

extension ScannerModel: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true)
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        for i in 0..<scan.pageCount {
            self.imageArray.append(scan.imageOfPage(at: i))
        }
        controller.dismiss(animated: true)
    }
}
