//
//  ActivityModel.swift
//  PDFcamera
//
//  Created by 浅野総一郎 on 2022/08/27.
//

import SwiftUI

struct ActivityModel: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]?
    
    func makeUIViewController(
        context: UIViewControllerRepresentableContext<ActivityModel>
    ) -> UIActivityViewController {
        return UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities
        )
    }
    
    func updateUIViewController(
        _ uiViewController: UIActivityViewController,
        context: UIViewControllerRepresentableContext<ActivityModel>
    ) {
        // Nothing to do
    }
}
