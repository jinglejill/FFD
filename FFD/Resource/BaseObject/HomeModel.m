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
#import "TableTaking.h"
#import "OrderTaking.h"
#import "OrderNote.h"
#import "OrderKitchen.h"
#import "Receipt.h"
#import "Discount.h"
#import "Setting.h"
#import "RewardPoint.h"
#import "ReceiptCustomerTable.h"
#import "RewardProgram.h"
#import "SpecialPriceProgram.h"
#import "Menu.h"
#import "MenuType.h"
#import "MenuIngredient.h"
#import "IngredientType.h"
#import "Ingredient.h"
#import "SubMenuType.h"
#import "SubIngredientType.h"
#import "IngredientCheck.h"
#import "IngredientReceive.h"
#import "NoteType.h"
#import "Address.h"
#import "CustomerTable.h"
#import "Board.h"
#import "BillPrint.h"
#import "OrderCancelDiscount.h"
#import "Printer.h"
#import "RoleTabMenu.h"
#import "TabMenu.h"
#import "MoneyCheck.h"
#import "Branch.h"
#import "CredentialsDb.h"
#import "ReceiptPrint.h"
#import "Dispute.h"



@interface HomeModel()
{
    NSMutableData *_downloadedData;
    BOOL _downloadSuccess;
}
@end
@implementation HomeModel
@synthesize propCurrentDB;
@synthesize propCurrentDBInsert;
@synthesize propCurrentDBUpdate;


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
    NSArray *arrClassName;
    switch (propCurrentDB)
    {
        case dbMaster:
        case dbMasterWithProgressBar:
        {
            [_dataToDownload appendData:dataRaw];
            if(propCurrentDB == dbMasterWithProgressBar)
            {
                if(self.delegate)
                {
                    [self.delegate downloadProgress:[_dataToDownload length ]/_downloadSize];
                }
            }
            
            
            if([ _dataToDownload length ]/_downloadSize == 1.0f)
            {
                _downloadSuccess = YES;
                [self prepareData];
            }
        }
            break;
        case dbCredentialsDb:
        {
            arrClassName = @[@"CredentialsDb"];
        }
            break;
        case dbReceiptList:
        {
            arrClassName = @[@"Receipt",@"OrderTaking"];
        }
            break;
        case dbIngredientNeeded:
        {
            arrClassName = @[@"IngredientCheck",@"IngredientCheck",@"IngredientCheck",@"IngredientCheck",@"IngredientCheck"];
        }
            break;
        case dbIngredientReceiveList:
        {
            arrClassName = @[@"IngredientReceive",@"IngredientReceive"];
        }
            break;
        case dbIngredientCheckList:
        {
            arrClassName = @[@"IngredientCheck",@"IngredientCheck",@"IngredientCheck",@"IngredientCheck",@"IngredientCheck",@"IngredientCheck"];
        }
            break;
        case dbReportSalesAllDaily:
        {
            arrClassName = @[@"SalesDaily",@"SalesDaily",@"SalesDaily",@"SalesDaily"];
        }
            break;
        case dbReportSalesAllWeekly:
        {
            arrClassName = @[@"SalesWeekly"];
        }
            break;
        case dbReportSalesAllMonthly:
        {
            arrClassName = @[@"SalesMonthly"];
        }
            break;
        case dbReportSalesByMenuTypeDaily:
        {
            arrClassName = @[@"SalesDaily",@"SalesDaily",@"SalesDaily"];
        }
            break;
        case dbReportSalesByMenuTypeWeekly:
        {
            arrClassName = @[@"SalesDaily",@"SalesDaily",@"SalesDaily"];
        }
            break;
        case dbReportSalesByMenuTypeMonthly:
        {
            arrClassName = @[@"SalesDaily",@"SalesDaily",@"SalesDaily"];
        }
            break;
        case dbReportSalesByMenu:
        {
            arrClassName = @[@"SalesDaily"];
        }
            break;
        case dbReportSalesByMember:
        {
            arrClassName = @[@"SalesDaily"];
        }
            break;
        case dbReportOrderTransaction:
        {
            arrClassName = @[@"SalesTransaction"];
        }
            break;
        case dbReportEndDay:
        {
            arrClassName = @[@"ReportEndDay",@"ReportEndDay",@"ReportEndDay",@"ReportEndDay",@"ReportEndDay"];
        }
            break;
        case dbSpecialPriceProgram:
        {
            arrClassName = @[@"SpecialPriceProgram"];
        }
            break;
        case dbRewardProgram:
        {
            arrClassName = @[@"RewardProgram"];
        }
            break;
        case dbDiscount:
        {
            arrClassName = @[@"Discount"];
        }
            break;
        case dbBranch:
        {
            arrClassName = @[@"Branch"];
        }
            break;
        case dbReceiptSummary:
        {
            arrClassName = @[@"Receipt",@"OrderTaking",@"OrderNote",@"ReceiptPrint"];
        }
            break;
        case dbJummumReceipt:
        case dbJummumReceiptUpdate:
        {
            arrClassName = @[@"Receipt",@"OrderTaking",@"OrderNote",@"Dispute"];
        }
            break;
        case dbDisputeReasonList:
        {
            arrClassName = @[@"DisputeReason"];
        }
            break;
        default:
            break;
    }
    if(propCurrentDB != dbMaster && propCurrentDB != dbMasterWithProgressBar)
    {
        [_dataToDownload appendData:dataRaw];
        if([ _dataToDownload length ]/_downloadSize == 1.0f)
        {
            NSMutableArray *arrItem = [[NSMutableArray alloc] init];
            
            NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:_dataToDownload options:NSJSONReadingAllowFragments error:nil];
            
            
            for(int i=0; i<[jsonArray count]; i++)
            {
                //arrdatatemp <= arrdata
                NSMutableArray *arrDataTemp = [[NSMutableArray alloc]init];
                NSArray *arrData = jsonArray[i];
                for(int j=0; j< arrData.count; j++)
                {
                    NSDictionary *jsonElement = arrData[j];
                    NSObject *object = [[NSClassFromString([Utility getMasterClassName:i from:arrClassName]) alloc] init];
                    
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
                        
                        
                        if([Utility isDateColumn:dbColumnName])
                        {
                            NSDate *date = [Utility stringToDate:jsonElement[dbColumnName] fromFormat:@"yyyy-MM-dd HH:mm:ss"];
                            if(!date)
                            {
                                date = [Utility stringToDate:jsonElement[dbColumnName] fromFormat:@"yyyy-MM-dd"];
                            }
                            [object setValue:date forKey:key];
                        }
                        else
                        {
                            [object setValue:jsonElement[dbColumnName] forKey:key];
                        }
                    }
                    if(propCurrentDB == dbSpecialPriceProgram || propCurrentDB == dbRewardProgram || propCurrentDB == dbDiscount)
                    {
                        if(![Utility duplicate:object])
                        {
                            [arrDataTemp addObject:object];
                        }
                    }
                    else
                    {
                        [arrDataTemp addObject:object];
                    }
                }
                [arrItem addObject:arrDataTemp];
            }
            
            // Ready to notify delegate that data is ready and pass back items
            if (self.delegate)
            {
                [self.delegate itemsDownloaded:arrItem];
            }
        }
    }
}

-(void)prepareData
{
    NSLog(@"start prepare data");
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
                
                if([Utility isDateColumn:dbColumnName])
                {
                    NSDate *date = [Utility stringToDate:jsonElement[dbColumnName] fromFormat:@"yyyy-MM-dd HH:mm:ss"];
                    [object setValue:date forKey:key];
                }
                else
                {
                    [object setValue:jsonElement[dbColumnName] forKey:key];
                }
            }
            [arrDataTemp addObject:object];
        }
        [arrItem addObject:arrDataTemp];
    }
    NSLog(@"end prepare data");
    
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
    NSURL *url;
    NSString *noteDataString = @"";
    switch (currentDB)
    {
        case dbMaster:
        {
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlMasterGet]]];
        }
        break;
        case dbMasterWithProgressBar:
        {
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlMasterGet]]];
        }
        break;
        case dbDiscount:
        {
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlDiscountGetList]]];
        }
        break;
        default:
        break;
    }
    

    noteDataString = [NSString stringWithFormat:@"%@&modifiedDeviceToken=%@&modifiedUser=%@&dbName=%@",noteDataString,[Utility deviceToken],[Utility modifiedUser],[Utility dbName]];
    
    

    NSLog(@"url: %@",url);
    NSLog(@"notedatastring: %@",noteDataString);
    
    
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate:self delegateQueue: [NSOperationQueue mainQueue]];
    
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[noteDataString dataUsingEncoding:NSUTF8StringEncoding]];
    [urlRequest setValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:urlRequest];
    
    [dataTask resume];
}

- (void)downloadItems:(enum enumDB)currentDB withData:(NSObject *)data
{
    propCurrentDB = currentDB;
    NSURL *url;
    NSString *noteDataString = @"";
    switch (currentDB)
    {
        case dbCredentialsDb:
        {
            NSString *username = (NSString *)data;
            noteDataString = [NSString stringWithFormat:@"username=%@",username];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlCredentialsDbGet]]];
            
        }
        break;
        case dbReceiptList:
        {
            NSArray *dateCondition = (NSArray *)data;
            noteDataString = [NSString stringWithFormat:@"receiptStartDate=%@&receiptEndDate=%@",dateCondition[0],dateCondition[1]];
            
            
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlReceiptGetList]]];
        }
            break;
        case dbIngredientNeeded:
        {
            NSArray *dateCondition = (NSArray *)data;
            float expectedSale = [dateCondition[1] floatValue];
            noteDataString = [NSString stringWithFormat:@"date=%@&expectedSales=%f&salesConStartDate=%@&salesConEndDate=%@",dateCondition[0],expectedSale,dateCondition[2],dateCondition[3]];
            
            
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlIngredientNeededGetList]]];
        }
            break;
        case dbIngredientReceiveList:
        {
            NSArray *dateCondition = (NSArray *)data;
            noteDataString = [NSString stringWithFormat:@"historyStartDate=%@&historyEndDate=%@",dateCondition[0],dateCondition[1]];
            
            
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlIngredientReceiveGetList]]];
        }
            break;
        case dbIngredientCheckList:
        {
            NSArray *dateCondition = (NSArray *)data;
            noteDataString = [NSString stringWithFormat:@"startDate=%@&endDate=%@",dateCondition[0],dateCondition[1]];
            
            
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlIngredientCheckGetList]]];
        }
            break;
        case dbReportSalesAllDaily:
        {
            NSArray *dateCondition = (NSArray *)data;
            noteDataString = [NSString stringWithFormat:@"startDate=%@&endDate=%@",dateCondition[0],dateCondition[1]];
            
            
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlReportSalesAllDailyGetList]]];
        }
            break;
        case dbReportSalesAllWeekly:
        {
            NSArray *dateCondition = (NSArray *)data;
            noteDataString = [NSString stringWithFormat:@"startDate=%@&endDate=%@",dateCondition[0],dateCondition[1]];
            
            
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlReportSalesAllWeeklyGetList]]];
        }
            break;
        case dbReportSalesAllMonthly:
        {
            NSArray *dateCondition = (NSArray *)data;
            noteDataString = [NSString stringWithFormat:@"startDate=%@&endDate=%@",dateCondition[0],dateCondition[1]];
            
            
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlReportSalesAllMonthlyGetList]]];
        }
            break;
        case dbReportSalesByMenuTypeDaily:
        {
            NSArray *dateCondition = (NSArray *)data;
            noteDataString = [NSString stringWithFormat:@"startDate=%@&endDate=%@",dateCondition[0],dateCondition[1]];
            
            
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlReportSalesByMenuTypeDailyGetList]]];
        }
            break;
        case dbReportSalesByMenuTypeWeekly:
        {
            NSArray *dateCondition = (NSArray *)data;
            noteDataString = [NSString stringWithFormat:@"startDate=%@&endDate=%@",dateCondition[0],dateCondition[1]];
            
            
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlReportSalesByMenuTypeWeeklyGetList]]];
        }
            break;
        case dbReportSalesByMenuTypeMonthly:
        {
            NSArray *dateCondition = (NSArray *)data;
            noteDataString = [NSString stringWithFormat:@"startDate=%@&endDate=%@",dateCondition[0],dateCondition[1]];
            
            
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlReportSalesByMenuTypeMonthlyGetList]]];
        }
            break;
        case dbReportSalesByMenu:
        {
            NSArray *dateCondition = (NSArray *)data;
            noteDataString = [NSString stringWithFormat:@"startDate=%@&endDate=%@",dateCondition[0],dateCondition[1]];
            
            
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlReportSalesByMenuGetList]]];
        }
            break;
        case dbReportSalesByMember:
        {
            NSArray *dateCondition = (NSArray *)data;
            noteDataString = [NSString stringWithFormat:@"startDate=%@&endDate=%@",dateCondition[0],dateCondition[1]];
            
            
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlReportSalesByMemberGetList]]];
        }
            break;
        case dbReportOrderTransaction:
        {
            NSArray *dateCondition = (NSArray *)data;
            noteDataString = [NSString stringWithFormat:@"startDate=%@&endDate=%@",dateCondition[0],dateCondition[1]];
            
            
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlReportSalesTransactionGetList]]];
        }
            break;
        case dbReportEndDay:
        {
            NSArray *dateCondition = (NSArray *)data;
            noteDataString = [NSString stringWithFormat:@"endDate=%@",dateCondition[0]];
            
            
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlReportSalesEndDayGetList]]];
        }
            break;
        case dbSpecialPriceProgram:
        {
            NSArray *dateCondition = (NSArray *)data;
            noteDataString = [NSString stringWithFormat:@"startDate=%@&endDate=%@",dateCondition[0],dateCondition[1]];
            
            
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlSpecialPriceProgramGetList]]];
        }
            break;
        case dbRewardProgram:
        {
            NSArray *dateCondition = (NSArray *)data;
            noteDataString = [NSString stringWithFormat:@"startDate=%@&endDate=%@",dateCondition[0],dateCondition[1]];
            
            
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlRewardProgramGetList]]];
        }
            break;
        case dbBranch:
        {
            NSString *username = (NSString *)data;
            noteDataString = [NSString stringWithFormat:@"username=%@",username];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlBranchGet]]];
        }
            break;
        case dbReceiptSummary:
        {
            NSArray *dataList = (NSArray *)data;
            Receipt *receipt = dataList[0];
            CredentialsDb *credentialDb = dataList[1];
            NSString *strReceiptDate = [Utility dateToString:receipt.receiptDate toFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            
            noteDataString = [NSString stringWithFormat:@"receiptDate=%@&receiptID=%ld&branchID=%ld&status=%ld",strReceiptDate,receipt.receiptID,credentialDb.branchID,receipt.status];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlReceiptSummaryGetList]]];
            
        }
            break;
        case dbJummumReceipt:
        case dbJummumReceiptUpdate:
        {
            NSNumber *receiptID = (NSNumber *)data;
            
            noteDataString = [NSString stringWithFormat:@"receiptID=%ld&branchID=%ld",[receiptID integerValue],[Utility branchID]];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlJummumReceiptGetList]]];
        }
            break;
        case dbDisputeReasonList:
        {
            NSNumber *objType = (NSNumber *)data;
            noteDataString = [NSString stringWithFormat:@"type=%ld",[objType integerValue]];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlDisputeReasonGetList]]];
        }
        break;
        default:
            break;
    }
    noteDataString = [NSString stringWithFormat:@"%@&modifiedDeviceToken=%@&modifiedUser=%@&dbName=%@",noteDataString,[Utility deviceToken],[Utility modifiedUser],[Utility dbName]];
    NSLog(@"url: %@",url);
    NSLog(@"notedatastring: %@",noteDataString);
    
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate:self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[noteDataString dataUsingEncoding:NSUTF8StringEncoding]];
    [urlRequest setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:urlRequest];
    [dataTask resume];
}

- (void)insertItems:(enum enumDB)currentDB withData:(NSObject *)data actionScreen:(NSString *)actionScreen
{
    propCurrentDBInsert = currentDB;
    NSURL * url;
    NSString *noteDataString;
    switch (currentDB)
    {
        case dbCredentials:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlCredentialsValidate]];
        }
            break;
        case dbWriteLog:
        {
            noteDataString = [NSString stringWithFormat:@"stackTrace=%@",(NSString *)data];
            url = [NSURL URLWithString:[Utility url:urlWriteLog]];
        }
            break;
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
        case dbTableTakingInsertUpdate:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlTableTakingInsertUpdate]];
        }
            break;
        case dbTableTakingList:
        {
            NSMutableArray *tableTakingList = (NSMutableArray *)data;
            NSInteger countTableTaking = 0;
            
            noteDataString = [NSString stringWithFormat:@"countTableTaking=%ld",[tableTakingList count]];
            for(TableTaking *item in tableTakingList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countTableTaking]];
                countTableTaking++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlTableTakingInsertList]];
        }
            break;
        case dbOrderTaking:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlOrderTakingInsert]];
        }
            break;
        case dbOrderTakingInsertUpdate:
        {
            NSArray *orderTakingList = (NSArray *)data;
            OrderTaking *cancelOrderTaking = orderTakingList[0];
            OrderTaking *orderTaking = orderTakingList[1];
            
            
            noteDataString = [Utility getNoteDataString:cancelOrderTaking withPrefix:@"cc"];
            noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:orderTaking]];
            url = [NSURL URLWithString:[Utility url:urlOrderTakingInsertUpdate]];
        }
            break;
        case dbOrderNote:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlOrderNoteInsert]];
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
            
            url = [NSURL URLWithString:[Utility url:urlOrderNoteInsertList]];
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
        case dbAddress:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlAddressInsert]];
        }
            break;
        case dbReceipt:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlReceiptInsert]];
        }
            break;
        case dbReceiptList:
        {
            NSMutableArray *receiptList = (NSMutableArray *)data;
            NSInteger countReceipt = 0;
            
            noteDataString = [NSString stringWithFormat:@"countReceipt=%ld",[receiptList count]];
            for(Receipt *item in receiptList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countReceipt]];
                countReceipt++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlReceiptInsertList]];
        }
            break;
        case dbReceiptAndReceiptNoTaxPrint:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlReceiptAndReceiptNoTaxPrintInsert]];
        }
            break;
        case dbDiscount:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlDiscountInsert]];
        }
            break;
        case dbDiscountList:
        {
            NSMutableArray *discountList = (NSMutableArray *)data;
            NSInteger countDiscount = 0;
            
            noteDataString = [NSString stringWithFormat:@"countDiscount=%ld",[discountList count]];
            for(Discount *item in discountList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countDiscount]];
                countDiscount++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlDiscountInsertList]];
        }
            break;
        case dbRewardPoint:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlRewardPointInsert]];
        }
            break;
        case dbRewardPointList:
        {
            NSMutableArray *rewardPointList = (NSMutableArray *)data;
            NSInteger countRewardPoint = 0;
            
            noteDataString = [NSString stringWithFormat:@"countRewardPoint=%ld",[rewardPointList count]];
            for(RewardPoint *item in rewardPointList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countRewardPoint]];
                countRewardPoint++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlRewardPointInsertList]];
        }
            break;
        case dbReceiptCustomerTable:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlReceiptCustomerTableInsert]];
        }
            break;
        case dbReceiptCustomerTableList:
        {
            NSMutableArray *receiptCustomerTableList = (NSMutableArray *)data;
            NSInteger countReceiptCustomerTable = 0;
            
            noteDataString = [NSString stringWithFormat:@"countReceiptCustomerTable=%ld",[receiptCustomerTableList count]];
            for(ReceiptCustomerTable *item in receiptCustomerTableList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countReceiptCustomerTable]];
                countReceiptCustomerTable++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlReceiptCustomerTableInsertList]];
        }
            break;
        case dbRewardProgram:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlRewardProgramInsert]];
        }
            break;
        case dbRewardProgramList:
        {
            NSMutableArray *rewardProgramList = (NSMutableArray *)data;
            NSInteger countRewardProgram = 0;
            
            noteDataString = [NSString stringWithFormat:@"countRewardProgram=%ld",[rewardProgramList count]];
            for(RewardProgram *item in rewardProgramList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countRewardProgram]];
                countRewardProgram++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlRewardProgramInsertList]];
        }
            break;
        case dbSpecialPriceProgram:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlSpecialPriceProgramInsert]];
        }
            break;
        case dbSpecialPriceProgramList:
        {
            NSMutableArray *specialPriceProgramList = (NSMutableArray *)data;
            NSInteger countSpecialPriceProgram = 0;
            
            noteDataString = [NSString stringWithFormat:@"countSpecialPriceProgram=%ld",[specialPriceProgramList count]];
            for(SpecialPriceProgram *item in specialPriceProgramList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countSpecialPriceProgram]];
                countSpecialPriceProgram++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlSpecialPriceProgramInsertList]];
        }
            break;
        case dbMenu:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlMenuInsert]];
        }
            break;
        case dbMenuList:
        {
            NSMutableArray *menuList = (NSMutableArray *)data;
            NSInteger countMenu = 0;
            
            noteDataString = [NSString stringWithFormat:@"countMenu=%ld",[menuList count]];
            for(Menu *item in menuList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countMenu]];
                countMenu++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlMenuInsertList]];
        }
            break;
        case dbMenuType:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlMenuTypeInsert]];
        }
            break;
        case dbMenuTypeList:
        {
            NSMutableArray *menuTypeList = (NSMutableArray *)data;
            NSInteger countMenuType = 0;
            
            noteDataString = [NSString stringWithFormat:@"countMenuType=%ld",[menuTypeList count]];
            for(MenuType *item in menuTypeList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countMenuType]];
                countMenuType++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlMenuTypeInsertList]];
        }
            break;
        case dbMenuIngredient:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlMenuIngredientInsert]];
        }
            break;
        case dbMenuIngredientList:
        {
            NSMutableArray *menuIngredientList = (NSMutableArray *)data;
            NSInteger countMenuIngredient = 0;
            
            noteDataString = [NSString stringWithFormat:@"countMenuIngredient=%ld",[menuIngredientList count]];
            for(MenuIngredient *item in menuIngredientList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countMenuIngredient]];
                countMenuIngredient++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlMenuIngredientInsertList]];
        }
            break;
        case dbIngredientType:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlIngredientTypeInsert]];
        }
            break;
        case dbIngredientTypeList:
        {
            NSMutableArray *ingredientTypeList = (NSMutableArray *)data;
            NSInteger countIngredientType = 0;
            
            noteDataString = [NSString stringWithFormat:@"countIngredientType=%ld",[ingredientTypeList count]];
            for(IngredientType *item in ingredientTypeList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countIngredientType]];
                countIngredientType++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlIngredientTypeInsertList]];
        }
            break;
        case dbIngredient:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlIngredientInsert]];
        }
            break;
        case dbIngredientList:
        {
            NSMutableArray *ingredientList = (NSMutableArray *)data;
            NSInteger countIngredient = 0;
            
            noteDataString = [NSString stringWithFormat:@"countIngredient=%ld",[ingredientList count]];
            for(Ingredient *item in ingredientList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countIngredient]];
                countIngredient++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlIngredientInsertList]];
        }
            break;
        case dbSubMenuType:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlSubMenuTypeInsert]];
        }
            break;
        case dbSubMenuTypeList:
        {
            NSMutableArray *subMenuTypeList = (NSMutableArray *)data;
            NSInteger countSubMenuType = 0;
            
            noteDataString = [NSString stringWithFormat:@"countSubMenuType=%ld",[subMenuTypeList count]];
            for(SubMenuType *item in subMenuTypeList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countSubMenuType]];
                countSubMenuType++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlSubMenuTypeInsertList]];
        }
            break;
        case dbSubMenuTypeAndMenu:
        {
            NSArray *subMenuTypeAndMenu = (NSArray *)data;
            SubMenuType *subMenuType = (SubMenuType *)subMenuTypeAndMenu[0];
            Menu *menu = (Menu *)subMenuTypeAndMenu[1];
            
            
            NSString *noteDataStringSubMenuType = [Utility getNoteDataString:subMenuType withPrefix:@"sMT"];
            noteDataString = [Utility getNoteDataString:menu];
            noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataStringSubMenuType,noteDataString];
            
            
            url = [NSURL URLWithString:[Utility url:urlSubMenuTypeAndMenuInsert]];
        }
        case dbSubIngredientType:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlSubIngredientTypeInsert]];
        }
            break;
        case dbSubIngredientTypeList:
        {
            NSMutableArray *subIngredientTypeList = (NSMutableArray *)data;
            NSInteger countSubIngredientType = 0;
            
            noteDataString = [NSString stringWithFormat:@"countSubIngredientType=%ld",[subIngredientTypeList count]];
            for(SubIngredientType *item in subIngredientTypeList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countSubIngredientType]];
                countSubIngredientType++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlSubIngredientTypeInsertList]];
        }
            break;
        case dbSubIngredientTypeAndIngredient:
        {
            NSArray *subIngredientTypeAndIngredient = (NSArray *)data;
            SubIngredientType *subIngredientType = (SubIngredientType *)subIngredientTypeAndIngredient[0];
            Ingredient *ingredient = (Ingredient *)subIngredientTypeAndIngredient[1];
            
            
            NSString *noteDataStringSubIngredientType = [Utility getNoteDataString:subIngredientType withPrefix:@"sIT"];
            noteDataString = [Utility getNoteDataString:ingredient];
            noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataStringSubIngredientType,noteDataString];
            
            
            url = [NSURL URLWithString:[Utility url:urlSubIngredientTypeAndIngredientInsert]];
        }
            break;
        case dbIngredientCheck:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlIngredientCheckInsert]];
        }
            break;
        case dbIngredientCheckList:
        {
            NSArray *arrData = (NSArray *)data;
            
            NSMutableArray *ingredientCheckList = (NSMutableArray *)arrData[0];
            NSInteger countIngredientCheck = 0;
            NSDate *startDate = arrData[1];
            NSDate *endDate = arrData[2];
            
            
            noteDataString = [NSString stringWithFormat:@"startDate=%@&endDate=%@&countIngredientCheck=%ld",startDate,endDate,[ingredientCheckList count]];
            for(IngredientCheck *item in ingredientCheckList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo3Digit:countIngredientCheck]];
                countIngredientCheck++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlIngredientCheckInsertList]];
        }
            break;
        case dbIngredientReceive:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlIngredientReceiveInsert]];
        }
            break;
        case dbIngredientReceiveList:
        {
            NSArray *arrData = (NSArray *)data;
            
            NSMutableArray *ingredientReceiveList = (NSMutableArray *)arrData[0];
            NSInteger countIngredientReceive = 0;
            NSDate *historyStartDate = arrData[1];
            NSDate *historyEndDate = arrData[2];
            
            
            noteDataString = [NSString stringWithFormat:@"historyStartDate=%@&historyEndDate=%@&countIngredientReceive=%ld",historyStartDate,historyEndDate,[ingredientReceiveList count]];
            for(IngredientReceive *item in ingredientReceiveList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo3Digit:countIngredientReceive]];
                countIngredientReceive++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlIngredientReceiveInsertList]];
        }
            break;
        case dbOrderTakingOrderNoteOrderKitchenReceipt:
        {
            NSArray *dataList = (NSArray *)data;
            NSMutableArray *orderTakingList = dataList[0];
            NSMutableArray *orderNoteList = dataList[1];
            NSMutableArray *orderKitchenList = dataList[2];
            NSMutableArray *receiptList = dataList[3];
            NSInteger countOrderTaking = 0;
            NSInteger countOrderNote = 0;
            NSInteger countOrderKitchen = 0;
            NSInteger countReceipt = 0;
            
            
            
            for(OrderTaking *item in orderTakingList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countOrderTaking]];
                countOrderTaking++;
            }
            for(OrderNote *item in orderNoteList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"on" runningNo:countOrderNote]];
                countOrderNote++;
            }
            for(OrderKitchen *item in orderKitchenList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"ok" runningNo:countOrderKitchen]];
                countOrderKitchen++;
            }
            for(Receipt *item in receiptList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"rt" runningNo:countReceipt]];
                countReceipt++;
            }
            noteDataString = [NSString stringWithFormat:@"%@&countOrderTaking=%ld&countOrderNote=%ld&countOrderKitchen=%ld&countReceipt=%ld",noteDataString,countOrderTaking,countOrderNote,countOrderKitchen,countReceipt];
            
            
            
            
            url = [NSURL URLWithString:[Utility url:urlOrderTakingOrderNoteOrderKitchenReceiptInsertList]];
        }
            break;
        case dbOrderTakingOrderNoteOrderKitchenReceiptAndReceiptNo:
        {
            NSArray *dataList = (NSArray *)data;
            NSMutableArray *orderTakingList = dataList[0];
            NSMutableArray *orderNoteList = dataList[1];
            NSMutableArray *orderKitchenList = dataList[2];
            NSMutableArray *receiptList = dataList[3];
            NSInteger countOrderTaking = 0;
            NSInteger countOrderNote = 0;
            NSInteger countOrderKitchen = 0;
            NSInteger countReceipt = 0;
            
            
            
            for(OrderTaking *item in orderTakingList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countOrderTaking]];
                countOrderTaking++;
            }
            for(OrderNote *item in orderNoteList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"on" runningNo:countOrderNote]];
                countOrderNote++;
            }
            for(OrderKitchen *item in orderKitchenList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"ok" runningNo:countOrderKitchen]];
                countOrderKitchen++;
            }
            for(Receipt *item in receiptList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"rt" runningNo:countReceipt]];
                countReceipt++;
            }
            noteDataString = [NSString stringWithFormat:@"%@&countOrderTaking=%ld&countOrderNote=%ld&countOrderKitchen=%ld&countReceipt=%ld",noteDataString,countOrderTaking,countOrderNote,countOrderKitchen,countReceipt];
            
            
            
            
            url = [NSURL URLWithString:[Utility url:urlOrderTakingOrderNoteOrderKitchenReceiptAndReceiptNoInsertList]];
        }
            break;
        case dbOrderTakingOrderNoteOrderKitchenCustomerTable:
        {
            NSArray *dataList = (NSArray *)data;
            NSMutableArray *orderTakingList = dataList[0];
            NSMutableArray *orderNoteList = dataList[1];
            NSMutableArray *orderKitchenList = dataList[2];
            CustomerTable *customerTable = dataList[3];
            NSInteger countOrderTaking = 0;
            NSInteger countOrderNote = 0;
            NSInteger countOrderKitchen = 0;
            
            
            
            for(OrderTaking *item in orderTakingList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countOrderTaking]];
                countOrderTaking++;
            }
            for(OrderNote *item in orderNoteList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"oN" runningNo:countOrderNote]];
                countOrderNote++;
            }
            for(OrderKitchen *item in orderKitchenList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"oK" runningNo:countOrderKitchen]];
                countOrderKitchen++;
            }
            noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:customerTable withPrefix:@"ct"]];
            noteDataString = [NSString stringWithFormat:@"%@&countOrderTaking=%ld&countOrderNote=%ld&countOrderKitchen=%ld",noteDataString,countOrderTaking,countOrderNote,countOrderKitchen];
            
            
            url = [NSURL URLWithString:[Utility url:urlOrderTakingOrderNoteOrderKitchenCustomerTableInsertList]];
        }
            break;
        case dbNoteType:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlNoteTypeInsert]];
        }
            break;
        case dbNoteTypeList:
        {
            NSMutableArray *noteTypeList = (NSMutableArray *)data;
            NSInteger countNoteType = 0;
            
            noteDataString = [NSString stringWithFormat:@"countNoteType=%ld",[noteTypeList count]];
            for(NoteType *item in noteTypeList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countNoteType]];
                countNoteType++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlNoteTypeInsertList]];
        }
            break;
        case dbBoard:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlBoardInsert]];
        }
            break;
        case dbBoardList:
        {
            NSMutableArray *boardList = (NSMutableArray *)data;
            NSInteger countBoard = 0;
            
            noteDataString = [NSString stringWithFormat:@"countBoard=%ld",[boardList count]];
            for(Board *item in boardList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countBoard]];
                countBoard++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlBoardInsertList]];
        }
            break;
        case dbMergeReceiptCloseTable:
        {
            NSArray *dataList = (NSArray *)data;
            NSMutableArray *billPrintList = dataList[0];
            NSMutableArray *rewardPointList = dataList[1];
            NSMutableArray *receiptCustomerTableList = dataList[2];
            NSMutableArray *tableTakingList = dataList[3];
            NSMutableArray *orderTakingList = dataList[4];
            NSMutableArray *receiptList = dataList[5];
            Receipt *mergeReceipt = dataList[6];
            
            
            NSInteger countBillPrint = 0;
            NSInteger countRewardPoint = 0;
            NSInteger countReceiptCustomerTable = 0;
            NSInteger countTableTaking = 0;
            NSInteger countOrderTaking = 0;
            NSInteger countReceipt = 0;
            
            noteDataString = [NSString stringWithFormat:@"countBillPrint=%ld&countRewardPoint=%ld&countReceiptCustomerTable=%ld&countTableTaking=%ld&countOrderTaking=%ld&countReceipt=%ld",[billPrintList count],[rewardPointList count],[receiptCustomerTableList count],[tableTakingList count],[orderTakingList count],[receiptList count]];
            for(BillPrint *item in billPrintList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"bp" runningNo:countBillPrint]];
                countBillPrint++;
            }
            for(RewardPoint *item in rewardPointList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"rp" runningNo:countRewardPoint]];
                countRewardPoint++;
            }
            for(ReceiptCustomerTable *item in receiptCustomerTableList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"rc" runningNo:countReceiptCustomerTable]];
                countReceiptCustomerTable++;
            }
            for(TableTaking *item in tableTakingList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"tt" runningNo:countTableTaking]];
                countTableTaking++;
            }
            for(OrderTaking *item in orderTakingList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"ot" runningNo:countOrderTaking]];
                countOrderTaking++;
            }
            for(Receipt *item in receiptList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"rt" runningNo:countReceipt]];
                countReceipt++;
            }
            noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:mergeReceipt]];
            
            
            url = [NSURL URLWithString:[Utility url:urlMergeReceiptCloseTableInsert]];
        }
            break;
        case dbBillPrint:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlBillPrintInsert]];
        }
            break;
        case dbBillPrintList:
        {
            NSMutableArray *billPrintList = (NSMutableArray *)data;
            NSInteger countBillPrint = 0;
            
            noteDataString = [NSString stringWithFormat:@"countBillPrint=%ld",[billPrintList count]];
            for(BillPrint *item in billPrintList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countBillPrint]];
                countBillPrint++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlBillPrintInsertList]];
        }
            break;
        case dbPaySplitBillInsert:
        {
            //@[inDbOrderTakingList,inDbOrderNoteList,inDbOrderKitchenList,splitOrderTakingList,splitOrderNoteList,splitOrderKitchenList, billPrintList, rewardPointList,tableTakingList,_usingReceipt,_receipt];
            NSArray *dataList = (NSArray *)data;
            NSMutableArray *inDbOrderTakingList = dataList[0];
            NSMutableArray *inDbOrderNoteList = dataList[1];
            NSMutableArray *inDbOrderKitchenList = dataList[2];
            NSMutableArray *splitOrderTakingList = dataList[3];
            NSMutableArray *splitOrderNoteList = dataList[4];
            NSMutableArray *splitOrderKitchenList = dataList[5];
            NSMutableArray *billPrintList = dataList[6];
            NSMutableArray *rewardPointList = dataList[7];
            Receipt *receipt = dataList[8];
            Receipt *tableReceipt = dataList[9];
            
            
            NSInteger countDotOrderTaking = 0;
            NSInteger countDonOrderNote = 0;
            NSInteger countDokOrderKitchen = 0;
            NSInteger countSotOrderTaking = 0;
            NSInteger countSonOrderNote = 0;
            NSInteger countSokOrderKitchen = 0;
            NSInteger countBillPrint = 0;
            NSInteger countRewardPoint = 0;
            
            
            
            
            noteDataString = [NSString stringWithFormat:@"countDotOrderTaking=%ld&countDonOrderNote=%ld&countDokOrderKitchen=%ld&countSotOrderTaking=%ld&countSonOrderNote=%ld&countSokOrderKitchen=%ld&countBillPrint=%ld&countRewardPoint=%ld",[inDbOrderTakingList count],[inDbOrderNoteList count],[inDbOrderKitchenList count],[splitOrderTakingList count],[splitOrderNoteList count],[splitOrderKitchenList count],[billPrintList count],[rewardPointList count]];
            for(OrderTaking *item in inDbOrderTakingList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"dot" runningNo:countDotOrderTaking]];
                countDotOrderTaking++;
            }
            for(OrderNote *item in inDbOrderNoteList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"don" runningNo:countDonOrderNote]];
                countDonOrderNote++;
            }
            for(OrderKitchen *item in inDbOrderKitchenList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"dok" runningNo:countDokOrderKitchen]];
                countDokOrderKitchen++;
            }
            for(OrderTaking *item in splitOrderTakingList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"sot" runningNo:countSotOrderTaking]];
                countSotOrderTaking++;
            }
            for(OrderNote *item in splitOrderNoteList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"son" runningNo:countSonOrderNote]];
                countSonOrderNote++;
            }
            for(OrderKitchen *item in splitOrderKitchenList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"sok" runningNo:countSokOrderKitchen]];
                countSokOrderKitchen++;
            }
            for(BillPrint *item in billPrintList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"bp" runningNo:countBillPrint]];
                countBillPrint++;
            }
            for(RewardPoint *item in rewardPointList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"rp" runningNo:countRewardPoint]];
                countRewardPoint++;
            }
            noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:receipt]];
            noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:tableReceipt withPrefix:@"tr"]];
            
            
            url = [NSURL URLWithString:[Utility url:urlPaySplitBillInsert]];
        }
            break;
        case dbPaySplitBillInsertWithoutReceipt:
        {
            //@[inDbOrderTakingList,inDbOrderNoteList,inDbOrderKitchenList,splitOrderTakingList,splitOrderNoteList,splitOrderKitchenList, billPrintList, rewardPointList,tableTakingList,_usingReceipt];
            NSArray *dataList = (NSArray *)data;
            NSMutableArray *inDbOrderTakingList = dataList[0];
            NSMutableArray *inDbOrderNoteList = dataList[1];
            NSMutableArray *inDbOrderKitchenList = dataList[2];
            NSMutableArray *splitOrderTakingList = dataList[3];
            NSMutableArray *splitOrderNoteList = dataList[4];
            NSMutableArray *splitOrderKitchenList = dataList[5];
            NSMutableArray *billPrintList = dataList[6];
            NSMutableArray *rewardPointList = dataList[7];
            Receipt *receipt = dataList[8];
            
            
            
            NSInteger countDotOrderTaking = 0;
            NSInteger countDonOrderNote = 0;
            NSInteger countDokOrderKitchen = 0;
            NSInteger countSotOrderTaking = 0;
            NSInteger countSonOrderNote = 0;
            NSInteger countSokOrderKitchen = 0;
            NSInteger countBillPrint = 0;
            NSInteger countRewardPoint = 0;
            
            
            
            
            noteDataString = [NSString stringWithFormat:@"countDotOrderTaking=%ld&countDonOrderNote=%ld&countDokOrderKitchen=%ld&countSotOrderTaking=%ld&countSonOrderNote=%ld&countSokOrderKitchen=%ld&countBillPrint=%ld&countRewardPoint=%ld",[inDbOrderTakingList count],[inDbOrderNoteList count],[inDbOrderKitchenList count],[splitOrderTakingList count],[splitOrderNoteList count],[splitOrderKitchenList count],[billPrintList count],[rewardPointList count]];
            for(OrderTaking *item in inDbOrderTakingList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"dot" runningNo:countDotOrderTaking]];
                countDotOrderTaking++;
            }
            for(OrderNote *item in inDbOrderNoteList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"don" runningNo:countDonOrderNote]];
                countDonOrderNote++;
            }
            for(OrderKitchen *item in inDbOrderKitchenList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"dok" runningNo:countDokOrderKitchen]];
                countDokOrderKitchen++;
            }
            for(OrderTaking *item in splitOrderTakingList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"sot" runningNo:countSotOrderTaking]];
                countSotOrderTaking++;
            }
            for(OrderNote *item in splitOrderNoteList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"son" runningNo:countSonOrderNote]];
                countSonOrderNote++;
            }
            for(OrderKitchen *item in splitOrderKitchenList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"sok" runningNo:countSokOrderKitchen]];
                countSokOrderKitchen++;
            }
            for(BillPrint *item in billPrintList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"bp" runningNo:countBillPrint]];
                countBillPrint++;
            }
            for(RewardPoint *item in rewardPointList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"rp" runningNo:countRewardPoint]];
                countRewardPoint++;
            }
            noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:receipt]];
            
            
            
            url = [NSURL URLWithString:[Utility url:urlPaySplitBillInsertWithoutReceipt]];
        }
            break;
        case dbPaySplitBillInsertAfterFirstTime:
        {
            //            @[rewardPointList,tableTakingList,inDbOrderTakingList,_receipt];
            NSArray *dataList = (NSArray *)data;
            NSMutableArray *billPrintList = dataList[0];
            NSMutableArray *rewardPointList = dataList[1];
            NSMutableArray *orderTakingList = dataList[2];
            Receipt *receipt = dataList[3];
            Receipt *tableReceipt = dataList[4];
            
            NSInteger countBillPrint = 0;
            NSInteger countRewardPoint = 0;
            NSInteger countOrderTaking = 0;
            
            
            noteDataString = [NSString stringWithFormat:@"countBillPrint=%ld&countRewardPoint=%ld&countOrderTaking=%ld",[billPrintList count],[rewardPointList count],[orderTakingList count]];
            for(BillPrint *item in billPrintList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"bp" runningNo:countBillPrint]];
                countBillPrint++;
            }
            for(RewardPoint *item in rewardPointList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"rp" runningNo:countRewardPoint]];
                countRewardPoint++;
            }
            for(OrderTaking *item in orderTakingList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"ot" runningNo:countOrderTaking]];
                countOrderTaking++;
            }
            noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:receipt]];
            noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:tableReceipt withPrefix:@"tr"]];
            
            
            
            url = [NSURL URLWithString:[Utility url:urlPaySplitBillInsertAfterFirstTime]];
        }
            break;
        case dbPaySplitBillInsertLastOne:
        {
            //            @[rewardPointList,tableTakingList,inDbOrderTakingList];
            NSArray *dataList = (NSArray *)data;
            NSMutableArray *billPrintList = dataList[0];
            NSMutableArray *rewardPointList = dataList[1];
            NSMutableArray *orderTakingList = dataList[2];
            Receipt *receipt = dataList[3];
            
            
            NSInteger countBillPrint = 0;
            NSInteger countRewardPoint = 0;
            NSInteger countOrderTaking = 0;
            
            
            noteDataString = [NSString stringWithFormat:@"countBillPrint=%ld&countRewardPoint=%ld&countOrderTaking=%ld",[billPrintList count],[rewardPointList count],[orderTakingList count]];
            for(BillPrint *item in billPrintList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"bp" runningNo:countBillPrint]];
                countBillPrint++;
            }
            for(RewardPoint *item in rewardPointList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"rp" runningNo:countRewardPoint]];
                countRewardPoint++;
            }
            for(OrderTaking *item in orderTakingList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"ot" runningNo:countOrderTaking]];
                countOrderTaking++;
            }
            noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:receipt]];
            
            
            url = [NSURL URLWithString:[Utility url:urlPaySplitBillInsertLastOne]];
        }
            break;
        case dbMenuAndMenuIngredientList:
        {
            NSArray *dataList = (NSArray *)data;
            Menu *copyMenu = dataList[0];
            NSMutableArray *copyMenuIngredientList = dataList[1];
            NSInteger countMenuIngredient = 0;
            
            noteDataString = [NSString stringWithFormat:@"countMiMenuIngredient=%ld",[copyMenuIngredientList count]];
            noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:copyMenu]];
            for(MenuIngredient *item in copyMenuIngredientList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"mi" runningNo:countMenuIngredient]];
                countMenuIngredient++;
            }
            url = [NSURL URLWithString:[Utility url:urlMenuAndMenuIngredientInsertList]];
        }
            break;
        case dbMenuTypeAndSubMenuType:
        {
            NSArray *dataList = (NSArray *)data;
            MenuType *menuType = dataList[0];
            SubMenuType *subMenuType = dataList[1];
            
            noteDataString = [NSString stringWithFormat:@"%@",[Utility getNoteDataString:menuType]];
            noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:subMenuType withPrefix:@"sm"]];
            
            url = [NSURL URLWithString:[Utility url:urlMenuTypeAndSubMenuTypeInsert]];
        }
            break;
        case dbIngredientTypeAndSubIngredientType:
        {
            NSArray *dataList = (NSArray *)data;
            IngredientType *ingredientType = dataList[0];
            SubIngredientType *subIngredientType = dataList[1];
            
            noteDataString = [NSString stringWithFormat:@"%@",[Utility getNoteDataString:ingredientType]];
            noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:subIngredientType withPrefix:@"si"]];
            
            url = [NSURL URLWithString:[Utility url:urlIngredientTypeAndSubIngredientTypeInsert]];
        }
            break;
        case dbMoveOrderInsert:
        {
            //@[inDbOrderTakingList,inDbOrderNoteList,inDbOrderKitchenList,moveOrderTakingList,moveOrderNoteList,moveOrderKitchenList];
            NSArray *dataList = (NSArray *)data;
            NSMutableArray *inDbOrderTakingList = dataList[0];
            NSMutableArray *inDbOrderNoteList = dataList[1];
            NSMutableArray *inDbOrderKitchenList = dataList[2];
            NSMutableArray *moveOrderTakingList = dataList[3];
            NSMutableArray *moveOrderNoteList = dataList[4];
            NSMutableArray *moveOrderKitchenList = dataList[5];
            
            
            NSInteger countDotOrderTaking = 0;
            NSInteger countDonOrderNote = 0;
            NSInteger countDokOrderKitchen = 0;
            NSInteger countSotOrderTaking = 0;
            NSInteger countSonOrderNote = 0;
            NSInteger countSokOrderKitchen = 0;
            
            
            
            
            noteDataString = [NSString stringWithFormat:@"countDotOrderTaking=%ld&countDonOrderNote=%ld&countDokOrderKitchen=%ld&countSotOrderTaking=%ld&countSonOrderNote=%ld&countSokOrderKitchen=%ld",[inDbOrderTakingList count],[inDbOrderNoteList count],[inDbOrderKitchenList count],[moveOrderTakingList count],[moveOrderKitchenList count],[moveOrderKitchenList count]];
            for(OrderTaking *item in inDbOrderTakingList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"dot" runningNo:countDotOrderTaking]];
                countDotOrderTaking++;
            }
            for(OrderNote *item in inDbOrderNoteList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"don" runningNo:countDonOrderNote]];
                countDonOrderNote++;
            }
            for(OrderKitchen *item in inDbOrderKitchenList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"dok" runningNo:countDokOrderKitchen]];
                countDokOrderKitchen++;
            }
            for(OrderTaking *item in moveOrderTakingList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"sot" runningNo:countSotOrderTaking]];
                countSotOrderTaking++;
            }
            for(OrderNote *item in moveOrderNoteList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"son" runningNo:countSonOrderNote]];
                countSonOrderNote++;
            }
            for(OrderKitchen *item in moveOrderKitchenList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"sok" runningNo:countSokOrderKitchen]];
                countSokOrderKitchen++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlMoveOrderInsert]];
        }
            break;
        case dbOrderCancelDiscount:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlOrderCancelDiscountInsert]];
        }
            break;
        case dbOrderCancelDiscountList:
        {
            NSMutableArray *orderCancelDiscountList = (NSMutableArray *)data;
            NSInteger countOrderCancelDiscount = 0;
            
            noteDataString = [NSString stringWithFormat:@"countOrderCancelDiscount=%ld",[orderCancelDiscountList count]];
            for(OrderCancelDiscount *item in orderCancelDiscountList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countOrderCancelDiscount]];
                countOrderCancelDiscount++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlOrderCancelDiscountInsertList]];
        }
            break;
        case dbOrderCancelDiscountOrderTakingList:
        {
            NSArray *dataList = (NSArray *)data;
            NSMutableArray *orderCancelDiscountList = dataList[0];
            NSMutableArray *orderTakingList = dataList[1];
            
            NSInteger countOrderCancelDiscount = 0;
            NSInteger countOrderTaking = 0;
            
            
            
            
            
            
            noteDataString = [NSString stringWithFormat:@"countOcdOrderCancelDiscount=%ld&countOrderTaking=%ld",[orderCancelDiscountList count],[orderTakingList count]];
            for(OrderCancelDiscount *item in orderCancelDiscountList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"ocd" runningNo:countOrderCancelDiscount]];
                countOrderCancelDiscount++;
            }
            for(OrderTaking *item in orderTakingList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"ot" runningNo:countOrderTaking]];
                countOrderTaking++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlOrderCancelDiscountOrderTakingInsertList]];
        }
            break;
        case dbOrderTakingOrderNoteOrderKitchenOrderCancelDiscount:
        {
            NSArray *dataList = (NSArray *)data;
            OrderTaking *minusOneOrderTaking = dataList[0];
            OrderTaking *cancelOrderTaking = dataList[1];
            NSMutableArray *orderNoteList = dataList[2];
            OrderKitchen *orderKitchen = dataList[3];
            OrderCancelDiscount *orderCancelDiscount = dataList[4];
            NSInteger countOrderNote = 0;
            
            
            
            noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:minusOneOrderTaking withPrefix:@"mo"]];//update
            noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:cancelOrderTaking withPrefix:@"ot"]];//insert
            noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:orderKitchen withPrefix:@"ok"]];//insert
            noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:orderCancelDiscount withPrefix:@"ocd"]];//insert
            for(OrderNote *item in orderNoteList)//insert
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item  withRunningNo:countOrderNote]];
                countOrderNote++;
            }
            noteDataString = [NSString stringWithFormat:@"%@&countOrderNote=%ld",noteDataString,countOrderNote];
            
            url = [NSURL URLWithString:[Utility url:urlOrderTakingOrderNoteOrderKitchenOrderCancelDiscountInsertUpdateList]];
        }
            break;
        case dbPrinter:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlPrinterInsert]];
        }
            break;
        case dbPrinterList:
        {
            NSMutableArray *printerList = (NSMutableArray *)data;
            NSInteger countPrinter = 0;
            
            noteDataString = [NSString stringWithFormat:@"countPrinter=%ld",[printerList count]];
            for(Printer *item in printerList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countPrinter]];
                countPrinter++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlPrinterInsertList]];
        }
            break;
        case dbRoleTabMenu:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlRoleTabMenuInsert]];
        }
            break;
        case dbRoleTabMenuList:
        {
            NSMutableArray *roleTabMenuList = (NSMutableArray *)data;
            NSInteger countRoleTabMenu = 0;
            
            noteDataString = [NSString stringWithFormat:@"countRoleTabMenu=%ld",[roleTabMenuList count]];
            for(RoleTabMenu *item in roleTabMenuList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countRoleTabMenu]];
                countRoleTabMenu++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlRoleTabMenuInsertList]];
        }
            break;
        case dbTabMenu:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlTabMenuInsert]];
        }
            break;
        case dbTabMenuList:
        {
            NSMutableArray *tabMenuList = (NSMutableArray *)data;
            NSInteger countTabMenu = 0;
            
            noteDataString = [NSString stringWithFormat:@"countTabMenu=%ld",[tabMenuList count]];
            for(TabMenu *item in tabMenuList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countTabMenu]];
                countTabMenu++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlTabMenuInsertList]];
        }
            break;
        case dbMoneyCheck:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlMoneyCheckInsert]];
        }
            break;
        case dbMoneyCheckList:
        {
            NSMutableArray *moneyCheckList = (NSMutableArray *)data;
            NSInteger countMoneyCheck = 0;
            
            noteDataString = [NSString stringWithFormat:@"countMoneyCheck=%ld",[moneyCheckList count]];
            for(MoneyCheck *item in moneyCheckList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countMoneyCheck]];
                countMoneyCheck++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlMoneyCheckInsertList]];
        }
            break;
        case dbMoneyCheckListAndSendMail:
        {
            NSArray *dataList = (NSArray *)data;
            NSMutableArray *moneyCheckList = dataList[0];
            NSString *strPeriod = dataList[1];
            NSString *strEmailAddress = dataList[2];
            NSInteger countMoneyCheck = 0;
            
            noteDataString = [NSString stringWithFormat:@"period=%@&emailAddress=%@&countMoneyCheck=%ld",strPeriod,strEmailAddress,[moneyCheckList count]];
            for(MoneyCheck *item in moneyCheckList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countMoneyCheck]];
                countMoneyCheck++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlMoneyCheckInsertListAndSendEmail]];
        }
            break;
        case dbBranch:
        {
            NSArray *dataList = (NSArray *)data;
            Branch *branch = dataList[0];
            NSString *username = dataList[1];
            noteDataString = [Utility getNoteDataString:branch];
            noteDataString = [NSString stringWithFormat:@"%@&username=%@",noteDataString,username];
            url = [NSURL URLWithString:[Utility url:urlBranchInsert]];
        }
            break;
        case dbBranchList:
        {
            NSMutableArray *branchList = (NSMutableArray *)data;
            NSInteger countBranch = 0;
            
            noteDataString = [NSString stringWithFormat:@"countBranch=%ld",[branchList count]];
            for(Branch *item in branchList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countBranch]];
                countBranch++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlBranchInsertList]];
        }
            break;
        case dbReceiptPrint:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlReceiptPrintInsert]];
        }
            break;
        case dbReceiptPrintList:
        {
            NSMutableArray *receiptPrintList = (NSMutableArray *)data;
            NSInteger countReceiptPrint = 0;
            
            noteDataString = [NSString stringWithFormat:@"countReceiptPrint=%ld",[receiptPrintList count]];
            for(ReceiptPrint *item in receiptPrintList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countReceiptPrint]];
                countReceiptPrint++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlReceiptPrintInsertList]];
        }
            break;
        case dbDispute:
        {
            NSArray *dataList = (NSArray *)data;
            Dispute *dispute = dataList[0];
            Branch *branch = dataList[1];
            noteDataString = [Utility getNoteDataString:dispute];
            noteDataString = [NSString stringWithFormat:@"%@&branchID=%ld",noteDataString,branch.branchID];
            url = [NSURL URLWithString:[Utility url:urlDisputeInsert]];
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
            switch (propCurrentDB)
            {
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
                    NSString *strReturnID = json[@"returnID"];
                    NSArray *dataJson = json[@"dataJson"];
                    NSString *strTableName = json[@"tableName"];
                    NSString *action = json[@"action"];
                    if([status isEqual:@"1"])
                    {
                        NSLog(@"insert success");
                        if(strReturnID)
                        {
                            if (self.delegate)
                            {
                                [self.delegate itemsInsertedWithReturnID:strReturnID];
                            }
                        }
                        else if(strTableName)
                        {
                            if([strTableName isEqualToString:@"IngredientReceive"])
                            {
                                NSArray *arrClassName = @[@"IngredientReceive",@"IngredientReceive"];
                                NSArray *items = [Utility jsonToArray:dataJson arrClassName:arrClassName];
                                
                                
                                if(self.delegate)
                                {
                                    [self.delegate itemsInsertedWithReturnData:items];
                                }
                            }
                            else if([strTableName isEqualToString:@"IngredientCheck"])
                            {
                                NSArray *arrClassName = @[@"IngredientCheck",@"IngredientCheck",@"IngredientCheck",@"IngredientCheck",@"IngredientCheck",@"IngredientCheck"];
                                NSArray *items = [Utility jsonToArray:dataJson arrClassName:arrClassName];
                                
                                
                                if(self.delegate)
                                {
                                    [self.delegate itemsInsertedWithReturnData:items];
                                }
                            }
                        }
                        else
                        {
                            //                            [self syncItemsWithoutLoadViewProcess];
                            [self.delegate itemsInserted];
                        }
                    }
                    else if([status isEqual:@"2"])
                    {
                        //alertMsg
                        if(self.delegate)
                        {
                            NSString *msg = json[@"msg"];
                            [self.delegate alertMsg:msg];
                            NSLog(@"status: %@", status);
                            NSLog(@"msg: %@", msg);
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
    propCurrentDBUpdate = currentDB;
    NSURL * url;
    NSString *noteDataString;
    
    switch (currentDB)
    {
        case dbPushSyncUpdateByDeviceToken:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlPushSyncUpdateByDeviceToken]];
        }
            break;
        case dbUserAccount:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlUserAccountUpdate]];
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
        case dbTableTakingList:
        {
            NSMutableArray *tableTakingList = (NSMutableArray *)data;
            NSInteger countTableTaking = 0;
            
            noteDataString = [NSString stringWithFormat:@"countTableTaking=%ld",[tableTakingList count]];
            for(TableTaking *item in tableTakingList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countTableTaking]];
                countTableTaking++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlTableTakingUpdateList]];
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
        case dbOrderTakingOrderKitchenTableTakingReceiptList:
        {
            NSArray *dataList = (NSArray *)data;
            NSMutableArray *orderTakingList = dataList[0];
            NSMutableArray *orderKitchenList = dataList[1];
            NSMutableArray *tableTakingList = dataList[2];
            Receipt *receipt = dataList[3];
            NSInteger countOrderTaking = 0;
            NSInteger countOrderKitchen = 0;
            NSInteger countTableTaking = 0;
            
            
            noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:receipt]];
            for(OrderTaking *item in orderTakingList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"ot" runningNo:countOrderTaking]];
                countOrderTaking++;
            }
            for(OrderKitchen *item in orderKitchenList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"ok" runningNo:countOrderKitchen]];
                countOrderKitchen++;
            }
            for(TableTaking *item in tableTakingList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"tt" runningNo:countTableTaking]];
                countTableTaking++;
            }
            noteDataString = [NSString stringWithFormat:@"%@&countOrderTaking=%ld&countOrderKitchen=%ld&countTableTaking=%ld",noteDataString,countOrderTaking,countOrderKitchen,countTableTaking];
            
            
            url = [NSURL URLWithString:[Utility url:urlOrderTakingOrderKitchenTableTakingReceiptUpdateList]];
        }
            break;
        case dbOrderTakingOrderNoteOrderKitchenCancelOrder:
        {
            NSArray *dataList = (NSArray *)data;
            OrderTaking *minusOneOrderTaking = dataList[0];
            OrderTaking *cancelOrderTaking = dataList[1];
            NSMutableArray *orderNoteList = dataList[2];
            OrderKitchen *orderKitchen = dataList[3];
            NSInteger countOrderNote = 0;
            
            
            
            noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:minusOneOrderTaking withPrefix:@"mo"]];//update
            noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:cancelOrderTaking withPrefix:@"ot"]];//insert
            noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:orderKitchen withPrefix:@"ok"]];//insert
            for(OrderNote *item in orderNoteList)//insert
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item  withRunningNo:countOrderNote]];
                countOrderNote++;
            }
            noteDataString = [NSString stringWithFormat:@"%@&countOrderNote=%ld",noteDataString,countOrderNote];
            
            url = [NSURL URLWithString:[Utility url:urlOrderTakingOrderNoteOrderKitchenCancelOrderInsertUpdateList]];
        }
            break;        
        case dbAddress:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlAddressUpdate]];
        }
            break;
        case dbAddressList:
        {
            NSMutableArray *addressList = (NSMutableArray *)data;
            NSInteger countAddress = 0;
            
            noteDataString = [NSString stringWithFormat:@"countAddress=%ld",[addressList count]];
            for(Address *item in addressList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countAddress]];
                countAddress++;
            }
            url = [NSURL URLWithString:[Utility url:urlAddressUpdateList]];
        }
            break;
        case dbReceipt:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlReceiptUpdate]];
        }
            break;
        case dbReceiptList:
        {
            NSMutableArray *receiptList = (NSMutableArray *)data;
            NSInteger countReceipt = 0;
            
            noteDataString = [NSString stringWithFormat:@"countReceipt=%ld",[receiptList count]];
            for(Receipt *item in receiptList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countReceipt]];
                countReceipt++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlReceiptUpdateList]];
        }
            break;
        case dbDiscount:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlDiscountUpdate]];
        }
            break;
        case dbDiscountList:
        {
            NSMutableArray *discountList = (NSMutableArray *)data;
            NSInteger countDiscount = 0;
            
            noteDataString = [NSString stringWithFormat:@"countDiscount=%ld",[discountList count]];
            for(Discount *item in discountList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countDiscount]];
                countDiscount++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlDiscountUpdateList]];
        }
            break;
        case dbSetting:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlSettingUpdate]];
        }
            break;
        case dbSettingList:
        {
            NSMutableArray *settingList = (NSMutableArray *)data;
            NSInteger countSetting = 0;
            
            noteDataString = [NSString stringWithFormat:@"countSetting=%ld",[settingList count]];
            for(Setting *item in settingList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countSetting]];
                countSetting++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlSettingUpdateList]];
        }
            break;
        case dbRewardPoint:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlRewardPointUpdate]];
        }
            break;
        case dbRewardPointList:
        {
            NSMutableArray *rewardPointList = (NSMutableArray *)data;
            NSInteger countRewardPoint = 0;
            
            noteDataString = [NSString stringWithFormat:@"countRewardPoint=%ld",[rewardPointList count]];
            for(RewardPoint *item in rewardPointList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countRewardPoint]];
                countRewardPoint++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlRewardPointUpdateList]];
        }
            break;
        case dbReceiptCustomerTable:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlReceiptCustomerTableUpdate]];
        }
            break;
        case dbReceiptCustomerTableList:
        {
            NSMutableArray *receiptCustomerTableList = (NSMutableArray *)data;
            NSInteger countReceiptCustomerTable = 0;
            
            noteDataString = [NSString stringWithFormat:@"countReceiptCustomerTable=%ld",[receiptCustomerTableList count]];
            for(ReceiptCustomerTable *item in receiptCustomerTableList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countReceiptCustomerTable]];
                countReceiptCustomerTable++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlReceiptCustomerTableUpdateList]];
        }
            break;
        case dbRewardProgram:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlRewardProgramUpdate]];
        }
            break;
        case dbRewardProgramList:
        {
            NSMutableArray *rewardProgramList = (NSMutableArray *)data;
            NSInteger countRewardProgram = 0;
            
            noteDataString = [NSString stringWithFormat:@"countRewardProgram=%ld",[rewardProgramList count]];
            for(RewardProgram *item in rewardProgramList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countRewardProgram]];
                countRewardProgram++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlRewardProgramUpdateList]];
        }
            break;
        case dbSpecialPriceProgram:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlSpecialPriceProgramUpdate]];
        }
            break;
        case dbSpecialPriceProgramList:
        {
            NSMutableArray *specialPriceProgramList = (NSMutableArray *)data;
            NSInteger countSpecialPriceProgram = 0;
            
            noteDataString = [NSString stringWithFormat:@"countSpecialPriceProgram=%ld",[specialPriceProgramList count]];
            for(SpecialPriceProgram *item in specialPriceProgramList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countSpecialPriceProgram]];
                countSpecialPriceProgram++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlSpecialPriceProgramUpdateList]];
        }
            break;
        case dbMenu:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlMenuUpdate]];
        }
            break;
        case dbMenuList:
        {
            NSMutableArray *menuList = (NSMutableArray *)data;
            NSInteger countMenu = 0;
            
            noteDataString = [NSString stringWithFormat:@"countMenu=%ld",[menuList count]];
            for(Menu *item in menuList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countMenu]];
                countMenu++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlMenuUpdateList]];
        }
            break;
        case dbMenuType:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlMenuTypeUpdate]];
        }
            break;
        case dbMenuTypeList:
        {
            NSMutableArray *menuTypeList = (NSMutableArray *)data;
            NSInteger countMenuType = 0;
            
            noteDataString = [NSString stringWithFormat:@"countMenuType=%ld",[menuTypeList count]];
            for(MenuType *item in menuTypeList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countMenuType]];
                countMenuType++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlMenuTypeUpdateList]];
        }
            break;
        case dbMenuIngredient:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlMenuIngredientUpdate]];
        }
            break;
        case dbMenuIngredientList:
        {
            NSMutableArray *menuIngredientList = (NSMutableArray *)data;
            NSInteger countMenuIngredient = 0;
            
            noteDataString = [NSString stringWithFormat:@"countMenuIngredient=%ld",[menuIngredientList count]];
            for(MenuIngredient *item in menuIngredientList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countMenuIngredient]];
                countMenuIngredient++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlMenuIngredientUpdateList]];
        }
            break;
        case dbIngredientType:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlIngredientTypeUpdate]];
        }
            break;
        case dbIngredientTypeList:
        {
            NSMutableArray *ingredientTypeList = (NSMutableArray *)data;
            NSInteger countIngredientType = 0;
            
            noteDataString = [NSString stringWithFormat:@"countIngredientType=%ld",[ingredientTypeList count]];
            for(IngredientType *item in ingredientTypeList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countIngredientType]];
                countIngredientType++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlIngredientTypeUpdateList]];
        }
            break;
        case dbIngredient:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlIngredientUpdate]];
        }
            break;
        case dbIngredientList:
        {
            NSMutableArray *ingredientList = (NSMutableArray *)data;
            NSInteger countIngredient = 0;
            
            noteDataString = [NSString stringWithFormat:@"countIngredient=%ld",[ingredientList count]];
            for(Ingredient *item in ingredientList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countIngredient]];
                countIngredient++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlIngredientUpdateList]];
        }
            break;
        case dbSubMenuType:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlSubMenuTypeUpdate]];
        }
            break;
        case dbSubMenuTypeList:
        {
            NSMutableArray *subMenuTypeList = (NSMutableArray *)data;
            NSInteger countSubMenuType = 0;
            
            noteDataString = [NSString stringWithFormat:@"countSubMenuType=%ld",[subMenuTypeList count]];
            for(SubMenuType *item in subMenuTypeList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countSubMenuType]];
                countSubMenuType++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlSubMenuTypeUpdateList]];
        }
            break;
        case dbSubIngredientType:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlSubIngredientTypeUpdate]];
        }
            break;
        case dbSubIngredientTypeList:
        {
            NSMutableArray *subIngredientTypeList = (NSMutableArray *)data;
            NSInteger countSubIngredientType = 0;
            
            noteDataString = [NSString stringWithFormat:@"countSubIngredientType=%ld",[subIngredientTypeList count]];
            for(SubIngredientType *item in subIngredientTypeList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countSubIngredientType]];
                countSubIngredientType++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlSubIngredientTypeUpdateList]];
        }
            break;
        case dbIngredientCheck:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlIngredientCheckUpdate]];
        }
            break;
        case dbIngredientCheckList:
        {
            NSMutableArray *ingredientCheckList = (NSMutableArray *)data;
            NSInteger countIngredientCheck = 0;
            
            noteDataString = [NSString stringWithFormat:@"countIngredientCheck=%ld",[ingredientCheckList count]];
            for(IngredientCheck *item in ingredientCheckList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countIngredientCheck]];
                countIngredientCheck++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlIngredientCheckUpdateList]];
        }
            break;
        case dbIngredientReceive:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlIngredientReceiveUpdate]];
        }
            break;
        case dbIngredientReceiveList:
        {
            NSMutableArray *ingredientReceiveList = (NSMutableArray *)data;
            NSInteger countIngredientReceive = 0;
            
            noteDataString = [NSString stringWithFormat:@"countIngredientReceive=%ld",[ingredientReceiveList count]];
            for(IngredientReceive *item in ingredientReceiveList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countIngredientReceive]];
                countIngredientReceive++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlIngredientReceiveUpdateList]];
        }
            break;
        case dbNoteType:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlNoteTypeUpdate]];
        }
            break;
        case dbNoteTypeList:
        {
            NSMutableArray *noteTypeList = (NSMutableArray *)data;
            NSInteger countNoteType = 0;
            
            noteDataString = [NSString stringWithFormat:@"countNoteType=%ld",[noteTypeList count]];
            for(NoteType *item in noteTypeList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countNoteType]];
                countNoteType++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlNoteTypeUpdateList]];
        }
            break;
        case dbBoard:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlBoardUpdate]];
        }
            break;
        case dbBoardList:
        {
            NSMutableArray *boardList = (NSMutableArray *)data;
            NSInteger countBoard = 0;
            
            noteDataString = [NSString stringWithFormat:@"countBoard=%ld",[boardList count]];
            for(Board *item in boardList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countBoard]];
                countBoard++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlBoardUpdateList]];
        }
            break;
        case dbReceiptCloseTable:
        {
            //            @[rewardPointList,tableTakingList,inDbOrderTakingList,_receipt];
            NSArray *dataList = (NSArray *)data;
            NSMutableArray *billPrintList = dataList[0];
            NSMutableArray *rewardPointList = dataList[1];
            NSMutableArray *tableTakingList = dataList[2];
            NSMutableArray *orderTakingList = dataList[3];
            Receipt *receipt = dataList[4];
            
            
            NSInteger countBillPrint = 0;
            NSInteger countRewardPoint = 0;
            NSInteger countTableTaking = 0;
            NSInteger countOrderTaking = 0;
            
            
            noteDataString = [NSString stringWithFormat:@"countBillPrint=%ld&countRewardPoint=%ld&countTableTaking=%ld&countOrderTaking=%ld",[billPrintList count],[rewardPointList count],[tableTakingList count],[orderTakingList count]];
            for(BillPrint *item in billPrintList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"bp" runningNo:countBillPrint]];
                countBillPrint++;
            }
            for(RewardPoint *item in rewardPointList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"rp" runningNo:countRewardPoint]];
                countRewardPoint++;
            }
            for(TableTaking *item in tableTakingList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"tt" runningNo:countTableTaking]];
                countTableTaking++;
            }
            for(OrderTaking *item in orderTakingList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"ot" runningNo:countOrderTaking]];
                countOrderTaking++;
            }
            noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:receipt]];
            
            
            url = [NSURL URLWithString:[Utility url:urlReceiptCloseTableUpdate]];
        }
            break;
        case dbTableTakingOrderTakingReceiptUpdateDelete:
        {
            NSArray *dataList = (NSArray *)data;
            TableTaking *tableTaking = dataList[0];
            NSMutableArray *orderTakingList = dataList[1];
            Receipt *receipt = dataList[2];
            NSInteger countOrderTaking = 0;
            
            
            noteDataString = [NSString stringWithFormat:@"countOrderTaking=%ld",[orderTakingList count]];
            for(OrderTaking *item in orderTakingList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"ot" runningNo:countOrderTaking]];
                countOrderTaking++;
            }
            noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:tableTaking withPrefix:@"tt"]];
            noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:receipt]];
            url = [NSURL URLWithString:[Utility url:urlTableTakingOrderTakingReceiptUpdateDelete]];
        }
            break;
        case dbTableTakingReceiptOrderTakingListUpdate:
        {
            NSArray *dataList = (NSArray *)data;
            TableTaking *tableTaking = dataList[0];
            Receipt *receipt = dataList[1];
            NSMutableArray *orderTakingList = dataList[2];
            NSInteger countOrderTaking = 0;
            
            
            
            noteDataString = [NSString stringWithFormat:@"countOrderTaking=%ld",[orderTakingList count]];
            for(OrderTaking *item in orderTakingList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"ot" runningNo:countOrderTaking]];
                countOrderTaking++;
            }
            noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:tableTaking withPrefix:@"tt"]];
            noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:receipt]];
            url = [NSURL URLWithString:[Utility url:urlTableTakingReceiptOrderTakingListUpdate]];
        }
            break;
        case dbMoveOrderUpdate:
        {
            //@[orderTakingToMoveOrderList,orderKitchenList];
            NSArray *dataList = (NSArray *)data;
            NSMutableArray *orderTakingList = dataList[0];
            NSMutableArray *orderKitchenList = dataList[1];
            
            NSInteger countOrderTaking = 0;
            NSInteger countOrderKitchen = 0;
            
            
            
            
            noteDataString = [NSString stringWithFormat:@"countOrderTaking=%ld&countOrderKitchen=%ld",[orderTakingList count],[orderKitchenList count]];
            for(OrderTaking *item in orderTakingList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"ot" runningNo:countOrderTaking]];
                countOrderTaking++;
            }
            for(OrderKitchen *item in orderKitchenList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withPrefix:@"ok" runningNo:countOrderKitchen]];
                countOrderKitchen++;
            }
            
            
            url = [NSURL URLWithString:[Utility url:urlMoveOrderUpdate]];
        }
            break;
        case dbOrderCancelDiscount:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlOrderCancelDiscountUpdate]];
        }
            break;
        case dbOrderCancelDiscountList:
        {
            NSMutableArray *orderCancelDiscountList = (NSMutableArray *)data;
            NSInteger countOrderCancelDiscount = 0;
            
            noteDataString = [NSString stringWithFormat:@"countOrderCancelDiscount=%ld",[orderCancelDiscountList count]];
            for(OrderCancelDiscount *item in orderCancelDiscountList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countOrderCancelDiscount]];
                countOrderCancelDiscount++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlOrderCancelDiscountUpdateList]];
        }
            break;
        case dbPrinter:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlPrinterUpdate]];
        }
            break;
        case dbPrinterList:
        {
            NSMutableArray *printerList = (NSMutableArray *)data;
            NSInteger countPrinter = 0;
            
            noteDataString = [NSString stringWithFormat:@"countPrinter=%ld",[printerList count]];
            for(Printer *item in printerList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countPrinter]];
                countPrinter++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlPrinterUpdateList]];
        }
            break;
        case dbRoleTabMenu:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlRoleTabMenuUpdate]];
        }
            break;
        case dbRoleTabMenuList:
        {
            NSMutableArray *roleTabMenuList = (NSMutableArray *)data;
            NSInteger countRoleTabMenu = 0;
            
            noteDataString = [NSString stringWithFormat:@"countRoleTabMenu=%ld",[roleTabMenuList count]];
            for(RoleTabMenu *item in roleTabMenuList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countRoleTabMenu]];
                countRoleTabMenu++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlRoleTabMenuUpdateList]];
        }
            break;
        case dbTabMenu:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlTabMenuUpdate]];
        }
            break;
        case dbTabMenuList:
        {
            NSMutableArray *tabMenuList = (NSMutableArray *)data;
            NSInteger countTabMenu = 0;
            
            noteDataString = [NSString stringWithFormat:@"countTabMenu=%ld",[tabMenuList count]];
            for(TabMenu *item in tabMenuList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countTabMenu]];
                countTabMenu++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlTabMenuUpdateList]];
        }
            break;
        case dbMoneyCheck:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlMoneyCheckUpdate]];
        }
            break;
        case dbMoneyCheckList:
        {
            NSMutableArray *moneyCheckList = (NSMutableArray *)data;
            NSInteger countMoneyCheck = 0;
            
            noteDataString = [NSString stringWithFormat:@"countMoneyCheck=%ld",[moneyCheckList count]];
            for(MoneyCheck *item in moneyCheckList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countMoneyCheck]];
                countMoneyCheck++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlMoneyCheckUpdateList]];
        }
            break;
        case dbBranch:
        {
            Branch *branch = (Branch *)data;
            noteDataString = [Utility getNoteDataString:data];
            noteDataString = [NSString stringWithFormat:@"%@&dbNameEdit=%@",noteDataString,branch.dbName];
            url = [NSURL URLWithString:[Utility url:urlBranchUpdate]];
        }
            break;
        case dbBranchList:
        {
            NSMutableArray *branchList = (NSMutableArray *)data;
            NSInteger countBranch = 0;
            
            noteDataString = [NSString stringWithFormat:@"countBranch=%ld",[branchList count]];
            for(Branch *item in branchList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countBranch]];
                countBranch++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlBranchUpdateList]];
        }
            break;
        case dbReceiptPrint:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlReceiptPrintUpdate]];
        }
            break;
        case dbReceiptPrintList:
        {
            NSMutableArray *receiptPrintList = (NSMutableArray *)data;
            NSInteger countReceiptPrint = 0;
            
            noteDataString = [NSString stringWithFormat:@"countReceiptPrint=%ld",[receiptPrintList count]];
            for(ReceiptPrint *item in receiptPrintList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countReceiptPrint]];
                countReceiptPrint++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlReceiptPrintUpdateList]];
        }
            break;
        case dbJummumReceipt:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlJummumReceiptUpdate]];
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
    
    switch (currentDB)
    {
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
        case dbTableTakingWithCustomerTable:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlTableTakingWithCustomerTableDelete]];
        }
            break;
        case dbTableTakingList:
        {
            NSMutableArray *tableTakingList = (NSMutableArray *)data;
            NSInteger countTableTaking = 0;
            
            noteDataString = [NSString stringWithFormat:@"countTableTaking=%ld",[tableTakingList count]];
            for(TableTaking *item in tableTakingList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countTableTaking]];
                countTableTaking++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlTableTakingDeleteList]];
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
        case dbAddress:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlAddressDelete]];
        }
            break;
        case dbReceipt:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlReceiptDelete]];
        }
            break;
        case dbReceiptList:
        {
            NSMutableArray *receiptList = (NSMutableArray *)data;
            NSInteger countReceipt = 0;
            
            noteDataString = [NSString stringWithFormat:@"countReceipt=%ld",[receiptList count]];
            for(Receipt *item in receiptList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countReceipt]];
                countReceipt++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlReceiptDeleteList]];
        }
            break;
        case dbDiscount:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlDiscountDelete]];
        }
            break;
        case dbDiscountList:
        {
            NSMutableArray *discountList = (NSMutableArray *)data;
            NSInteger countDiscount = 0;
            
            noteDataString = [NSString stringWithFormat:@"countDiscount=%ld",[discountList count]];
            for(Discount *item in discountList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countDiscount]];
                countDiscount++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlDiscountDeleteList]];
        }
            break;
        case dbRewardPoint:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlRewardPointDelete]];
        }
            break;
        case dbRewardPointList:
        {
            NSMutableArray *rewardPointList = (NSMutableArray *)data;
            NSInteger countRewardPoint = 0;
            
            noteDataString = [NSString stringWithFormat:@"countRewardPoint=%ld",[rewardPointList count]];
            for(RewardPoint *item in rewardPointList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countRewardPoint]];
                countRewardPoint++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlRewardPointDeleteList]];
        }
            break;
        case dbReceiptCustomerTable:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlReceiptCustomerTableDelete]];
        }
            break;
        case dbReceiptCustomerTableList:
        {
            NSMutableArray *receiptCustomerTableList = (NSMutableArray *)data;
            NSInteger countReceiptCustomerTable = 0;
            
            noteDataString = [NSString stringWithFormat:@"countReceiptCustomerTable=%ld",[receiptCustomerTableList count]];
            for(ReceiptCustomerTable *item in receiptCustomerTableList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countReceiptCustomerTable]];
                countReceiptCustomerTable++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlReceiptCustomerTableDeleteList]];
        }
            break;
        case dbRewardProgram:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlRewardProgramDelete]];
        }
            break;
        case dbRewardProgramList:
        {
            NSMutableArray *rewardProgramList = (NSMutableArray *)data;
            NSInteger countRewardProgram = 0;
            
            noteDataString = [NSString stringWithFormat:@"countRewardProgram=%ld",[rewardProgramList count]];
            for(RewardProgram *item in rewardProgramList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countRewardProgram]];
                countRewardProgram++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlRewardProgramDeleteList]];
        }
            break;
        case dbSpecialPriceProgram:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlSpecialPriceProgramDelete]];
        }
            break;
        case dbSpecialPriceProgramList:
        {
            NSMutableArray *specialPriceProgramList = (NSMutableArray *)data;
            NSInteger countSpecialPriceProgram = 0;
            
            noteDataString = [NSString stringWithFormat:@"countSpecialPriceProgram=%ld",[specialPriceProgramList count]];
            for(SpecialPriceProgram *item in specialPriceProgramList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countSpecialPriceProgram]];
                countSpecialPriceProgram++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlSpecialPriceProgramDeleteList]];
        }
            break;
        case dbMenu:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlMenuDelete]];
        }
            break;
        case dbMenuList:
        {
            NSMutableArray *menuList = (NSMutableArray *)data;
            NSInteger countMenu = 0;
            
            noteDataString = [NSString stringWithFormat:@"countMenu=%ld",[menuList count]];
            for(Menu *item in menuList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countMenu]];
                countMenu++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlMenuDeleteList]];
        }
            break;
        case dbMenuType:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlMenuTypeDelete]];
        }
            break;
        case dbMenuTypeList:
        {
            NSMutableArray *menuTypeList = (NSMutableArray *)data;
            NSInteger countMenuType = 0;
            
            noteDataString = [NSString stringWithFormat:@"countMenuType=%ld",[menuTypeList count]];
            for(MenuType *item in menuTypeList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countMenuType]];
                countMenuType++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlMenuTypeDeleteList]];
        }
            break;
        case dbMenuIngredient:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlMenuIngredientDelete]];
        }
            break;
        case dbMenuIngredientList:
        {
            NSMutableArray *menuIngredientList = (NSMutableArray *)data;
            NSInteger countMenuIngredient = 0;
            
            noteDataString = [NSString stringWithFormat:@"countMenuIngredient=%ld",[menuIngredientList count]];
            for(MenuIngredient *item in menuIngredientList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countMenuIngredient]];
                countMenuIngredient++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlMenuIngredientDeleteList]];
        }
            break;
        case dbIngredientType:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlIngredientTypeDelete]];
        }
            break;
        case dbIngredientTypeList:
        {
            NSMutableArray *ingredientTypeList = (NSMutableArray *)data;
            NSInteger countIngredientType = 0;
            
            noteDataString = [NSString stringWithFormat:@"countIngredientType=%ld",[ingredientTypeList count]];
            for(IngredientType *item in ingredientTypeList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countIngredientType]];
                countIngredientType++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlIngredientTypeDeleteList]];
        }
            break;
        case dbIngredient:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlIngredientDelete]];
        }
            break;
        case dbIngredientList:
        {
            NSMutableArray *ingredientList = (NSMutableArray *)data;
            NSInteger countIngredient = 0;
            
            noteDataString = [NSString stringWithFormat:@"countIngredient=%ld",[ingredientList count]];
            for(Ingredient *item in ingredientList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countIngredient]];
                countIngredient++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlIngredientDeleteList]];
        }
            break;
        case dbSubMenuType:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlSubMenuTypeDelete]];
        }
            break;
        case dbSubMenuTypeList:
        {
            NSMutableArray *subMenuTypeList = (NSMutableArray *)data;
            NSInteger countSubMenuType = 0;
            
            noteDataString = [NSString stringWithFormat:@"countSubMenuType=%ld",[subMenuTypeList count]];
            for(SubMenuType *item in subMenuTypeList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countSubMenuType]];
                countSubMenuType++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlSubMenuTypeDeleteList]];
        }
            break;
        case dbSubIngredientType:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlSubIngredientTypeDelete]];
        }
            break;
        case dbSubIngredientTypeList:
        {
            NSMutableArray *subIngredientTypeList = (NSMutableArray *)data;
            NSInteger countSubIngredientType = 0;
            
            noteDataString = [NSString stringWithFormat:@"countSubIngredientType=%ld",[subIngredientTypeList count]];
            for(SubIngredientType *item in subIngredientTypeList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countSubIngredientType]];
                countSubIngredientType++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlSubIngredientTypeDeleteList]];
        }
            break;
        case dbIngredientCheck:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlIngredientCheckDelete]];
        }
            break;
        case dbIngredientCheckList:
        {
            NSMutableArray *ingredientCheckList = (NSMutableArray *)data;
            NSInteger countIngredientCheck = 0;
            
            noteDataString = [NSString stringWithFormat:@"countIngredientCheck=%ld",[ingredientCheckList count]];
            for(IngredientCheck *item in ingredientCheckList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countIngredientCheck]];
                countIngredientCheck++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlIngredientCheckDeleteList]];
        }
            break;
        case dbIngredientReceive:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlIngredientReceiveDelete]];
        }
            break;
        case dbIngredientReceiveList:
        {
            NSDate *receiveDate = (NSDate *)data;
            noteDataString = [NSString stringWithFormat:@"receiveDate=%@",receiveDate];
            url = [NSURL URLWithString:[Utility url:urlIngredientReceiveDeleteList]];
        }
            break;
        case dbNoteType:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlNoteTypeDelete]];
        }
            break;
        case dbNoteTypeList:
        {
            NSMutableArray *noteTypeList = (NSMutableArray *)data;
            NSInteger countNoteType = 0;
            
            noteDataString = [NSString stringWithFormat:@"countNoteType=%ld",[noteTypeList count]];
            for(NoteType *item in noteTypeList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countNoteType]];
                countNoteType++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlNoteTypeDeleteList]];
        }
            break;
        case dbBoard:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlBoardDelete]];
        }
            break;
        case dbBoardList:
        {
            NSMutableArray *boardList = (NSMutableArray *)data;
            NSInteger countBoard = 0;
            
            noteDataString = [NSString stringWithFormat:@"countBoard=%ld",[boardList count]];
            for(Board *item in boardList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countBoard]];
                countBoard++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlBoardDeleteList]];
        }
            break;
        case dbBillPrint:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlBillPrintDelete]];
        }
            break;
        case dbBillPrintList:
        {
            NSMutableArray *billPrintList = (NSMutableArray *)data;
            NSInteger countBillPrint = 0;
            
            noteDataString = [NSString stringWithFormat:@"countBillPrint=%ld",[billPrintList count]];
            for(BillPrint *item in billPrintList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countBillPrint]];
                countBillPrint++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlBillPrintDeleteList]];
        }
            break;
        case dbOrderCancelDiscount:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlOrderCancelDiscountDelete]];
        }
            break;
        case dbOrderCancelDiscountList:
        {
            NSMutableArray *orderCancelDiscountList = (NSMutableArray *)data;
            NSInteger countOrderCancelDiscount = 0;
            
            noteDataString = [NSString stringWithFormat:@"countOrderCancelDiscount=%ld",[orderCancelDiscountList count]];
            for(OrderCancelDiscount *item in orderCancelDiscountList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countOrderCancelDiscount]];
                countOrderCancelDiscount++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlOrderCancelDiscountDeleteList]];
        }
            break;
        case dbPrinter:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlPrinterDelete]];
        }
            break;
        case dbPrinterList:
        {
            NSMutableArray *printerList = (NSMutableArray *)data;
            NSInteger countPrinter = 0;
            
            noteDataString = [NSString stringWithFormat:@"countPrinter=%ld",[printerList count]];
            for(Printer *item in printerList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countPrinter]];
                countPrinter++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlPrinterDeleteList]];
        }
            break;
        case dbRoleTabMenu:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlRoleTabMenuDelete]];
        }
            break;
        case dbRoleTabMenuList:
        {
            NSMutableArray *roleTabMenuList = (NSMutableArray *)data;
            NSInteger countRoleTabMenu = 0;
            
            noteDataString = [NSString stringWithFormat:@"countRoleTabMenu=%ld",[roleTabMenuList count]];
            for(RoleTabMenu *item in roleTabMenuList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countRoleTabMenu]];
                countRoleTabMenu++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlRoleTabMenuDeleteList]];
        }
            break;
        case dbTabMenu:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlTabMenuDelete]];
        }
            break;
        case dbTabMenuList:
        {
            NSMutableArray *tabMenuList = (NSMutableArray *)data;
            NSInteger countTabMenu = 0;
            
            noteDataString = [NSString stringWithFormat:@"countTabMenu=%ld",[tabMenuList count]];
            for(TabMenu *item in tabMenuList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countTabMenu]];
                countTabMenu++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlTabMenuDeleteList]];
        }
            break;
        case dbMoneyCheck:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlMoneyCheckDelete]];
        }
            break;
        case dbMoneyCheckList:
        {
            NSMutableArray *moneyCheckList = (NSMutableArray *)data;
            NSInteger countMoneyCheck = 0;
            
            noteDataString = [NSString stringWithFormat:@"countMoneyCheck=%ld",[moneyCheckList count]];
            for(MoneyCheck *item in moneyCheckList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countMoneyCheck]];
                countMoneyCheck++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlMoneyCheckDeleteList]];
        }
            break;
        case dbBranch:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlBranchDelete]];
        }
            break;
        case dbBranchList:
        {
            NSMutableArray *branchList = (NSMutableArray *)data;
            NSInteger countBranch = 0;
            
            noteDataString = [NSString stringWithFormat:@"countBranch=%ld",[branchList count]];
            for(Branch *item in branchList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countBranch]];
                countBranch++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlBranchDeleteList]];
        }
            break;
        case dbReceiptPrint:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlReceiptPrintDelete]];
        }
            break;
        case dbReceiptPrintList:
        {
            NSMutableArray *receiptPrintList = (NSMutableArray *)data;
            NSInteger countReceiptPrint = 0;
            
            noteDataString = [NSString stringWithFormat:@"countReceiptPrint=%ld",[receiptPrintList count]];
            for(ReceiptPrint *item in receiptPrintList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countReceiptPrint]];
                countReceiptPrint++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlReceiptPrintDeleteList]];
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

- (void)syncItemsPrintKitchenBill:(enum enumDB)currentDB withData:(NSObject *)data
{
    propCurrentDB = currentDB;
    NSURL * url;
    NSString *noteDataString;
    NSInteger receiptID;
    switch (currentDB) {
        case dbPushSync:
        {
            NSArray *dataList = (NSArray *)data;
            PushSync *pushSync = dataList[0];
            receiptID = [dataList[1] integerValue];
            
            noteDataString = [Utility getNoteDataString:pushSync];
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
                    [self.delegate itemsSyncedPrintKitchenBill:json[@"payload"] receiptID:receiptID];
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

//- (void)syncItemsWithoutLoadViewProcess:(enum enumDB)currentDB withData:(NSObject *)data
//{
//    propCurrentDB = currentDB;
//    NSURL * url;
//    NSString *noteDataString;
//    switch (currentDB) {
//        case dbPushSync:
//        {
//            noteDataString = [Utility getNoteDataString:data];
//            url = [NSURL URLWithString:[Utility url:urlPushSyncSync]];
//        }
//            break;
//        default:
//            break;
//    }
//    noteDataString = [NSString stringWithFormat:@"%@&modifiedDeviceToken=%@&modifiedUser=%@&dbName=%@",noteDataString,[Utility deviceToken],[Utility modifiedUser],[Utility dbName]];
//    NSLog(@"notedatastring: %@",noteDataString);
//    NSLog(@"url: %@",url);
//
//
//    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
//
//    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
//    [urlRequest setHTTPMethod:@"POST"];
//    [urlRequest setHTTPBody:[noteDataString dataUsingEncoding:NSUTF8StringEncoding]];
//
//    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *dataRaw, NSURLResponse *header, NSError *error) {
//
//        if(!error || (error && error.code == -1005))
//        {
//            if(!dataRaw)
//            {
//                //data parameter is nil
//                NSLog(@"Error: %@", [error debugDescription]);
//                return ;
//            }
//
//            NSDictionary *json = [NSJSONSerialization
//                                  JSONObjectWithData:dataRaw
//                                  options:kNilOptions error:&error];
//            NSString *status = json[@"status"];
//            if([status isEqual:@"1"])
//            {
//                [self itemsSyncedWithoutLoadViewProcess:json[@"payload"]];
//            }
//            else if([status isEqual:@"0"])
//            {
//                NSLog(@"sync succes with no new row update");
//                [self itemsSyncedWithoutLoadViewProcess:[[NSArray alloc]init]];
//            }
//            else
//            {
//                //Error
//                NSLog(@"sync fail");
//                NSLog([NSString stringWithFormat:@"status: %@",status]);
//            }
//        }
//        else
//        {
//            NSLog(@"Error: %@", [error debugDescription]);
//            NSLog(@"Error: %@", [error localizedDescription]);
//        }
//    }];
//
//    [dataTask resume];
//}

-(void)sendEmail:(NSString *)toAddress withSubject:(NSString *)subject andBody:(NSString *)body
{
    NSString *bodyPercentEscape = [Utility percentEscapeString:body];
    NSString *noteDataString = [NSString stringWithFormat:@"toAddress=%@&subject=%@&body=%@", toAddress,subject,bodyPercentEscape];
    noteDataString = [NSString stringWithFormat:@"%@&modifiedDeviceToken=%@&modifiedUser=%@&dbName=%@",noteDataString,[Utility deviceToken],[Utility modifiedUser],[Utility dbName]];
    
    
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
        noteDataString = [NSString stringWithFormat:@"%@&modifiedDeviceToken=%@&modifiedUser=%@&dbName=%@",noteDataString,[Utility deviceToken],[Utility modifiedUser],[Utility dbName]];
        
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
    noteDataString = [NSString stringWithFormat:@"%@&modifiedDeviceToken=%@&modifiedUser=%@&dbName=%@",noteDataString,[Utility deviceToken],[Utility modifiedUser],[Utility dbName]];
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
    noteDataString = [NSString stringWithFormat:@"%@&modifiedDeviceToken=%@&modifiedUser=%@&dbName=%@",noteDataString,[Utility deviceToken],[Utility modifiedUser],[Utility dbName]];
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

//- (void)syncItemsWithoutLoadViewProcess
//{
//    PushSync *pushSync = [[PushSync alloc]init];
//    pushSync.deviceToken = [Utility deviceToken];
//    [self syncItemsWithoutLoadViewProcess:dbPushSync withData:pushSync];
//}

//- (void)itemsSyncedWithoutLoadViewProcess:(NSArray *)items
//{
//    if([items count] == 0)
//    {
//        NSLog(@"itemsSyncedWithoutLoadViewProcess no row");
//        return;
//    }
//    NSLog(@"itemsSyncedWithoutLoadViewProcess has row");
//    NSMutableArray *pushSyncList = [[NSMutableArray alloc]init];
//    for(int j=0; j<[items count]; j++)
//    {
//        NSDictionary *payload = items[j];
//        NSString *type = [payload objectForKey:@"type"];
//        NSString *action = [payload objectForKey:@"action"];
//        NSString *strPushSyncID = [payload objectForKey:@"pushSyncID"];
//        NSArray *data = [payload objectForKey:@"data"];
//        NSLog(@"pushsync%d: pushsyncid:%@",j,strPushSyncID);
//
//        if([strPushSyncID isEqual:[NSNull null]])
//        {
//            NSLog(@"strpushsyncid is nsnull");
//            continue;
//        }
//        //เช็คว่าเคย sync pushsyncid นี้ไปแล้วยัง
//        if([PushSync alreadySynced:[strPushSyncID integerValue]])
//        {
//            continue;
//        }
//        else
//        {
//            //update shared ใช้ในกรณี เรียก homemodel > 1 อันต่อหนึ่ง click คำสั่ง ซึ่งทำให้เกิดการ เรียก function syncitems ตัวที่ 2 ก่อนเกิดการ update timesynced จึงทำให้เกิดการเบิ้ล sync
//            PushSync *pushSync = [[PushSync alloc]initWithPushSyncID:[strPushSyncID integerValue]];
//            [PushSync addObject:pushSync];
//            [pushSyncList addObject:pushSync];
//        }
//
//
//        if([type isEqualToString:@"alert"])
//        {
//            [pushSyncList removeLastObject];
//        }
//        else
//        {
//            if([data isKindOfClass:[NSArray class]])
//            {
//                [Utility itemsSynced:type action:action data:data];
//            }
//        }
//    }
//
//
//    //update pushsync ที่ sync แล้ว
//    if([pushSyncList count]>0)
//    {
//        [self updateItems:dbPushSyncUpdateTimeSynced withData:pushSyncList actionScreen:@"Update synced time by id"];
//    }
//}
@end

