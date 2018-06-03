//
//  Login.m
//  SAIM_UPDATING
//
//  Created by Thidaporn Kijkamjai on 5/2/2559 BE.
//  Copyright © 2559 Thidaporn Kijkamjai. All rights reserved.
//

#import "LogIn.h"
#import "SharedLogIn.h"
#import "Utility.h"


@implementation LogIn

-(LogIn *)initWithUsername:(NSString *)username status:(NSInteger)status deviceToken:(NSString *)deviceToken
{
    self = [super init];
    if(self)
    {
        self.logInID = [LogIn getNextID];
        self.username = username;
        self.status = status;
        self.deviceToken = deviceToken;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return  self;
}

+(NSInteger)getNextID
{
    NSString *strNameID;
    NSMutableArray *dataList;
    dataList = [SharedLogIn sharedLogIn].logInList;
    strNameID = @"logInID";
    
    NSString *strSortID = [NSString stringWithFormat:@"_%@",strNameID];
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:strSortID ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor1, nil];
    NSArray *sortArray = [dataList sortedArrayUsingDescriptors:sortDescriptors];
    dataList = [sortArray mutableCopy];
    
    if([dataList count] == 0)
    {
        return 1;
    }
    else
    {
        id value = [dataList[0] valueForKey:strNameID];
        NSString *strMaxID = value;
        
        return [strMaxID intValue]+1;
    }
}

+(void)addObject:(LogIn *)logIn
{
    NSMutableArray *logInList = [SharedLogIn sharedLogIn].logInList;
    [logInList addObject:logIn];
}

@end
