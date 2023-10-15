//
//  Multitab View.swift
//  DollarBill
//
//  Created by Keiser on 9/3/23.
//

import SwiftUI

@available(iOS 16.0, *)
struct Multitab_View: View {
    @State private var tabSelected=1
        var body: some View {
            TabView(selection:$tabSelected) {
                WebView(url:URL(string:"https://sites.google.com/view/dollarbillaboutpage/home")!)
                    .tabItem{
                        Label("About",systemImage: "info.circle")
                    }
                    .tag(1)
                /*
                AskAIView(tabSelect:$tabSelected)
                    .tabItem{
                        Label("Identify Bill",systemImage: "dollarsign.circle")
                    }
                    .tag(2)
                 */
                FileUploadView(tabSelect:$tabSelected)
                    .tabItem{
                        Label("Crowdsource",systemImage: "square.and.arrow.up.circle")
                    }
                    .tag(3)
                ObjectDetectionView()
                    .tabItem{
                        Label("Identify", systemImage: "dollarsign.circle")
                    }
                    .tag(4)
            }
        }
}
