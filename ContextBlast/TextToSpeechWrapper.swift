//
//  TextToSpeechWrapper.swift
//  ContextBlast
//
//  Created by Adam Levy on 9/11/16.
//  Copyright © 2016 Adam Levy. All rights reserved.
//

import Foundation
import TextToSpeechV1

public class TextToTextWrapper : NSObject {
    
    let textToSpeech = TextToSpeech(username: "", password: "")
    
    public func hearTextToSpeech(speech : String) {
//        let failure = { (error: NSError) in print(error) }
        
//        textToSpeech.synthesize(speech, failure: failure) { data in
//            let audioPlayer = try AVAudioPlayer(data: data)
//            audioPlayer.prepareToPlay()
//            audioPlayer.play()
//        }
    }
}