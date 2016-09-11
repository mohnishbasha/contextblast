//
//  ChatMessageData.h
//  ContextBlast
//
//  Created by Adam Levy on 9/11/16.
//  Copyright © 2016 Adam Levy. All rights reserved.
//

#import <Foundation/Foundation.h>

enum ChatMessageDirection : NSUInteger {
    ChatMessageDirectionLeft = 1,
    ChatMessageDirectionRight = 2
};

@interface ChatMessageData : NSObject

@property (nonatomic) NSString *message;
@property (nonatomic) enum ChatMessageDirection diretion;

@end
