//
//  RecordingsController.swift
//  Vox Designer
//
//  Created by Shradha Ganesh on 2021-05-01.
//

import AudioKit
import SwiftUI
import AVFoundation

class RecordingsController : ObservableObject {
    var recordings = [String]()
    var players = [AudioPlayer]()
    var engine = AudioEngine()
    var mixer = Mixer()
    
    init() {
        self.getRecordingNames()
    }
    
    func load() {
        for fileName in recordings {
            let file = loadAudioFile(file: fileName)
            let player = AudioPlayer(file: file!)
            player?.isLooping = false
            players.append(player!)
            mixer.addInput(player!)
        }
    }
    
    func start() {
        engine.output = mixer
        do {
            try engine.start()
        } catch {
            print(error)
        }
    }
    
    func stop() {
        engine.stop()
    }
    
    func getRecordingNames() {
        let fileManager = FileManager.default
        let fileURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            recordings = try fileManager.contentsOfDirectory(atPath: fileURL.path)
        } catch {
            print("Couldn't load contents of directory!")
            print(error)
        }
        
        recordings.sort()
    }
    
    func loadAudioFile(file: String) -> AVAudioFile? {
        var audioFile:AVAudioFile?
        var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        url = url.appendingPathComponent(file)
        do {
            audioFile = try AVAudioFile(forReading: url)
        } catch {
            Log("Couldn't load: $file")
        }
        return audioFile
    }
    
    func play(index: Int){
        for player in players {
            if player.isPlaying {
                player.stop()
            }
        }
        
        players[index].play()
    }
}
