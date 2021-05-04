## EP-453 Final Project

### Vox Designer: Design Document

### Created by: Shradha Ganesh 

## Summary of the program 

Vox Designer is an app that enables the user to record their voice and with in built effects create a new sound out of their voice recording. 

## Design of Vox Designer

The Vox Designer app is fundamentally an extension of your standard Audio Recorder. And thus, to begin with, there is a Voice Recorder file to implement the nodes, mixer and engine. The AudioKit package is an essential package dependency for this app, for obvious reasons. Therefore, it is first imported in the Voice Recorder file along with AVFoundation. The SourceType is defined next as the microphone. 

Next, a VoiceRecorder class is created. In this class, the engine is defined as AudioKit's AudioEngine(), the microphone is set as the Audio Engine's input node and the mixer is define. A NodeRecorder is also defined. In an init() function, the engine, mic and mixer are initialized. In the mixer, the fader with mic as input node is set to a gain of 0 in order to avoid feedback with mic. Additionally, an addNodes() function is also called here. 

In the addNodes() function, which is defined next, is where all the effects nodes are defined along with all its parameters. The signal flow for all the effects is a series connection. The first effect implemented is the Ring Modulator with AudioKit's Ring Modulator node, defined as ringmod. The input is set to mic, the ringModFreq1 parameter is set to 600 Hz, ringModFreq2 parameter is set to 440 Hz, ringModBalance is set to 55 and finalMix parameter is set to 60. 

The next effect node defined is Distortion, defined as distort. For implementing distortion, AudioKit's BitCrusher node is used. The input is set to ringmod with the bitDepth parameter is set to 5 and sampleRate parameter set to 22100 Hz. The next effect is PitchShifter, defined as pitchshift. For implementing this effect, AudioKit's PitchShifter node is used with input set to distort and the shift (pitchshift) parameter set to -15. 

The next effect is Delay, defined as delay. For implementing this effect, AudioKit's StereoDelay node is used especially because of it's ping-pong effect feature. The input is set to pitchshift, the maximumDelayTime parameter is set to 0.25 seconds, the time parameter is set to 0.15 seconds, the feedback parameter is set to 0.5, the dryWetMix is set to 0.5 and the pingPong parameter is implemented by setting its bool value to true. 

The next effect implemented is Reverb, defined as reverb. For implementing reverb, AudioKit's ZitaReverb node is used with delay set as the input, the predelay parameter set to 60 ms, crossoverFrequency parameter set to 100 Hz, the lowReleaseTime parameter set to 1 second, midReleaseTime parameter set to 1 second and dryWetMix parameter set to 1 meaning completely wet. 

The last and final effect implemented is the Flanger effect, defined as flanger. In order to implement flanger, AudioKit's Flanger node is used with input set to reverb, the frequency parameter set to 350 Hz, the depth parameter set to 0.4, the feedback parameter set to 0.5 and dryWetMix parameter set to 50%. Finally, the flanger (but really the whole effects chain) is added to the mixer. 

Next, the startRecording() function is implemented with the mic as the source type and NodeRecorder set to mixer. the function has a do/catch in order to catch any errors that the app may throw when trying to record. A stopRecording() function is also implemented next in order to stop recording effectively and immediately save the recording, by calling the saveRecording() function. 

In the saveRecording() function, the DateFormatter() is used in order to save the date of recording along with all the file management tasks needed to save a recording. After this, the start() function is implemented with the engine's output set to mixer. A do/catch is implemented in the function to catch any errors when the app tries to start the engine. Following this, a stop() function is also implemented. A deleteRecordings() function is also implemented finally in order enable the user to delete any of the recordings done. All of this is done in the Voice Recorder file. 

Next, a Voice Recorder View is created in order to create the view for the user to be able to record their voice. First, a greeting text, "Welcome to Vox Designer!" is added. Below that, is another text that prompts the user to tap there to view saved recordings. It navigates to another view for saved recordings. Below that is the record button that the user has to use to record along with text that prompts them to do so. Finally, below that is highlighted text that suggests the user to use headphones when recording with this app. This view is put in the ContentView file so that it is the first thing the user sees when the app is launched. 

Next, a Recorder Controller file is used, with SwiftUI and AVFoundation imported. In the record controller, the mechanism for recording is implemented. A Recordings View file is used (this is the file that Voice Recorder navigates to for playing back saved recordings). In this file, a trash symbol is added in order to let the user delete recordings if they need to. The code enables the app to save and properly list each saved recording and also to have it work only when the recording is stopped. The mechanism for properly naming and saving the files in the RecordingsView is implemented in a new file called RecordingsController. 

All of these files come together to create the AudioKit app. Furthermore, this app will only function in portrait mode in iPhones and iPads. So if you turn your device sideways, the view will still be locked in portrait mode. Additionally, along with AudioKit package, the Swift-UI Sliders package is also added as a package dependency in order to later (outside this class) add sliders to have the user manipulate the amount of each effect. 