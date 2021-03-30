//
//  XYPadController.swift
//  MultiTouchSynth
//
//  Created by Shradha Ganesh on 2021-03-29.
//

import UIKit
import SwiftUI

class XYPadController: UIViewController {
    static let numFingers = 10
    var fingers = [UITouch:CGPoint]()
    let synth = MultiTouchSynth2()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = XYPadView(frame: .zero)
    }
    
    override func viewDidAppear(_ animated: Bool){
        synth.start()
    }
    
    override func viewDidDisappear(_ animated: Bool){
        synth.stop()
    }
    
    // MARK: - Touch Began
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if fingers[touch] == nil {
                var location = touch.location(in: self.view)
                (view as! XYPadView).addCircle(point: location)
                location.x = location.x/self.view.frame.size.width
                location.y = location.y/self.view.frame.size.height
                fingers[touch] = location
                synth.update(id: touch.hash, point: location)
            }
        }
    }
    
    // MARK: - Touch Moved
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?){
        for touch in touches {
            if fingers[touch] != nil {
                for subview in self.view.subviews {
                    subview.removeFromSuperview()
                }
                var location = touch.location(in: self.view)
                (view as! XYPadView).addCircle(point: location)
                location.x = location.x/self.view.frame.size.width
                location.y = location.y/self.view.frame.size.height
                fingers[touch] = location
                synth.update(id: touch.hash, point: location)
            }
        }
    }
    
    // MARK: - Touch Ended
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?){
        for touch in touches {
            if fingers[touch] != nil {
            fingers.removeValue(forKey: touch)
            synth.stopSynth(id: touch.hash)
        }
    }
        if fingers.count <= 0 {
            for subview in self.view.subviews {
                subview.removeFromSuperview()
            }
        }
    }
    
    // MARK: - Touch Cancelled
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if fingers[touch] != nil {
                fingers.removeValue(forKey: touch)
                synth.stopSynth(id: touch.hash)
            }
        }
        
        if fingers.count <= 0 {
            for subview in self.view.subviews {
                subview.removeFromSuperview()
            }
        }
    }
}

// MARK: - UIViewController Container
struct XYPadControllerContainer: UIViewControllerRepresentable {
    typealias UIViewControllerType = XYPadController
    
    func makeUIViewController(context: Context) -> XYPadController {
        let controller = XYPadController()
        return controller
    }
    
    func updateUIViewController(_ uiViewController: XYPadController, context: Context) {
        
    }
    
    
}
