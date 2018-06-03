//
//  HomeModel.m
//  SaleAndInventoryManagement
//
//  Created by Thidaporn Kijkamjai on 7/9/2558 BE.
//  Copyright (c) 2558 Thidaporn Kijkamjai. All rights reserved.
//
#import <objc/runtime.h>
#import "HomeModel.h"
#import "UserAccount.h"
#import "PushSync.h"
#import "Utility.h"
#import "OrderTaking.h"
#import "OrderNote.h"
#import "OrderKitchen.h"



@interface HomeModel()
{
    NSMutableData *_downloadedData;
//    enum enumDB _currentDB;
    BOOL _downloadSuccess;
}
@end
@implementation HomeModel
@synthesize propCurrentDB;
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if(!error)
    {
        NSLog(@"Download is Successful");
        switch (propCurrentDB) {
            case dbMasterWithProgressBar:
            case dbMaster:
                if(!_downloadSuccess)//กรณีไม่มี content length จึงไม่รู้ว่า datadownload/downloadsize = 1 -> _downloadSuccess จึงไม่ถูก set เป็น yes
                {
                    NSLog(@"content length = -1");
                    [self prepareData];
                }
                break;
            
                
            default:
                break;
        }
    }
    else
    {
        NSLog(@"Error %@",[error userInfo]);
        if (self.delegate)
        {
            [self.delegate connectionFail];
        }
    }
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)dataRaw;
{
    switch (propCurrentDB) {
        case dbMaster:
        {
            [_dataToDownload appendData:dataRaw];            
            if([ _dataToDownload length ]/_downloadSize == 1.0f)
            {
                _downloadSuccess = YES;
                [self prepareData];
            }
        }
            break;
        case dbMasterWithProgressBar:
        {
            [_dataToDownload appendData:dataRaw];
            if(self.delegate)
            {
                [self.delegate downloadProgress:[_dataToDownload length ]/_downloadSize];
            }
            
            
            if([ _dataToDownload length ]/_downloadSize == 1.0f)
            {
                _downloadSuccess = YES;
                [self prepareData];
            }
        }
            break;
        default:
            break;
    }
}
-(void)prepareData
{
    NSMutableArray *arrItem = [[NSMutableArray alloc] init];
    
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:_dataToDownload options:NSJSONReadingAllowFragments error:nil];
    
    //check loaded data ให้ไม่ต้องใส่ data แล้ว ไปบอก delegate ว่าให้ show alert error occur, please try again
    if([jsonArray count] == 0)
    {
        if (self.delegate)
        {
            [self.delegate itemsDownloaded:arrItem];
        }
        return;
    }
    else if([jsonArray count] == 1)
    {
        NSArray *arrData = jsonArray[0];
        NSDictionary *jsonElement = arrData[0];
        
        if(jsonElement[@"Expired"])
        {
            if([jsonElement[@"Expired"] isEqualToString:@"1"])
            {
                if (self.delegate)
                {
                    [self.delegate applicationExpired];
                }
                return;
            }
        }
    }
    for(int i=0; i<[jsonArray count]; i++)
    {
        //arrdatatemp <= arrdata
        NSMutableArray *arrDataTemp = [[NSMutableArray alloc]init];
        NSArray *arrData = jsonArray[i];
        for(int j=0; j< arrData.count; j++)
        {
            NSDictionary *jsonElement = arrData[j];
            NSObject *object = [[NSClassFromString([Utility getMasterClassName:i]) alloc] init];
            
            unsigned int propertyCount = 0;
            objc_property_t * properties = class_copyPropertyList([object class], &propertyCount);
            
            for (unsigned int i = 0; i < propertyCount; ++i)
            {
                objc_property_t property = properties[i];
                const char * name = property_getName(property);
                NSString *key = [NSString stringWithUTF8String:name];
                
                
                NSString *dbColumnName = [Utility makeFirstLetterUpperCase:key];
                if(!jsonElement[dbColumnName])
                {
                    continue;
                }
                
                [object setValue:jsonElement[dbColumnName] forKey:key];
            }
            
            [arrDataTemp addObject:object];
        }
        [arrItem addObject:arrDataTemp];
    }
    
    
    // Ready to notify delegate that data is ready and pass back items
    if (self.delegate)
    {
        [self.delegate itemsDownloaded:arrItem];
    }
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    completionHandler(NSURLSessionResponseAllow);
    
    switch (propCurrentDB) {
        case dbMasterWithProgressBar:
        {
            if(self.delegate)
            {
                [self.delegate downloadProgress:0.0f];
            }
        }
            break;
        default:
            break;
    }
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    NSLog(@"expected content length httpResponse: %ld", (long)[httpResponse expectedContentLength]);
    
    NSLog(@"expected content length response: %lld",[response expectedContentLength]);
    _downloadSize=[response expectedContentLength];
    _dataToDownload=[[NSMutableData alloc]init];
}

- (void)downloadItems:(enum enumDB)currentDB
{
    propCurrentDB = currentDB;
    NSString *url;
    switch (currentDB) {
        case dbMaster:
            {
                url = [NSString stringWithFormat:[Utility url:urlMasterGet],[Utility randomStringWithLength:6]];
            }
            break;
        case dbMasterWithProgressBar:
        {
            url = [NSString stringWithFormat:[Utility url:urlMasterGet],[Utility randomStringWithLength:6]];
        }
            break;
        default:
            break;
    }
    NSURL *nsURL = [NSURL URLWithString:url];
    NSString *noteDataString = @"";
    noteDataString = [NSString stringWithFormat:@"modifiedUser=%@&modifiedDeviceToken=%@&dbName=%@",[Utility modifiedUser],[Utility deviceToken],[Utility dbName]];
    NSLog(@"notedatastring: %@",noteDataString);
    NSLog(@"url: %@",url);
    
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate:self delegateQueue: [NSOperationQueue mainQueue]];
    

    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:nsURL];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[noteDataString dataUsingEncoding:NSUTF8StringEncoding]];
    [urlRequest setValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:urlRequest];
    
    [dataTask resume];
}

- (void)insertItems:(enum enumDB)currentDB withData:(NSObject *)data actionScreen:(NSString *)actionScreen
{
    propCurrentDB = currentDB;
    NSURL * url;
    NSString *noteDataString;
    switch (currentDB)
    {
        case dbDevice:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlDeviceInsert]];
        }
        break;
        case dbUserAccount:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlUserAccountInsert]];
        }
            break;
        case dbLogIn:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlLogInInsert]];
        }
        break;
        case dbTableTaking:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlTableTakingInsert]];
        }
        break;
        case dbOrderTaking:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlOrderTakingInsert]];
        }
        break;
        case dbOrderNote:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlOrderNoteInsert]];
        }
        break;
        case dbOrderKitchenList:
        {
            NSMutableArray *orderKitchenList = (NSMutableArray *)data;
            NSInteger countOrderKitchen = 0;
            
            noteDataString = [NSString stringWithFormat:@"countOrderKitchen=%ld",[orderKitchenList count]];
            for(OrderKitchen *item in orderKitchenList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countOrderKitchen]];
                countOrderKitchen++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlOrderKitchenInsertList]];
        }
        break;
        case dbMember:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlMemberInsert]];
        }
        break;
        default:
            break;
    }
    
    noteDataString = [NSString stringWithFormat:@"%@&modifiedDeviceToken=%@&modifiedUser=%@&dbName=%@&actionScreen=%@",noteDataString,[Utility deviceToken],[Utility modifiedUser],[Utility dbName],actionScreen];
    NSLog(@"url: %@",url);
    NSLog(@"notedatastring: %@",noteDataString);
    
    
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[noteDataString dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *dataRaw, NSURLResponse *header, NSError *error) {
   
        if(!error || (error && error.code == -1005))//-1005 คือ1. ตอน push notification ไม่ได้ และ2. ตอน enterbackground ตอน transaction ยังไม่เสร็จ พอ enter foreground มันจะไม่ return data มาให้
        {
            switch (propCurrentDB) {                
                
                default:
                {
                    if(!dataRaw)
                    {
                        //data parameter is nil
                        NSLog(@"Error: %@", [error debugDescription]);
                        return ;
                    }
                    
                    NSDictionary *json = [NSJSONSerialization
                                          JSONObjectWithData:dataRaw
                                          options:kNilOptions error:&error];
                    NSString *status = json[@"status"];
                    NSString *returnID = json[@"returnID"];
                    if([status isEqual:@"1"])
                    {
                        NSLog(@"insert success");
                        if(returnID)
                        {
                            if (self.delegate)
                            {
                                [self.delegate itemsInsertedWithReturnID:[returnID integerValue]];
                            }
                        }
                        else
                        {
                            [self.delegate itemsInserted];
                        }
                    }
                    else
                    {
                        //Error
                        NSLog(@"insert fail: %ld",currentDB);
                        NSLog(@"%@", status);
                        if (self.delegate)
                        {
//                            [self.delegate itemsFail];
                        }
                    }
                }
                    break;
            }
        }
        else
        {
            if (self.delegate)
            {
                [self.delegate itemsFail];
//                [self.delegate connectionFail];
            }
            
            NSLog(@"Error: %@", [error debugDescription]);
            NSLog(@"Error: %@", [error localizedDescription]);
        }
    }];
    
    [dataTask resume];
}

- (void)updateItems:(enum enumDB)currentDB withData:(NSObject *)data actionScreen:(NSString *)actionScreen
{
    propCurrentDB = currentDB;
    NSURL * url;
    NSString *noteDataString;
    
    switch (currentDB) {
        case dbCredentials:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlCredentialsValidate]];
        }
        break;
        case dbUserAccountDeviceToken:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlUserAccountDeviceTokenUpdate]];
        }
        break;
        case dbTableTaking:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlTableTakingUpdate]];
        }
        break;
        case dbPushSyncUpdateTimeSynced:
        {
            NSMutableArray *pushSyncList = (NSMutableArray *)data;
            NSInteger countPushSync = 0;
            
            noteDataString = [NSString stringWithFormat:@"countPushSync=%ld",[pushSyncList count]];
            for(PushSync *item in pushSyncList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countPushSync]];
                countPushSync++;
            }
            url = [NSURL URLWithString:[Utility url:urlPushSyncUpdateTimeSynced]];
        }
        break;
        case dbOrderTaking:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlOrderTakingUpdate]];
        }
        break;
        case dbOrderTakingList:
        {
            NSMutableArray *orderTakingList = (NSMutableArray *)data;
            NSInteger countOrderTaking = 0;
            
            noteDataString = [NSString stringWithFormat:@"countOrderTaking=%ld",[orderTakingList count]];
            for(OrderTaking *item in orderTakingList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countOrderTaking]];
                countOrderTaking++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlOrderTakingUpdateList]];
        }
        break;
        default:
        break;
    }
    
    
    noteDataString = [NSString stringWithFormat:@"%@&modifiedDeviceToken=%@&modifiedUser=%@&dbName=%@&actionScreen=%@",noteDataString,[Utility deviceToken],[Utility modifiedUser],[Utility dbName],actionScreen];
    NSLog(@"url: %@",url);
    NSLog(@"notedatastring: %@",noteDataString);
    
    
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[noteDataString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *dataRaw, NSURLResponse *header, NSError *error) {

        if(!error || (error && error.code == -1005))//-1005 คือตอน push notification ไม่ได้
        {
            if(!dataRaw)
            {
                //data parameter is nil
                NSLog(@"Error: %@", [error debugDescription]);
                return ;
            }
            
            NSDictionary *json = [NSJSONSerialization
                                  JSONObjectWithData:dataRaw
                                  options:kNilOptions error:&error];
            NSString *status = json[@"status"];
            if([status isEqual:@"1"])
            {
                NSLog(@"update success");
                if (self.delegate)
                {
                    [self.delegate itemsUpdated];
                }
            }
            else if([status isEqual:@"2"])
            {
                NSString *alert = json[@"alert"];
                if (self.delegate)
                {
                    [self.delegate itemsUpdated:alert];
                }
            }
            else
            {
                //Error
                NSLog(@"update fail");
                NSLog(@"%@", status);
                if (self.delegate)
                {
//                    [self.delegate itemsFail];
                }
            }
        }
        else
        {
            if (self.delegate)
            {
                [self.delegate itemsFail];
//                [self.delegate connectionFail];
            }
            NSLog(@"Error: %@", [error debugDescription]);
            NSLog(@"Error: %@", [error localizedDescription]);
        }
    }];
    
    [dataTask resume];
}

- (void)deleteItems:(enum enumDB)currentDB withData:(NSObject *)data actionScreen:(NSString *)actionScreen
{
    propCurrentDB = currentDB;
    NSURL * url;
    NSString *noteDataString;
    
    switch (currentDB) {
        case dbCredentials:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlCredentialsValidate]];
        }
        break;
        case dbUserAccountDeviceToken:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlUserAccountDeviceTokenUpdate]];
        }
        break;
        case dbTableTaking:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlTableTakingDelete]];
        }
        break;
        case dbOrderTaking:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlOrderTakingDelete]];
        }
        break;
        case dbOrderTakingList:
        {
            NSMutableArray *orderTakingList = (NSMutableArray *)data;
            NSInteger countOrderTaking = 0;
            
            noteDataString = [NSString stringWithFormat:@"countOrderTaking=%ld",[orderTakingList count]];
            for(OrderTaking *item in orderTakingList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countOrderTaking]];
                countOrderTaking++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlOrderTakingDeleteList]];
        }
        break;
        case dbOrderNote:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlOrderNoteDelete]];
        }
        break;
        case dbOrderNoteList:
        {
            NSMutableArray *orderNoteList = (NSMutableArray *)data;
            NSInteger countOrderNote = 0;
            
            noteDataString = [NSString stringWithFormat:@"countOrderNote=%ld",[orderNoteList count]];
            for(OrderNote *item in orderNoteList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countOrderNote]];
                countOrderNote++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlOrderNoteDeleteList]];
        }
        break;
        default:
        break;
    }
    
    noteDataString = [NSString stringWithFormat:@"%@&modifiedDeviceToken=%@&modifiedUser=%@&dbName=%@&actionScreen=%@",noteDataString,[Utility deviceToken],[Utility modifiedUser],[Utility dbName],actionScreen];
    NSLog(@"url: %@",url);
    NSLog(@"notedatastring: %@",noteDataString);
    
    
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[noteDataString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *dataRaw, NSURLResponse *header, NSError *error) {
        if(!error || (error && error.code == -1005))//-1005 คือตอน push notification ไม่ได้
        {
            if(!dataRaw)
            {
                //data parameter is nil
                NSLog(@"Error: %@", [error debugDescription]);
                return ;
            }
            
            NSDictionary *json = [NSJSONSerialization
                                  JSONObjectWithData:dataRaw
                                  options:kNilOptions error:&error];
            NSString *status = json[@"status"];
            if([status isEqual:@"1"])
            {
                NSLog(@"delete success");
            }
            else
            {
                //Error
                NSLog(@"delete fail");
                NSLog(@"%@", status);
                if (self.delegate)
                {
//                    [self.delegate itemsFail];
                }
            }
        }
        else
        {
            if (self.delegate)
            {
                [self.delegate itemsFail];
//                [self.delegate connectionFail];
            }
            NSLog(@"Error: %@", [error debugDescription]);
            NSLog(@"Error: %@", [error localizedDescription]);
        }
    }];
    
    [dataTask resume];
}
- (void)syncItems:(enum enumDB)currentDB withData:(NSObject *)data
{
    propCurrentDB = currentDB;
    NSURL * url;
    NSString *noteDataString;
    switch (currentDB) {
        case dbPushSync:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlPushSyncSync]];
        }
        break;
        default:
        break;
    }
    noteDataString = [NSString stringWithFormat:@"%@&modifiedUser=%@&modifiedDeviceToken=%@&dbName=%@",noteDataString,[Utility modifiedUser],[Utility deviceToken],[Utility dbName]];
    NSLog(@"notedatastring: %@",noteDataString);
    NSLog(@"url: %@",url);
    
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[noteDataString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *dataRaw, NSURLResponse *header, NSError *error) {

        if(!error || (error && error.code == -1005))
        {
            if(!dataRaw)
            {
                //data parameter is nil
                NSLog(@"Error: %@", [error debugDescription]);
                return ;
            }
            
            NSDictionary *json = [NSJSONSerialization
                                  JSONObjectWithData:dataRaw
                                  options:kNilOptions error:&error];
            NSString *status = json[@"status"];
            if([status isEqual:@"1"])
            {
                if (self.delegate)
                {
                    [self.delegate itemsSynced:json[@"payload"]];
                }
            }
            else if([status isEqual:@"0"])
            {
                NSLog(@"sync succes with no new row update");
                if (self.delegate)
                {
                    [self.delegate itemsSynced:[[NSArray alloc]init]];
                }
            }
            else
            {
                //Error
                NSLog(@"sync fail");
                NSLog([NSString stringWithFormat:@"status: %@",status]);
            }
        }
        else
        {
            NSLog(@"Error: %@", [error debugDescription]);
            NSLog(@"Error: %@", [error localizedDescription]);
        }
    }];
    
    [dataTask resume];
}

-(void)sendEmail:(NSString *)toAddress withSubject:(NSString *)subject andBody:(NSString *)body
{
    NSString *bodyPercentEscape = [Utility percentEscapeString:body];
    NSString *noteDataString = [NSString stringWithFormat:@"toAddress=%@&subject=%@&body=%@", toAddress,subject,bodyPercentEscape];
    noteDataString = [NSString stringWithFormat:@"%@&modifiedUser=%@&modifiedDeviceToken=%@&dbName=%@",noteDataString,[Utility modifiedUser],[Utility deviceToken],[Utility dbName]];
    
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL * url = [NSURL URLWithString:[Utility url:urlSendEmail]];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[noteDataString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *dataRaw, NSURLResponse *header, NSError *error) {

        if(!error || (error && error.code == -1005))
        {
            if(!dataRaw)
            {
                //data parameter is nil
                NSLog(@"Error: %@", [error debugDescription]);
                [self.delegate removeOverlayViewConnectionFail];
                return ;
            }
            
            NSDictionary *json = [NSJSONSerialization
                                  JSONObjectWithData:dataRaw
                                  options:kNilOptions error:&error];
            NSString *status = json[@"status"];
            if([status isEqual:@"1"])
            {

            }
            else
            {
                //Error
                NSLog(@"send email fail");
                NSLog(@"%@", status);
                if (self.delegate)
                {
//                    [self.delegate itemsFail];
                }
            }
        }
        else
        {
            if (self.delegate)
            {
                [self.delegate connectionFail];
            }
            NSLog(@"Error: %@", [error debugDescription]);
            NSLog(@"Error: %@", [error localizedDescription]);
        }
    }];
    
    [dataTask resume];
}

-(void)uploadPhoto:(NSData *)imageData fileName:(NSString *)fileName
{
    if (imageData != nil)
    {
        NSString *noteDataString = @"";
        noteDataString = [NSString stringWithFormat:@"%@&modifiedUser=%@&modifiedDeviceToken=%@&dbName=%@",noteDataString,[Utility modifiedUser],[Utility deviceToken],[Utility dbName]];
        
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
        
        NSURL * url = [NSURL URLWithString:[Utility url:urlUploadPhoto]];
        NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
        [urlRequest setHTTPMethod:@"POST"];
//        [urlRequest setHTTPBody:[noteDataString dataUsingEncoding:NSUTF8StringEncoding]];
        
    
        
        NSMutableData *body = [NSMutableData data];
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [urlRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        
        NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
        [_params setObject:[Utility modifiedUser] forKey:@"modifiedUser"];
        [_params setObject:[Utility deviceToken] forKey:@"modifiedDeviceToken"];
        [_params setObject:[Utility dbName] forKey:@"dbName"];
        for (NSString *param in _params)
        {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@.jpg\"\r\n",fileName] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imageData]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        [body appendData:[noteDataString dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        [urlRequest setHTTPBody:body];
        
        NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *dataRaw, NSURLResponse *header, NSError *error) {
            if(error && error.code != -1005)
            {
                if (self.delegate)
                {
                    [self.delegate connectionFail];
                }
                NSLog(@"Error: %@", [error debugDescription]);
                NSLog(@"Error: %@", [error localizedDescription]);
            }
        }];
        
        [dataTask resume];
    }
}

- (void)downloadImageWithFileName:(NSString *)fileName completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSString* escapeString = [Utility percentEscapeString:fileName];
    NSString *noteDataString = [NSString stringWithFormat:@"imageFileName=%@",escapeString];
    noteDataString = [NSString stringWithFormat:@"%@&modifiedUser=%@&modifiedDeviceToken=%@&dbName=%@",noteDataString,[Utility modifiedUser],[Utility deviceToken],[Utility dbName]];
    NSURL * url = [NSURL URLWithString:[Utility url:urlDownloadPhoto]];
    
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[noteDataString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *dataRaw, NSURLResponse *header, NSError *error) {
        if(error)
        {
            completionBlock(NO,nil);
        }
        else
        {
            NSDictionary *json = [NSJSONSerialization
                                  JSONObjectWithData:dataRaw
                                  options:kNilOptions error:&error];
            

            NSString *base64String = json[@"base64String"];
            if(json && base64String && ![base64String isEqualToString:@""])
            {
                NSData *nsDataEncrypted = [[NSData alloc] initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
                
                UIImage *image = [[UIImage alloc] initWithData:nsDataEncrypted];
                completionBlock(YES,image);
            }
            else
            {
                completionBlock(NO,nil);
            }            
        }
    }];
    
    [dataTask resume];
}
- (void)downloadFileWithFileName:(NSString *)fileName completionBlock:(void (^)(BOOL succeeded, NSData *data))completionBlock
{
    NSString* escapeString = [Utility percentEscapeString:fileName];
    NSString *noteDataString = [NSString stringWithFormat:@"fileName=%@",escapeString];
    noteDataString = [NSString stringWithFormat:@"%@&modifiedUser=%@&modifiedDeviceToken=%@&dbName=%@",noteDataString,[Utility modifiedUser],[Utility deviceToken],[Utility dbName]];
    NSURL * url = [NSURL URLWithString:[Utility url:urlDownloadFile]];
    
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[noteDataString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *dataRaw, NSURLResponse *header, NSError *error) {
        if(error != nil)
        {
            completionBlock(NO,nil);
        }
        else
        {
            NSDictionary *json = [NSJSONSerialization
                                  JSONObjectWithData:dataRaw
                                  options:kNilOptions error:&error];
            
            
            NSString *base64String = json[@"base64String"];
            if(json && base64String && ![base64String isEqualToString:@""])
            {
                NSData *nsDataEncrypted = [[NSData alloc] initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
                
                completionBlock(YES,nsDataEncrypted);
            }
            else
            {
                completionBlock(NO,nil);
            }
        }
    }];
    
    [dataTask resume];
}

@end
