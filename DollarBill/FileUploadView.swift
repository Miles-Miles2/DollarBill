//
//  FileUploadView.swift
//  DollarBill
//
//  Created by Keiser on 9/3/23.
//

import SwiftUI
import FilestackSDK

struct FileUploadView: View {
    @Binding var tabSelect:Int
    @State var animalName = " "
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage? = UIImage(named: "1024")
    let instructions = "Click the green button below, then select an image by clicking it. It will automatically be uploaded."
    
    var body: some View {
        ZStack(){
            Color(UIColor(red: 0.5, green: 0.7, blue: 0.5, alpha: 1))
                .ignoresSafeArea()
            HStack {
                VStack (alignment: .center,
                        spacing: 20){
                    Text("Upload Image")
                        .font(.system(.largeTitle, design: .rounded))
                        .fontWeight(.bold)
                    Text(instructions)
                        .padding(.horizontal, 10)
                    if let l=inputImage {
                        Image(uiImage: l).resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    
                    Button("Click to Upload Image"){
                        self.buttonPressed()
                    }
                    .padding(.all, 14.0)
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(10)
                }
                        .font(.title)
            }.sheet(isPresented: $showingImagePicker, onDismiss: processImage) {
                ImagePicker(image: self.$inputImage)
            }
        }
    }
    
    func buttonPressed() {
        print("Button pressed")
        self.showingImagePicker = true
    }
    
    func processImage() {
        self.showingImagePicker = false
        self.animalName="Checking..."
        guard let inputImage = inputImage else {return}
        print("Processing image due to Button press")
        let imageJPG=inputImage.jpegData(compressionQuality: 0.0034)!
        let client=Client(apiKey: "AMdhw8YQJGWYKBOJfVQfCz")
        let uploadOptions = UploadOptions.defaults
        
        let imageB64 = Data(imageJPG).base64EncodedData()
        let uploader=client.upload(using: imageJPG, options:uploadOptions,uploadProgress: { progress in
            // Here you may update the UI to reflect the upload progress.
            print("Progress: \(progress)")
        }) { response in
            // Try to obtain Filestack handle
            if let json = response.json, let handle = json["handle"] as? String {
                let url="https://cdn.filestackcontent.com/\(handle)"
                print("Handle is \(handle), and URL is \(url)")
                self.animalName=url
            } else if let error = response.error {
                print("Error is \(error)")
            }
        }
        
    }
}
