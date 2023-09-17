//
//  AboutAppView.swift
//  DollarBill
//
//  Created by Keiser on 9/3/23.
//

import SwiftUI

@available(iOS 16.0, *)
struct AboutAppView: View {
    @Binding var tabSelect:Int
    var body: some View {
        ZStack{
            Color(UIColor(red: 0.5, green: 0.7, blue: 0.5, alpha: 1))
                .ignoresSafeArea()
            VStack(){
                
                Text("Dollar Bill Identification App")
                    .fontWeight(Font.Weight.bold)
                    .font(.system(.largeTitle, design: .rounded))
                    .padding(.all, 20)
                    .multilineTextAlignment(.center)
                Text("About")
                    .padding(.horizontal, 10)
                    .fontWeight(.bold)
                    .font(.system(.title))
                /*
                Text("This app can identify dollar bills and their denominations. For example, if you have a bill of an unknown value, you can scan it and determine how much money it is worth in the 'Identify Bill' tab. You can also upload your own pictures so that we can improve the accuracy of the AI in the 'Upload Image' tab.")
                    .font(.title2)
                    .padding(.horizontal, 10)
                 */
                Text("In order to upload your own images to the training dataset, please navigate to the 3rd tab (\"Upload Image\"). Then click the green Upload Image button and select the image you want. It will be automatically uploaded to our database. If possible, please take picutres in varied position and locations.")
                Text("Created by")
                    .padding(.top, 10)
                    .font(.system(.title))
                    .fontWeight(.bold)
                Text("Miles Keiser")
                    .font(.title2)
                Spacer()
            }
        }
    }
}

