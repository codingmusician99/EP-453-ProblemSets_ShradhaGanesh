//
//  Voice Recorder View.swift
//  Vox Designer
//
//  Created by Shradha Ganesh on 2021-04-26.
//

import SwiftUI

struct VoiceRecordView: View {
    @ObservedObject var controller = RecorderController()
   // @ObservedObject var reccontroller = VoiceRecorder()
    let screenSize = UIScreen.main.bounds
    
    var body: some View {
        NavigationView {
            VStack(alignment: .trailing){
                NavigationLink(destination:RecordingsView()){
                    Text("Recordings >")
                }
                .onTapGesture {
                    if(controller.isRecording == true){
                        controller.stop()
                    }
                }
                .padding()
               // Spacer()
            Button(action: {
                controller.record()
            }) {
                Image(systemName: controller.isRecording ? "stop.fill" : "record.circle.fill" )
                    .font(.system(size: 60))
                    .frame(width: screenSize.width)
            }
            Spacer()
           /* Text("Record")
                .font(Font.system(.largeTitle, design: .monospaced))
                .frame(width:screenSize.width)
                Spacer()
                Spacer()
                Spacer() */
                
        }
            .onAppear(){
                controller.start()
            }
            .onDisappear(){
                controller.stop()
            }
            //VStack {
            //    HStack{
             //       Text("Ring Modulator")
             //       Spacer()
              //          .padding()
                    
                    
                    
                }
            }
            
            
    }

    
    


struct VoiceRecordView_Preview: PreviewProvider {
    static var previews: some View {
        VoiceRecordView()
    }
}
