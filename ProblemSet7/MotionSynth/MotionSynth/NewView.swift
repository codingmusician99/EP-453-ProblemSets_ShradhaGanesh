//
//  NewView.swift
//  MotionSynth
//
//  Created by Shradha Ganesh on 2021-03-23.
//

import SwiftUI

struct NewView: View{
    @ObservedObject var controller = MotionController()
    var body: some View {
        ZStack {
            NewTrackView(position: controller.position, rotationAngle: controller.rotationAngle, acceleration: controller.acceleration, accelerateAvg: controller.accelerateAvg)
            VStack{
                NewSensorView(name: "Accel X:", value: controller.data.accelX)
                NewSensorView(name: "Accel Y:", value: controller.data.accelY)
                NewSensorView(name: "Accel Z:", value: controller.data.accelZ)
                NewSensorView(name: "Gyro X:", value: controller.data.gyroX)
                NewSensorView(name: "Gyro Y:", value: controller.data.gyroY)
                NewSensorView(name: "Gyro Z:", value: controller.data.gyroZ)
                NewSensorView(name: "Pitch:", value: controller.data.pitch)
                NewSensorView(name: "Roll:", value: controller.data.roll)
                NewSensorView(name: "Yaw:", value: controller.data.yaw)
                
            }
            
        }
        .gesture(
            DragGesture(minimumDistance: 0).onChanged({ _ in controller.startSound()
                
            })
            .onEnded({ _ in
                controller.stopSound()
            })
            
        )
        .onAppear(){
            controller.start()
        }
        .onDisappear(){
            controller.stop()
        }
        
    }
}
    
 

struct NewSensorView: View {
    var name:String
    var value:Double
    
    var body: some View {
        HStack {
            Spacer()
            Text(name)
                .padding()
            Spacer()
            Text("\(value, specifier: "%.03f")")
                .padding()
                .frame(width: 100)
            Spacer()
        }
        
    }
    
}

struct NewTrackView: View {
    @ObservedObject var controller = MotionController()
    let screenSize = UIScreen.main.bounds
    var position: CGPoint
    var rotationAngle: CGFloat
    var acceleration: CGPoint
    var accelerateAvg: CGFloat
    
    var body: some View {
        VStack {
            Rectangle()
                .fill(Color(hue: Double(accelerateAvg), saturation: 1, brightness: 1, opacity: 1))
                .frame(width: scale(num: accelerateAvg, minNum: 0, maxNum: 1, scaleMin: 50, scaleMax: 150), height: scale(num: accelerateAvg, minNum: 0, maxNum: 1, scaleMin: 50, scaleMax: 150))
                .offset(x: self.acceleration.x, y: self.acceleration.y)
                .transformEffect(
                    CGAffineTransform(rotationAngle: rotationAngle)
                        .translatedBy(x: self.acceleration.x - 25, y: self.acceleration.y - 25)
                )
            
        }
        .frame(width: screenSize.width, height: screenSize.height)
        
    }
}

struct TapGestureView: View {
    @ObservedObject var controller = MotionController()
    @State var tapped = false
    
    var tap: some Gesture {
        TapGesture(count: 1)
            .onEnded {_ in self.tapped = !self.tapped}
    }
    var body: some View {
        VStack {
            Rectangle()
                .fill(self.tapped ? Color.yellow : Color.red)
                .frame(width: 50, height: 50)
                .gesture(tap)
        }
        
    }
}

func scale(num: CGFloat, minNum: CGFloat, maxNum: CGFloat, scaleMin: CGFloat, scaleMax: CGFloat) -> CGFloat {
    if (num <= minNum) {return scaleMin}
    if (num >= maxNum) {return scaleMax}
    return (num-minNum)/(maxNum-minNum) * (scaleMax-scaleMin) + scaleMin
}

struct NewView_Previews: PreviewProvider {
    static var previews: some View {
        MotionView()
    }
}
