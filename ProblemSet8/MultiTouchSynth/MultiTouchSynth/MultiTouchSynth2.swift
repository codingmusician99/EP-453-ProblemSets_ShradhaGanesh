//
//  MultiTouchSynth2.swift
//  MultiTouchSynth
//
//  Created by Shradha Ganesh on 2021-03-29.
//

import AudioKit
import AVFoundation

class MultiTouchSynth2 {
    let engine = AudioEngine()
    let mixer = Mixer()
    var ids = [Int:Int]()
    var nodes = [[Node]]()
    var count = 0
    
    init(){
        for _ in 0..<XYPadController.numFingers {
            add()
        }
    }
    
    func add(){
        let osc = MorphingOscillator(waveformArray: [Table(.sine), Table(.triangle), Table(.sawtooth), Table(.square)])
        let filter = LowPassFilter(osc)
        let env = AmplitudeEnvelope(filter)
        env.attackDuration = 0.1
        env.decayDuration = 0.1
        env.releaseDuration = 0.1
        let reverb = Reverb(env)
        mixer.addInput(reverb)
        
        nodes.append([osc, filter, env, reverb])
        }
    
    func update(id: Int, point: CGPoint){
        if ids[id] == nil {
            ids[id] = count
            count += 1
            
            let synths = nodes[ids[id]!]
            let env = synths[2] as! AmplitudeEnvelope
            env.start()
        }
        
        let freq = scale(num: point.y, minNum: 0, maxNum: 1, scaleMin: 3000, scaleMax: 60)
        let dryWet = scale(num: point.y, minNum: 0, maxNum: 1, scaleMin: 0, scaleMax: 0.75)
        let synths = nodes[ids[id]!]
        let osc = synths[0] as! MorphingOscillator
        osc.frequency = AUValue(freq)
        let filter = synths[1] as! LowPassFilter
        let reverb = synths[3] as! Reverb
        filter.cutoffFrequency = AUValue(freq)
        reverb.dryWetMix = AUValue(dryWet)
        osc.index = AUValue(point.x) * 3
        
        
    }
    
    func stopSynth(id: Int) {
        let synths = nodes[ids[id]!]
        let env = synths[2] as! AmplitudeEnvelope
        env.stop()
        ids.removeValue(forKey:id)
        count -= 1
    }
    
    func start(){
        engine.output = mixer
        
        do {
            try engine.start()
        } catch let error {
            Log(error)
        }
        
        for node in nodes {
            (node[0] as! MorphingOscillator).start()
        }
    }
    
    func stop(){
        for node in nodes {
            (node[0] as! MorphingOscillator).stop()
        }
        engine.stop()
    }
    
    func scale(num: CGFloat, minNum: CGFloat, maxNum: CGFloat,
    scaleMin: CGFloat, scaleMax: CGFloat) -> CGFloat {
        if (num <= minNum) {return scaleMin}
        if (num >= maxNum) {return scaleMax}
        return (num-minNum)/(maxNum-minNum) * (scaleMax-scaleMin) + scaleMin
    }
    
    

}
