//
//  ContentView.swift
//  PDFcamera
//
//  Created by 浅野総一郎 on 2022/08/27.
//

import SwiftUI


struct ContentView: View {
    @ObservedObject private var scannerModel = ScannerModel()
    
    @State private var name = ""
    @State private var date = Date()
    @State private var rect: CGRect = .zero
    @State private var uiImage: UIImage? = nil
    @State private var showActivityView = false
    @State var select_date = ""
    @State var url = URL(string: "")
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(scannerModel.imageArray, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .background(RectangleGetter(rect: $rect))
                    }
                }
                HStack {
                    TextField("PDFタイトル",text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    DatePicker("", selection: $date, displayedComponents: .date)
                        .environment(\.locale, Locale(identifier: "ja_JP"))
                        .padding()
                }
                //機能ボタンここから
                HStack {
                    MenuButtonView(action: { tappedCameraButton() },imagename: "camera", title: "撮影")
                    MenuButtonView(action: { tappedShareButton() },imagename: "square.and.arrow.up", title: "共有")
                    MenuButtonView(action: { tappedTrashButton() },imagename: "trash", title: "削除")
                }
            }
            .navigationTitle("\(name)\(select_date).pdf")
        }
        .onAppear {
            let calendar = Calendar(identifier: .gregorian)
            let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
            select_date = "\(dateComponents.year!)-\(dateComponents.month!)-\(dateComponents.day!)"
            url = fileSave(fileName: "\(name)\(select_date).pdf")
        }
        .sheet(isPresented: self.$showActivityView) {
            if let url = url {
                ActivityModel(activityItems: [url], applicationActivities: nil)
            }
        }
    }
    
    private func tappedCameraButton() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let window = windowScene?.windows
        window?.filter({$0.isKeyWindow}).first?.rootViewController?.present(scannerModel.getDocumentCameraViewController(), animated: true)
    }
    
    private func tappedShareButton() {
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        let window = windowScenes?.windows.first
        self.showActivityView.toggle()
        self.uiImage = window?.getImage(rect: self.rect)
        createPdfFromView(hosting: UIImageView(image: uiImage), saveToDocumentsWithFileName: "\(name)\(select_date)")
    }
    
    private func tappedTrashButton() {
        scannerModel.imageArray.removeAll()
        name.removeAll()
        date = Date()
    }
    
    private func fileSave(fileName: String) -> URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = dir.appendingPathComponent(fileName, isDirectory: false)
        return filePath
    }
    
    private func createPdfFromView(hosting: UIImageView, saveToDocumentsWithFileName fileName: String) {
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, hosting.bounds, nil)
        guard let pdfContext = UIGraphicsGetCurrentContext() else { return }
        UIGraphicsBeginPDFPage()
        hosting.layer.render(in: pdfContext)
        UIGraphicsEndPDFContext()
        if let documentDirectories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            let documentsFileName = documentDirectories + "/" + fileName + ".pdf"
            pdfData.write(toFile: documentsFileName, atomically: true)
        }
    }
}

struct MenuButtonView: View {
    let action:() -> Void
    let imagename: String
    let title: String
    
    var body: some View {
        Button(action: {
            action()
        }){
        VStack {
            Image(systemName: imagename)
                .foregroundColor(Color.black)
            Text(title)
                .font(.caption)
                .foregroundColor(Color.black)
        }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
