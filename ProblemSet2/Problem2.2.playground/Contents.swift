import UIKit

var instrumentName: String
var instrumentClass: String
instrumentName = "Guitar"
instrumentClass = "String"
instrumentName = "Classical " + instrumentName
var frequency: Int
frequency = 440
var midi: Int
midi = 69
var isPlaying = true
print(instrumentName, "is a", instrumentClass, "Instrument and is currently playing MIDI note", midi, ":", isPlaying)
