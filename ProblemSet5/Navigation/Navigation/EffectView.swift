//
//  EffectView.swift
//  Navigation
//
//  Created by Shradha Ganesh on 2021-03-09.
//

import Foundation
import AudioKit
import SwiftUI

struct EffectView: View{
    @ObservedObject var controller:ProcessorController
    let screenSize = UIScreen.main.bounds
    @State private var currentPosition: CGSize = .zero
    
    var body: some View {
        VStack {
            Circle()
                .fill(Color.red)
                .frame(width: 50, height: 50)
                .offset(x: self.currentPosition.width, y: self.currentPosition.height)
        }
        .frame(width: screenSize.width, height: screenSize.height)
        .background(Color.black)
        .gesture(
            DragGesture(minimumDistance: 0).onChanged{ value in
                let x = value.location.x
                let y = value.location.y
                
                self.currentPosition = CGSize(width: x - screenSize.width * 0.5, height: value.location.y - screenSize.height * 0.5)
                controller.lpf?.cutoffFrequency = AUValue(x / screenSize.width) * Float(Settings.sampleRate * 0.125)
                controller.chorus?.depth = AUValue(y / screenSize.height) * 20
            })
        .navigationBarTitle("EffectView")
    }
}

struct EffectView_Previews: PreviewProvider{
    static var previews: some View{
        EffectView(controller: ProcessorController())
    }
    
    
}

