//
//  SpeechToTextWraper.swift
//  ContextBlast
//
//  Created by Adam Levy on 9/11/16.
//  Copyright © 2016 Adam Levy. All rights reserved.
//

import Foundation
import SpeechToTextV1

@objc protocol SpeechToTextWrapperDelegate {
    func textRecognized(text : String)
}

public class SpeechToTextWrapper : NSObject {
    var delegate : SpeechToTextWrapperDelegate?
    
    public func beginListeningForSpeech() {
        let username = "0d6eb480-83b0-4fce-a588-f492f0d6432e"
        let password = "LTTiuZiZaL7M"
        let speechToText = SpeechToText(username: username, password: password)
        
        // load audio file
        guard let fileURL = NSBundle.mainBundle().URLForResource("your-audio-filename", withExtension: "wav") else {
            print("Audio file could not be loaded.")
            return
        }
        
        // transcribe audio file
        let settings = TranscriptionSettings(contentType: .WAV)
        let failure = { (error: NSError) in print(error) }
        speechToText.transcribe(fileURL, settings: settings, failure: failure) { results in
            print(results.last?.alternatives.last?.transcript)
        }
    }
    
    public func getTextForSpeech(speechURL : NSURL) {
        let username = "0d6eb480-83b0-4fce-a588-f492f0d6432e"
        let password = "LTTiuZiZaL7M"
        let speechToText = SpeechToText(username: username, password: password)
        
        // load audio file
//        guard let fileURL = NSBundle.mainBundle().URLForResource("your-audio-filename", withExtension: "wav") else {
//            print("Audio file could not be loaded.")
//            return
//        }
        
        // transcribe audio file
        let settings = TranscriptionSettings(contentType: .WAV)
        let failure = { (error: NSError) in print(error) }
        speechToText.transcribe(speechURL, settings: settings, failure: failure) { results in
            self.delegate?.textRecognized((results.last?.alternatives.last?.transcript)!)
        }
    }
}