//
//  ConversationWrapper.swift
//  ContextBlast
//
//  Created by Adam Levy on 9/11/16.
//  Copyright © 2016 Adam Levy. All rights reserved.
//

import Foundation
import ConversationV1

@objc protocol ConversationWrapperDelegate {
    func conversationReceived(conversation : String)
}

public class ConversationWrapper : NSObject {
    var delegate : ConversationWrapperDelegate?
    let username = "da8ba92d-db2c-4cc3-8a59-115ba249ccc3"
    let password = "C7KrV3WpDIuG"
    let version = "2016-09-11" // use today's date for the most recent version
    let conversation = Conversation(username: "da8ba92d-db2c-4cc3-8a59-115ba249ccc3", password: "C7KrV3WpDIuG", version: "2016-09-11")
    let workspaceID = "0d6a382d-dbf4-4a82-a984-7f0cd54a764b"
    var context: Context? // save context to continue conversation
    
    public func startConversation() {
        
        
        
        let failure = { (error: NSError) in print(error) }
        
        conversation.message(workspaceID, failure: failure) { response in
            print(response.output.text)
            self.self.context = response.context
            //self.delegate?.conversationReceived(response.output.text[0])
        }
    }
    
    public func fetchConversation(text : String) {
        let failure = { (error: NSError) in print(error) }
        conversation.message(workspaceID, text: text, context: context, failure: failure) { response in
            print(response.output.text)
            self.context = response.context
            self.delegate?.conversationReceived(response.output.text[0])
        }
    }
}