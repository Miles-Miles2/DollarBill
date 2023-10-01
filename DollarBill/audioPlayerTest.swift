//
//  PlayAudioView.swift
//  DollarBill
//
//  Created by Amit Gupta on 10/1/23.
//

import SwiftUI

import SwiftUI
import AVFoundation

/*
struct PlayAudioView: View {
    var player: AVAudioPlayer?
    
    init() {
        if let url = Bundle.main.url(forResource: "FiveDollarsM4A", withExtension: "m4a") {
            player = try? AVAudioPlayer(contentsOf: url)
        }
    }
    
    var body: some View {
        Button("Play Audio") {
            player?.play()
        }
    }
}
*/

class sayResult {
    var player: AVAudioPlayer?
    init(){
        
    }
    
    func playResult(billClass: String){
        print("play result: \(billClass)")
        switch billClass{
        case "100Dollars":
            if let url = Bundle.main.url(forResource: "100Dollars", withExtension: "m4a") {
                player = try? AVAudioPlayer(contentsOf: url)
                player?.play()
            }
            break
        case "20Dollars":
            if let url = Bundle.main.url(forResource: "20Dollars", withExtension: "m4a") {
                player = try? AVAudioPlayer(contentsOf: url)
                player?.play()
            }
            break
        case "10Dollars":
            if let url = Bundle.main.url(forResource: "10Dollars", withExtension: "m4a") {
                player = try? AVAudioPlayer(contentsOf: url)
                player?.play()
            }
            break
        case "5Dollars":
            if let url = Bundle.main.url(forResource: "5Dollars", withExtension: "m4a") {
                player = try? AVAudioPlayer(contentsOf: url)
                player?.play()
            }
            break
        case "1Dollar":
            if let url = Bundle.main.url(forResource: "1Dollar", withExtension: "m4a") {
                player = try? AVAudioPlayer(contentsOf: url)
                player?.play()
            }
            break
        default:
            print("billClass doesn't match any class")
            
        }
    }
    
}


