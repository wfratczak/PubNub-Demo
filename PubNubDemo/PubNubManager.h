//
//  PubNubManager.h
//  PubNubDemo
//
//  Created by Wojtek Frątczak on 10.03.2016.
//  Copyright © 2016 Wojtek Frątczak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PubNubManager : NSObject

+ (instancetype)sharedManager;

@property (strong, nonatomic) NSData *deviceToken;

- (void)configureService;

@end
