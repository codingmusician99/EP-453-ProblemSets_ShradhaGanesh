//
//  Recorder Controller.swift
//  Vox Designer
//
//  Created by Shradha Ganesh on 2021-04-25.
//

import SwiftUI
import AVFoundation

class RecorderController : ObservableObject {
    @Published var audioSource = SourceType.microphone
    @Published var isRecording = false
    var recorder = VoiceRecorder()
    
    init(){
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, options: [.defaultToSpeaker, .mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error {
            print(error)
        }
    }
    
    func record() {
        isRecording.toggle()
        if isRecording {
            recorder.startRecording(source: audioSource)
        }
        else {
            recorder.stopRecording()
        }
    }
    
    func start() {
        recorder.start()
    }
    
    func stop() {
        recorder.stop()
    }
}
