//
//  Voice Recorder.swift
//  Vox Designer
//
//  Created by Shradha Ganesh on 2021-04-24.
//

import AudioKit
import AVFoundation

enum SourceType: String, CaseIterable {
    case microphone = "Microphone"
}

class VoiceRecorder {
    let engine = AudioEngine()
    let mic:AudioEngine.InputNode!
    var mixer:Mixer!
   // var nodes = [[Node]]()
   // var count = 0
    
    
    
    var curSource:SourceType = .microphone
    
    var recorder:NodeRecorder!
    
    init(){
        guard let input = engine.input else {
            fatalError()
        }
        mic = input
        mixer = Mixer([Fader(mic, gain: 0)])
        
        addNodes()
        
        
    }
    
    func addNodes() {
        let ringmod = RingModulator(mic)
        let distort = Distortion(ringmod)
        let pitchshift = PitchShifter(distort)
        let reverb = ZitaReverb(pitchshift)
        mixer.addInput(reverb)
        mixer = Mixer([Fader(ringmod, gain: 0)])
        mixer = Mixer([Fader(distort, gain: 0)])
        mixer = Mixer([Fader(pitchshift, gain: 0)])
        mixer = Mixer([Fader(reverb, gain: 0)])
       
        
    }
    
    func startRecording(source: SourceType){
        do {
            switch source {
            case .microphone:
                curSource = .microphone
                recorder = try NodeRecorder(node: mixer)
                break
            }
            try recorder.record()
        } catch let error {
            Log(error)
        }
        
    }
    
    func stopRecording(){
        recorder.stop()
        saveRecording()
    }
    
    func saveRecording() {
        let format = DateFormatter()
        format.dateFormat = "yMMddHHmmss"
        let fileManager = FileManager.default
        var url = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        url = url.appendingPathComponent("\(format.string(from: Date())).caf")
        
        do {
            if fileManager.fileExists(atPath: (recorder.audioFile?.url.path)!){
                try fileManager.copyItem(at:(recorder.audioFile?.url)!, to: url)
            }
        } catch {
            print("Error while enumerating files \(url.path): \(error.localizedDescription)")
        }
    }
    
    func start(){
        engine.output = mixer
        do {
            try engine.start()
        } catch {
            print("Cannot start AudioKit!")
        }
        
    }
    
    func stop() {
        engine.stop()
    }
    
    func deleteRecordings() {
        let fileManager = FileManager.default
        let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let files = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
            for file in files {
                try fileManager.removeItem(at: file)
            }
        } catch {
            print(error)
        }
    }
    
    
    
}
