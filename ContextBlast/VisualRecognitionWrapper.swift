//
//  VisualRecognitionWrapper.swift
//  ContextBlast
//
//  Created by Adam Levy on 9/10/16.
//  Copyright © 2016 Adam Levy. All rights reserved.
//

import Foundation
import VisualRecognitionV3

@objc protocol VisualRecognitionWrapperDelegate {
    func imageRecognized(context : String)
}

public class VisualRecognitionWrapper : NSObject {
    var delegate : VisualRecognitionWrapperDelegate?
    
    public func fetchImage(path : NSURL) {
        
        let apiKey = "71b4f5305070bdfe566f52a0907c83644150ab82"
        let version = "2016-09-10" // use today's date for the most recent version
        let visualRecognition = VisualRecognition(apiKey: apiKey, version: version)
        
        
        let url = "http://www1.domain.com/blog/wp-content/uploads/2014/09/disrupt_graphic_blog.jpg"
        let failure = { (error: NSError) in print(error) }
        visualRecognition.classify(url, failure: failure) { classifiedImages in
            print(classifiedImages)
        }
        
        visualRecognition.recognizeText(url) { imagesWithWords in
            print(imagesWithWords)
            self.delegate?.imageRecognized(imagesWithWords.images[0].text)
            
        }
    }
}