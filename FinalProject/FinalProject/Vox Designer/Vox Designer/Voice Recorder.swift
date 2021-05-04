//
//  Voice Recorder.swift
//  Vox Designer
//
//  Created by Shradha Ganesh on 2021-04-24.
//

import AudioKit
import AVFoundation

// Defining microphone to use it as the input
enum SourceType: String, CaseIterable {
    case microphone = "Microphone"
}

// Creating class to have all nodes and functions implemented
class VoiceRecorder {
    let engine = AudioEngine()
    let mic:AudioEngine.InputNode!
    var mixer:Mixer!

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
    
    // Defining effect nodes
     func addNodes() {
        let ringmod = RingModulator(mic, ringModFreq1: 600, ringModFreq2: 440, ringModBalance: 55, finalMix: 60)
        let distort = BitCrusher(ringmod, bitDepth: 5, sampleRate: 22100)
        let pitchshift = PitchShifter(distort, shift: -15)
        let delay = StereoDelay(pitchshift, maximumDelayTime: 0.25, time: 0.15, feedback: 0.5, dryWetMix: 0.5, pingPong: true)
        let reverb = ZitaReverb(delay, predelay: 60.0, crossoverFrequency: 100.0, lowReleaseTime: 1.0, midReleaseTime: 1.0, dryWetMix: 1.0)
        let flanger = Flanger(reverb, frequency: 350, depth: 0.4, feedback: 0.5, dryWetMix: 50)
        mixer.addInput(flanger)
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
    
    // Saving recordings with DateFormatter
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
        //let fader = Fader(mixer)
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
    
    // Deleting Recordings function 
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


