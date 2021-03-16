//
//  LoopView.swift
//  TabPlayer
//
//  Created by Shradha Ganesh on 2021-03-16.
//

import Foundation
import SwiftUI
import AudioKit
import AVFoundation
import Sliders

class LoopView:
    ObservableObject {
    let engine = AudioEngine()
    var mixer:Mixer?
    var bassdrum:AudioPlayer?
    var clap:AudioPlayer?
    var loop:AudioPlayer?
    
    func SetUpPlayback(){
        let BassDrumFile =
        loadAudioFile(file: "Samples/BD.wav")
        bassdrum = AudioPlayer(file: BassDrumFile!)
        bassdrum?.isLooping = true
        
        let ClapFile =
        loadAudioFile(file: "Samples/HC.wav")
        clap = AudioPlayer(file: ClapFile!)
        clap?.isLooping = true
        
        mixer = Mixer([bassdrum!, clap!])
        
        do {
            try engine.start()
        } catch {
            Log("AudioKit did not start! \(error)")
        }
       
        
            
        
    }
    
    func loadAudioFile(file: String) -> AVAudioFile? {
        var audioFile:AVAudioFile?
        guard let url = Bundle.main.resourceURL?.appendingPathComponent(file) else { return nil }
        do {
            audioFile = try AVAudioFile(forReading: url)
        } catch {
            Log("Could not load: $file")
        }
        
        return audioFile
    }
    
    func stop(){
        engine.stop()
    }
    
    func playBD(){
        bassdrum?.play()
    }
    
    func stopBD(){
        bassdrum?.stop()
    }
    
    func playHC(){
        clap?.play()
    }
    
    func stopHC(){
        clap?.stop()
    }
    
 

struct LoopsView: View {
    @ObservedObject var controller = LoopView()
    let screenSize = UIScreen.main.bounds
    @State var bassdrumColor = UIColor(hue: 0.5, saturation: 1, brightness: 1, alpha: 1)
    @State var clapColor = UIColor(hue: 0.7, saturation: 1, brightness: 1, alpha: 1)
    var body: some View {
        VStack {
            Button(action: controller.playBD){
                Rectangle()
                    .fill(Color(bassdrumColor))
                    .gesture(DragGesture (minimumDistance: 0, coordinateSpace: .local))
                    
            }
            Button(action: controller.playHC){
            Rectangle()
                    .fill(Color(clapColor))
                .gesture(DragGesture (minimumDistance: 0, coordinateSpace: .local))
                   
            }
            
            
        }
        .onAppear{
            controller.SetUpPlayback()
        }
        .onDisappear {
            controller.stop()
        }
        
           
}
    

struct LoopsViews: PreviewProvider{
    static var previews: some View{
      LoopsView()
    }
}

}
}
