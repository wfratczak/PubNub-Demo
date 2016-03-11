//
//  ViewController.m
//  PubNubDemo
//
//  Created by Wojtek Frątczak on 10.03.2016.
//  Copyright © 2016 Wojtek Frątczak. All rights reserved.
//

#import "ViewController.h"
#import <PubNub/PubNub.h>

static NSString *const ChannelKey = @"test_channel_pubnub";

@interface ViewController () <PNObjectEventListener>
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) PubNub *client;
@property (strong, nonatomic) NSString *uuid;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [self configureService];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)configureService{
    PNConfiguration *configuration = [PNConfiguration configurationWithPublishKey:@"demo"
                                                                     subscribeKey:@"demo"];
    self.client = [PubNub clientWithConfiguration:configuration];
    [self.client addListener:self];
    [self.client subscribeToChannels: @[ChannelKey] withPresence:YES];
}

- (IBAction)sendButtonTapped:(id)sender {
    
    [self.client publish: [NSString stringWithFormat: @"Message:%@ from:%@",self.messageTextField.text , self.uuid] toChannel:ChannelKey
          withCompletion:^(PNPublishStatus *status) {
              
              // Check whether request successfully completed or not.
              if (!status.isError) {
                  
                  // Message successfully published to specified channel.
              }
              // Request processing failed.
              else {
                  
                  // Handle message publish error. Check 'category' property to find out possible issue
                  // because of which request did fail.
                  //
                  // Request can be resent using: [status retry];
              }
          }];
    
}

#pragma mark - PNObjectEventListener

- (void)client:(PubNub *)client didReceiveMessage:(PNMessageResult *)message {
    
    // Handle new message stored in message.data.message
    if (message.data.actualChannel) {
        
        // Message has been received on channel group stored in
        // message.data.subscribedChannel
    }
    else {
        
        // Message has been received on channel stored in
        // message.data.subscribedChannel
    }
    self.messageLabel.text = [NSString stringWithFormat:@"Received message: %@ on channel %@ at %@", message.data.message,
                              message.data.subscribedChannel, message.data.timetoken ];
    NSLog(@"Received message: %@ on channel %@ at %@", message.data.message,
          message.data.subscribedChannel, message.data.timetoken);
}

- (void)client:(PubNub *)client didReceiveStatus:(PNSubscribeStatus *)status {
    
    if (status.category == PNUnexpectedDisconnectCategory) {
        // This event happens when radio / connectivity is lost
    }
    
    else if (status.category == PNConnectedCategory) {
        
        // Connect event. You can do stuff like publish, and know you'll get it.
        // Or just use the connected event to confirm you are subscribed for
        // UI / internal notifications, etc
        
        [self.client publish: [NSString stringWithFormat: @"Hello from the iOS: %@", self.uuid] toChannel:ChannelKey
              withCompletion:^(PNPublishStatus *status) {
                  
                  // Check whether request successfully completed or not.
                  if (!status.isError) {
                      
                      // Message successfully published to specified channel.
                  }
                  // Request processing failed.
                  else {
                      
                      // Handle message publish error. Check 'category' property to find out possible issue
                      // because of which request did fail.
                      //
                      // Request can be resent using: [status retry];
                  }
              }];
    }
    else if (status.category == PNReconnectedCategory) {
        
        // Happens as part of our regular operation. This event happens when
        // radio / connectivity is lost, then regained.
    }
    else if (status.category == PNDecryptionErrorCategory) {
        
        // Handle messsage decryption error. Probably client configured to
        // encrypt messages and on live data feed it received plain text.
    }
    
}

@end
