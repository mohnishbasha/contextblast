    //
//  ImageContextTableViewController.m
//  ContextBlast
//
//  Created by Adam Levy on 9/11/16.
//  Copyright © 2016 Adam Levy. All rights reserved.
//

#import "ImageContextTableViewController.h"
#import "ContextBlast-Swift.h"
#import "ChatMessageData.h"
#import "LeftMessageTableViewCell.h"
#import "RightMessageTableViewCell.h"
#import <AVFoundation/AVFoundation.h>

@interface ImageContextTableViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *label;
@property (nonatomic, weak) IBOutlet UITableView *chatTableView;
@property (nonatomic, weak) IBOutlet UIButton *voiceButton;
@property (nonatomic) SpeechToTextWrapper *speechToText;
@property (nonatomic) AVAudioRecorder *recorder;
@property (nonatomic) NSURL *recordingUrl;
@property (nonatomic) NSMutableArray *chats;
@property (nonatomic) ConversationWrapper *conversationWrapper;

@end

@implementation ImageContextTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.voiceButton.layer.cornerRadius = 5;
    
    self.chats = [[NSMutableArray alloc] init];
    
    self.imageView.image = self.imageContext.image;
    self.label.text = self.imageContext.title;
    
    self.speechToText = [[SpeechToTextWrapper alloc] init];
    self.speechToText.delegate = self;
    
    self.conversationWrapper = [[ConversationWrapper alloc] init];
    self.conversationWrapper.delegate = self;
    [self.conversationWrapper startConversation];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.chats count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id data = [self.chats objectAtIndex:indexPath.row];
    
    if ([data isMemberOfClass:[ChatMessageData class]]) {
        ChatMessageData *chatData = (ChatMessageData *)data;
        if (chatData.diretion == ChatMessageDirectionLeft) {
            RightMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RightMessageTableViewCell" forIndexPath:indexPath];
            cell.label.text = chatData.message;
            
            return cell;
        } else if (chatData.diretion == ChatMessageDirectionRight) {
            LeftMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LeftMessageTableViewCell" forIndexPath:indexPath];
            cell.label.text = chatData.message;
            
            return cell;
        }
    }
    
    return nil;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)voiceButtonTapped:(id)sender {
    //[self.speechToText beginListeningForSpeech];
    if ([self.recorder isRecording]) {
        [self.recorder stop];
        
        AVAudioSession *session = [AVAudioSession sharedInstance];
        int flags = AVAudioSessionSetActiveFlags_NotifyOthersOnDeactivation;
        [session setActive:NO withFlags:flags error:nil];
        
        [self.voiceButton setBackgroundColor:[UIColor clearColor]];
        
        [self.speechToText getTextForSpeech:self.recordingUrl];
    } else {
        NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsDir = [dirPaths objectAtIndex:0];
        NSURL *tmpFileUrl = [NSURL fileURLWithPath:[docsDir stringByAppendingPathComponent:@"tmp.wav"]];
        self.recordingUrl = tmpFileUrl;
        
        NSDictionary *recordSettings = [NSDictionary
                                        dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:AVAudioQualityMax],
                                        AVEncoderAudioQualityKey,
                                        [NSNumber numberWithInt:16],
                                        AVEncoderBitRateKey,
                                        [NSNumber numberWithInt: 2],
                                        AVNumberOfChannelsKey,
                                        [NSNumber numberWithFloat:16000.0], AVSampleRateKey,
                                        [NSNumber numberWithInt:8], AVLinearPCMBitDepthKey,
                                        nil];
        NSError *error = nil;
        self.recorder = [[AVAudioRecorder alloc] initWithURL:tmpFileUrl settings:recordSettings error:&error];
        [self.recorder prepareToRecord];
        
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryRecord error:nil];
        [session setActive:YES error:nil];
        
        [self.recorder record];
        
        [self.voiceButton setBackgroundColor:[UIColor redColor]];
    }
}

- (void)textRecognized:(NSString *)text {
    NSLog(@": %@", text);
    
    NSCharacterSet *charactersToRemove = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    NSString *strippedReplacement = [[text componentsSeparatedByCharactersInSet:charactersToRemove] componentsJoinedByString:@""];
    
    NSLog(@"rep: %@", strippedReplacement);
    
    ChatMessageData *message = [[ChatMessageData alloc] init];
    message.message = text
     ;
    message.diretion = ChatMessageDirectionRight;
    [self.chats addObject:message];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.chats.count - 1) inSection:0];
    [self.chatTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    
    [self.conversationWrapper fetchConversation:text];
}

- (void)conversationReceived:(NSString *)text {
    ChatMessageData *message = [[ChatMessageData alloc] init];
    message.message = text;
    message.diretion = ChatMessageDirectionLeft;
    [self.chats addObject:message];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.chats.count - 1) inSection:0];
    [self.chatTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
}

@end
