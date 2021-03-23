//
//  ContentView.swift
//  MotionSynth
//
//  Created by Akito van Troyer on 3/12/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var controller = MotionController()
    var body: some View {
        NavigationView {
            VStack{
                NavigationLink(
                    destination: MotionView(controller: controller)){
                    Text("Go to MotionView >")
                        .padding()
                }
                Spacer()
                NavigationLink(destination: NewView(controller: controller)){
                    Text("Go to NewView >")
                        .padding()
                }
                Spacer()
            }
            .onAppear(){
            self.controller.start()
            }
            .onDisappear(){
            self.controller.stop()
            }
        }
    }
   
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
