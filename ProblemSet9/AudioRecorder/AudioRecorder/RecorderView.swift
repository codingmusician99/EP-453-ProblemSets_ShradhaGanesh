//
//  RecorderView.swift
//  AudioRecorder
//
//  Created by Akito van Troyer on 3/26/21.
//

import SwiftUI

struct RecorderView: View {
    @ObservedObject var controller = RecorderController()
    let screenSize = UIScreen.main.bounds
    
    @State var isTimeRunning = false
    @State private var startTime = Date()
    @State private var timeString = "00.00"
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
            NavigationView {
                VStack(alignment: .trailing){
                    //View recorded sound
                    NavigationLink(destination: LibraryView()){
                        Text("Recorded Sounds >")
                    }
                    .onTapGesture {
                        if(controller.isRecording == true){
                            controller.stop()
                        }
                    }
                    .padding()
                        
                    Spacer()

                    //Start/stop recording
                    Button(action: {
                        controller.record()
                        self.timerOn()
                    }) {
                        Image(systemName: controller.isRecording ? "stop.fill" : "record.circle.fill" )
                            .font(.system(size: 60))
                            .frame(width: screenSize.width)
                    }
                
                    Spacer()
                    Text(self.timeString)
                        .font(Font.system(.largeTitle, design: .monospaced))
                        .onReceive(timer){ _ in
                            if self.isTimeRunning {
                                timeString = String(format: "%.2f", (Date().timeIntervalSince(self.startTime)))
                            }
                        }
                        .frame(width: screenSize.width)
                    Spacer()
                    
                    //Choose the input source for recording
                    Picker(selection: $controller.audioSource, label: Text("Audio Source:")){
                        ForEach(0..<SourceType.allCases.count, id: \.self) { count in
                            Text(SourceType.allCases[count].rawValue)
                                .tag(SourceType.allCases[count])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
            }
        }
        .onAppear(){
            controller.start()
        }
        .onDisappear(){
            controller.stop()
        }
    }
    
    func timerOn(){
        if isTimeRunning {
            self.stopTimer()
        } else {
            timeString = "00.00"
            startTime = Date()
            self.startTimer()
        }
        isTimeRunning.toggle()
    }
    
    func stopTimer(){
        self.timer.upstream.connect().cancel()
    }
    
    func startTimer(){
        self.timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    }
}

struct RecorderView_Preview : PreviewProvider {
    static var previews: some View {
        RecorderView()
    }
}
