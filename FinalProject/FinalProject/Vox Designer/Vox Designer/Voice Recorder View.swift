//
//  Voice Recorder View.swift
//  Vox Designer
//
//  Created by Shradha Ganesh on 2021-04-26.
//

import SwiftUI

struct VoiceRecordView: View {
    @ObservedObject var controller = RecorderController()
   // @ObservedObject var reccontroller = VoiceRecorder() -> To be used later to implement effect sliders
    let screenSize = UIScreen.main.bounds
    
    var body: some View {
        NavigationView {
            VStack(){
                // Introductory text
                Text("Welcome to Vox Designer!")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                
               // Navigating to RecordingsView
                NavigationLink(destination:RecordingsView()){
                    Text("Tap here to access recorded files!")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color.blue)
                }
                .onTapGesture {
                    if(controller.isRecording == true){
                        controller.stop()
                    }
                }
                .padding()
                Spacer()
                
                // Button to have the user record
            Button(action: {
                controller.record()
            }) {
                Image(systemName: controller.isRecording ? "stop.fill" : "record.circle.fill" )
                    .font(.system(size: 60))
                    .frame(width: screenSize.width)
            }
                
            // Text to prompt the user to touch the circle to record
                Text("Record by tapping the circle!")
                    .font(.headline)
                    .fontWeight(.regular)
                    .foregroundColor(Color.blue)
                Spacer()
                Spacer()
                
                // Text to indicate that the user SHOULD use headphones while using this app 
            Text("IMPORTANT: Please do connect your headphones to your phone! Else, you'll get feedback!")
                .font((Font.system(.body, design: .monospaced)))
                .fontWeight(.bold)
                .foregroundColor(Color.red)
                Spacer()
                
     }
    }
        
            .padding()
        
            .onAppear(){
                controller.start()
            }
            .onDisappear(){
                controller.stop()
            }
 }
}
            
struct VoiceRecordView_Preview: PreviewProvider {
    static var previews: some View {
        VoiceRecordView()
    }
}

