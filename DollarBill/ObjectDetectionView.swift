//
//  ObjectDetectionView.swift
//  DollarBill
//
//  Created by Keiser on 9/17/23.
//

import SwiftUI
import CoreML
import Vision
import UIKit

import Alamofire
import SwiftyJSON
import AVFoundation

//test


struct ObjectDetectionView: View {
    
    
    @State private var resultText=""
    @State private var showingImagePicker=false
    @State private var inputImage: UIImage? = UIImage(named:"1024.png")
    
    @State var detectedObjects: [String] = []
    
    let audioPlayer = sayResult()
    
    //let synthesizer = AVSpeechSynthesizer()
    //let speaker = Speaker()
    
    //@State private var image: UIImage?
    //@State private var boxes: [ShapeView] = []
    
    var body: some View {
        HStack {
            VStack (alignment: .center,
                    spacing: 20){
                Text("Dollar Bill Detector")
                    .font(.system(size:42))
                    .fontWeight(.bold)
                    .padding(10)
                /*
                if !detectedObjects.isEmpty {
                              Text("Detected Objects: \(detectedObjects.joined(separator: ", "))")
                          }
                 */
                //Text(resultText)
                Image(uiImage: inputImage!).resizable()
                    .aspectRatio(contentMode: .fit)
                Button("Identify Bill"){
                    self.buttonPressed()
                }
                .padding(.all, 14.0)
                .foregroundColor(.white)
                .background(Color.green)
                .cornerRadius(10)
                //Text(DataStore.label)
            }
                    .font(.title)
        }.sheet(isPresented: $showingImagePicker, onDismiss: detectObjects) {
            ImagePicker(image: self.$inputImage)
        }
    }
    
    func buttonPressed() {
        print("Button pressed")
        self.showingImagePicker = true
    }
    
    func detectObjects() {
        guard let inputImage=inputImage else {
            print("No image selected")
            return
        }
        //let model1 = try! DollarBillObjDetectionV2Iter6000()
        let model1 = DollarBillObjectDetection_220()
        guard let model = try? VNCoreMLModel(for: model1.model) else {
                fatalError("Failed to load Core ML model.")
            }
            let request = VNCoreMLRequest(model: model) { request, error in
                guard let results = request.results as? [VNRecognizedObjectObservation], !results.isEmpty else {
                    print("No object detected")
                    //speaker.speak(msg: "No bill detected")
                    return
                }
                // Draw bounding boxes around the detected objects
                let imageSize = inputImage.size
                let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -imageSize.height)
                let scale = CGAffineTransform.identity.scaledBy(x: imageSize.width, y: imageSize.height)
                let objectBoundsAndLabels = results.map { observation -> (CGRect, String) in
                         let observationBounds = observation.boundingBox
                         let objectBounds = observationBounds.applying(scale).applying(transform)
                         let label = observation.labels[0].identifier
                    //say(string: label)
                    //speaker.speak(msg: label)
                    audioPlayer.playResult(billClass: label)
                        print(observation.labels[0].identifier)
                    
                        return (objectBounds, label)
                     }
                
                DispatchQueue.main.async {
                    self.inputImage = inputImage
                    
                    self.detectedObjects = results.map { observation in
                        return observation.labels[0].identifier
                    }
                    self.drawBoundingBoxes(on: &self.inputImage, with: objectBoundsAndLabels)
                    
                }
            }
            let handler = VNImageRequestHandler(cgImage: inputImage.cgImage!)
            do {
                try handler.perform([request])
            } catch {
                print("Failed to perform detection: \(error.localizedDescription)")
            }
        }
    
    
    func drawBoundingBoxes(on image: inout UIImage?, with objectBoundsAndLabels: [(CGRect, String)]) {
        UIGraphicsBeginImageContextWithOptions(image!.size, false, 0.0)
        image?.draw(in: CGRect(origin: CGPoint.zero, size: image!.size))
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(4.0)
        for (objectBounds, label) in objectBoundsAndLabels {
            context?.setStrokeColor(UIColor.red.cgColor)
            context?.addRect(objectBounds)
            context?.drawPath(using: .stroke)
            
            context?.setFillColor(UIColor.red.cgColor)
            print("Object bounds are \(objectBounds) for label \(label) and label is \(label).")
            
            let labelRect = CGRect(x: objectBounds.origin.x, y: max(objectBounds.origin.y - 55,0), width: objectBounds.width, height: 55)
            context?.fill(labelRect)
            
            context?.setFillColor(UIColor.black.cgColor)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            let labelFontAttributes = [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 24),
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.foregroundColor: UIColor.black,
            ]
            let attributedLabel = NSAttributedString(string: label, attributes: labelFontAttributes)
            attributedLabel.draw(in: labelRect)
        }
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    /*
    func say(string: String) {
        let utterance = AVSpeechUtterance(string: string)
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            utterance.rate = 0.5

            synthesizer.speak(utterance)
        }
    */
    
    
}


struct ObjectDetectionView_Previews: PreviewProvider {
    static var previews: some View {
        ObjectDetectionView()
    }
}
