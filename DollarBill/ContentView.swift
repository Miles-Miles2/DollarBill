//
//  ContentView.swift
//  DollarBill
//
//  Created by Keiser on 7/7/23.
//


import SwiftUI
import SwiftyJSON
import Alamofire
import AVFoundation



struct ContentView: View {
    let synthesizer = AVSpeechSynthesizer()
    
    @State var animalName = " "
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage? = UIImage(named: "paws")
    
    let labels = ["back_1", "back_10", "back_20", "back_5", "front_1", "front_10", "front_20", "front_5"]
    let user_message = ["back_1":"One Dollar", "back_10":"Ten Dollars", "back_20":"Twenty Dollars", "back_5":"Five Dollars", "front_1":"One Dollar", "front_10":"Ten Dollars", "front_20":"Twenty Dollars", "front_5":"Five Dollars"]
    
    var body: some View {
        ZStack {
            Color.blue
                .opacity(0.6)
                .ignoresSafeArea()
            VStack (alignment: .center,
                    spacing: 20){
                Text("Dollar Bill Identifier")
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.bold)
                Text(animalName)
                Image(uiImage: inputImage!).resizable()
                    .aspectRatio(contentMode: .fill)
                //Text(animalName)
                Button("Press to Upload Image"){
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
    func processImage(){
        self.showingImagePicker = false
        self.animalName="Checking..."
        guard let inputImage = inputImage else {return}
        print("Processing image due to Button press")
        let imageJPG=inputImage.jpegData(compressionQuality: 0.0034)!
        let imageB64 = Data(imageJPG).base64EncodedData()
        let uploadURL="https://askai.aiclub.world/61b8af77-de0c-4f33-958b-9565fea2924b"
        
        AF.upload(imageB64, to: uploadURL).responseJSON { response in
            
            debugPrint(response)
            switch response.result {
            case .success(let responseJsonStr):
                print("\n\n Success value and JSON: \(responseJsonStr)")
                let myJson = JSON(responseJsonStr)
                let predictedValue = myJson["predicted_label"].intValue
                print("Saw predicted value \(String(describing: predictedValue))")
                
                let predictionMessage = labels[predictedValue]
                let message = user_message[predictionMessage] ?? "Unknown"
                self.animalName = message
                say(string: message)
            case .failure(let error):
                print("\n\n Request failed with error: \(error)")
            }
        }
    }
    
    func buttonPressed(){
        print("button pressed")
        self.showingImagePicker = true
        say(string: "Button Pressed")
    }
    
    func say(string: String) {
            
        let utterance = AVSpeechUtterance(string: string)
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            utterance.rate = 0.5

            
            synthesizer.speak(utterance)
        }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
    
}

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        //picker.sourceType = .camera
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

