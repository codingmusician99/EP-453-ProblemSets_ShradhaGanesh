//
//  RecordingsView.swift
//  Vox Designer
//
//  Created by Shradha Ganesh on 2021-05-01.
//

import SwiftUI

struct RecordingsView: View {
    @ObservedObject var controller = RecordingsController()
    @ObservedObject var recordcontroller = RecorderController()
    var recorder = VoiceRecorder()
    
    var body: some View {
        Button(action: {
            recorder.deleteRecordings()
        }) {
            Image(systemName: "trash.fill")
        }
        
        
        List {
            ForEach(0..<controller.recordings.count, id: \.self) { index in
                Button(action: {controller.play(index: index)}){
                    Text(controller.recordings[index])
                }
            }
        }
        .onAppear(){
            if(controller.recordings.count != 0){
                controller.load()
            }
            if(recordcontroller.isRecording == true){
                recordcontroller.stop()
            }
            controller.start()
            print(controller.recordings.count)
        }
        .onDisappear(){
            controller.stop()
        }
    }
}


