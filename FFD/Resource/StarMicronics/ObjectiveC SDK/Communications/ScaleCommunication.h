//
//  ScaleCommunication.h
//  ObjectiveC SDK
//
//  Created by Yuji on 2016/**/**.
//  Copyright © 2016年 Star Micronics. All rights reserved.
//

#import "Communication.h"

@interface ScaleCommunication : Communication

+ (BOOL)requestStatus:(SMPort *)port completionHandler:(RequestStatusCompletionHandler)completionHandler;

+ (BOOL)passThroughCommands:(NSData *)commands port:(SMPort *)port completionHandler:(SendCompletionHandler)completionHandler;

+ (BOOL)passThroughFunction:(IStarIoExtFunction *)function port:(SMPort *)port completionHandler:(SendCompletionHandler)completionHandler;

@end
