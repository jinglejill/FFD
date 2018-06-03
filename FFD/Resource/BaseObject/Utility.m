//
//  Utility.m
//  Eventoree
//
//  Created by Thidaporn Kijkamjai on 8/6/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "Utility.h"
//#import "RNEncryptor.h"
//#import "RNDecryptor.h"
#import <objc/runtime.h>


#import "UserAccount.h"
#import "LogIn.h"
#import "CustomerTable.h"
#import "MenuType.h"
#import "Menu.h"
#import "TableTaking.h"
#import "OrderTaking.h"


#import "SharedUserAccount.h"
#import "SharedLogIn.h"
#import "SharedCustomerTable.h"
#import "SharedMenuType.h"
#import "SharedMenu.h"
#import "SharedTableTaking.h"
#import "SharedOrderTaking.h"





extern NSArray *globalMessage;
extern NSString *globalPingAddress;
extern NSString *globalDomainName;
extern NSString *globalSubjectNoConnection;
extern NSString *globalDetailNoConnection;
extern BOOL globalFinishLoadSharedData;
extern NSString *globalCipher;
extern NSString *globalModifiedUser;



@implementation Utility
+ (NSString *) randomStringWithLength: (int) len {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyz0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])] ];
    }
    
    return randomString;
}

+ (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (void) setPingAddress:(NSString *)pingAddress
{
    globalPingAddress = pingAddress;
}

+ (NSString *) pingAddress
{
    return globalPingAddress;
}

+ (void) setDomainName:(NSString *)domainName
{
    globalDomainName = domainName;
}

+ (NSString *) domainName
{
    return globalDomainName;
}

+ (void) setSubjectNoConnection:(NSString *)subjectNoConnection
{
    globalSubjectNoConnection = subjectNoConnection;
}

+ (NSString *) subjectNoConnection
{
    return globalSubjectNoConnection;
}

+ (void) setDetailNoConnection:(NSString *)detailNoConnection
{
    globalDetailNoConnection = detailNoConnection;
}

+ (NSString *) detailNoConnection
{
    return globalDetailNoConnection;
}

+(void)setCipher:(NSString *)cipher
{
    globalCipher = cipher;
}
+(NSString *)cipher
{
    return globalCipher;
}

+ (void)setBranchID:(NSInteger)branchID
{
    [[NSUserDefaults standardUserDefaults] setInteger:branchID forKey:@"branchID"];
}

+ (NSInteger) branchID
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"branchID"];
}

+ (NSString *) deviceToken
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:TOKEN];
}

+ (NSInteger) deviceID
{
    NSString *strDeviceID = [[NSUserDefaults standardUserDefaults] stringForKey:@"deviceID"];
    return [strDeviceID integerValue];
}

+ (NSString *) dbName
{
//    return [[NSUserDefaults standardUserDefaults] stringForKey:USERNAME];
    return [[NSUserDefaults standardUserDefaults] stringForKey:BRANCH];
}

+ (BOOL) finishLoadSharedData
{
    return globalFinishLoadSharedData;
}

+ (void) setFinishLoadSharedData:(BOOL)finish
{
    globalFinishLoadSharedData = finish;
}

+ (NSString *) url:(enum enumUrl)eUrl
{
    NSString *url = [[NSString alloc]init];
    switch (eUrl)
    {
        case urlCredentialsDbGet:
            url = @"/FFD/MAMARIN5/FFDCredentialsDbGet.php";
            break;
        case urlUserAccountInsert:
            url = @"/FFD/MAMARIN5/FFDUserAccountInsert.php";
            break;
        case urlUserAccountUpdate:
            url = @"/FFD/MAMARIN5/FFDUserAccountUpdate.php";
            break;
        case urlSendEmail:
            url = @"/FFD/MAMARIN5/sendEmail.php";
            break;
        case urlMasterGet:
            url = @"/FFD/MAMARIN5/FFDMasterGet.php";
            break;
        case urlUploadPhoto:
            url = @"/FFD/MAMARIN5/uploadPhoto.php";
            break;
        case urlDownloadPhoto:
            url = @"/FFD/MAMARIN5/downloadImage.php";
            break;
        case urlDownloadFile:
            url = @"/FFD/MAMARIN5/downloadFile.php";
            break;
        case urlUserAccountDeviceTokenUpdate:
            url = @"/FFD/MAMARIN5/FFDUserAccountDeviceTokenUpdate.php";
            break;
        case urlLogInInsert:
            url = @"/FFD/MAMARIN5/FFDLogInInsert.php";
            break;
        case urlPushSyncSync:
            url = @"/FFD/MAMARIN5/FFDPushSyncSync.php";
            break;
        case urlPushSyncUpdateByDeviceToken:
            url = @"/FFD/MAMARIN5/FFDPushSyncUpdateByDeviceToken.php";
            break;
        case urlCredentialsValidate:
            url = @"/FFD/MAMARIN5/FFDCredentialsValidate.php";
            break;
        case urlDeviceInsert:
            url = @"/FFD/MAMARIN5/FFDDeviceInsert.php";
            break;
        case urlPushSyncUpdateTimeSynced:
            url = @"/FFD/MAMARIN5/FFDPushSyncUpdateTimeSynced.php";
            break;
        case urlWriteLog:
            url = @"/FFD/MAMARIN5/FFDWriteLog.php";
            break;
        case urlTableTakingInsert:
            url = @"/FFD/MAMARIN5/FFDTableTakingInsert.php";
            break;
        case urlTableTakingInsertUpdate:
            url = @"/FFD/MAMARIN5/FFDTableTakingInsertUpdate.php";
            break;
        case urlTableTakingUpdate:
            url = @"/FFD/MAMARIN5/FFDTableTakingUpdate.php";
            break;
        case urlTableTakingDelete:
            url = @"/FFD/MAMARIN5/FFDTableTakingDelete.php";
            break;
        case urlTableTakingWithCustomerTableDelete:
            url = @"/FFD/MAMARIN5/FFDTableTakingWithCustomerTableDelete.php";
            break;
        case urlTableTakingInsertList:
            url = @"/FFD/MAMARIN5/FFDTableTakingInsertList.php";
            break;
        case urlTableTakingUpdateList:
            url = @"/FFD/MAMARIN5/FFDTableTakingUpdateList.php";
            break;
        case urlTableTakingDeleteList:
            url = @"/FFD/MAMARIN5/FFDTableTakingDeleteList.php";
            break;
        case urlOrderTakingInsert:
            url = @"/FFD/MAMARIN5/FFDOrderTakingInsert.php";
            break;
        case urlOrderTakingUpdate:
            url = @"/FFD/MAMARIN5/FFDOrderTakingUpdate.php";
            break;
        case urlOrderTakingDelete:
            url = @"/FFD/MAMARIN5/FFDOrderTakingDelete.php";
            break;
        case urlOrderTakingInsertUpdate:
            url = @"/FFD/MAMARIN5/FFDOrderTakingInsertUpdate.php";
            break;
        case urlOrderTakingUpdateList:
            url = @"/FFD/MAMARIN5/FFDOrderTakingUpdateList.php";
            break;
        case urlOrderTakingDeleteList:
            url = @"/FFD/MAMARIN5/FFDOrderTakingDeleteList.php";
            break;
        case urlOrderNoteInsert:
            url = @"/FFD/MAMARIN5/FFDOrderNoteInsert.php";
            break;
        case urlOrderNoteUpdate:
            url = @"/FFD/MAMARIN5/FFDOrderNoteUpdate.php";
            break;
        case urlOrderNoteDelete:
            url = @"/FFD/MAMARIN5/FFDOrderNoteDelete.php";
            break;
        case urlOrderNoteInsertList:
            url = @"/FFD/MAMARIN5/FFDOrderNoteInsertList.php";
            break;
        case urlOrderNoteUpdateList:
            url = @"/FFD/MAMARIN5/FFDOrderNoteUpdateList.php";
            break;
        case urlOrderNoteDeleteList:
            url = @"/FFD/MAMARIN5/FFDOrderNoteDeleteList.php";
            break;
        case urlOrderKitchenInsertList:
            url = @"/FFD/MAMARIN5/FFDOrderKitchenInsertList.php";
            break;
        case urlMemberInsert:
            url = @"/FFD/MAMARIN5/FFDMemberInsert.php";
            break;
        case urlAddressInsert:
            url = @"/FFD/MAMARIN5/FFDAddressInsert.php";
            break;
        case urlAddressDelete:
            url = @"/FFD/MAMARIN5/FFDAddressDelete.php";
            break;
        case urlAddressUpdate:
            url = @"/FFD/MAMARIN5/FFDAddressUpdate.php";
            break;
        case urlAddressUpdateList:
            url = @"/FFD/MAMARIN5/FFDAddressUpdateList.php";
            break;
        case urlReceiptInsert:
            url = @"/FFD/MAMARIN5/FFDReceiptInsert.php";
            break;
        case urlReceiptUpdate:
            url = @"/FFD/MAMARIN5/FFDReceiptUpdate.php";
            break;
        case urlReceiptDelete:
            url = @"/FFD/MAMARIN5/FFDReceiptDelete.php";
            break;
        case urlReceiptInsertList:
            url = @"/FFD/MAMARIN5/FFDReceiptInsertList.php";
            break;
        case urlReceiptUpdateList:
            url = @"/FFD/MAMARIN5/FFDReceiptUpdateList.php";
            break;
        case urlReceiptDeleteList:
            url = @"/FFD/MAMARIN5/FFDReceiptDeleteList.php";
            break;
        case urlReceiptGetList:
            url = @"/FFD/MAMARIN5/FFDReceiptGetList.php";
            break;
        case urlDiscountInsert:
            url = @"/FFD/MAMARIN5/FFDDiscountInsert.php";
            break;
        case urlDiscountUpdate:
            url = @"/FFD/MAMARIN5/FFDDiscountUpdate.php";
            break;
        case urlDiscountDelete:
            url = @"/FFD/MAMARIN5/FFDDiscountDelete.php";
            break;
        case urlDiscountInsertList:
            url = @"/FFD/MAMARIN5/FFDDiscountInsertList.php";
            break;
        case urlDiscountUpdateList:
            url = @"/FFD/MAMARIN5/FFDDiscountUpdateList.php";
            break;
        case urlDiscountDeleteList:
            url = @"/FFD/MAMARIN5/FFDDiscountDeleteList.php";
            break;
        case urlDiscountGetList:
            url = @"/FFD/MAMARIN5/FFDDiscountGetList.php";
            break;
        case urlSettingUpdate:
            url = @"/FFD/MAMARIN5/FFDSettingUpdate.php";
            break;
        case urlSettingUpdateList:
            url = @"/FFD/MAMARIN5/FFDSettingUpdateList.php";
            break;
        case urlRewardPointInsert:
            url = @"/FFD/MAMARIN5/FFDRewardPointInsert.php";
            break;
        case urlRewardPointUpdate:
            url = @"/FFD/MAMARIN5/FFDRewardPointUpdate.php";
            break;
        case urlRewardPointDelete:
            url = @"/FFD/MAMARIN5/FFDRewardPointDelete.php";
            break;
        case urlRewardPointInsertList:
            url = @"/FFD/MAMARIN5/FFDRewardPointInsertList.php";
            break;
        case urlRewardPointUpdateList:
            url = @"/FFD/MAMARIN5/FFDRewardPointUpdateList.php";
            break;
        case urlRewardPointDeleteList:
            url = @"/FFD/MAMARIN5/FFDRewardPointDeleteList.php";
            break;
        case urlReceiptNoInsert:
            url = @"/FFD/MAMARIN5/FFDReceiptNoInsert.php";
            break;
        case urlReceiptNoUpdate:
            url = @"/FFD/MAMARIN5/FFDReceiptNoUpdate.php";
            break;
        case urlReceiptNoDelete:
            url = @"/FFD/MAMARIN5/FFDReceiptNoDelete.php";
            break;
        case urlReceiptNoInsertList:
            url = @"/FFD/MAMARIN5/FFDReceiptNoInsertList.php";
            break;
        case urlReceiptNoUpdateList:
            url = @"/FFD/MAMARIN5/FFDReceiptNoUpdateList.php";
            break;
        case urlReceiptNoDeleteList:
            url = @"/FFD/MAMARIN5/FFDReceiptNoDeleteList.php";
            break;
        case urlReceiptNoTaxInsert:
            url = @"/FFD/MAMARIN5/FFDReceiptNoTaxInsert.php";
            break;
        case urlReceiptNoTaxUpdate:
            url = @"/FFD/MAMARIN5/FFDReceiptNoTaxUpdate.php";
            break;
        case urlReceiptNoTaxDelete:
            url = @"/FFD/MAMARIN5/FFDReceiptNoTaxDelete.php";
            break;
        case urlReceiptNoTaxInsertList:
            url = @"/FFD/MAMARIN5/FFDReceiptNoTaxInsertList.php";
            break;
        case urlReceiptNoTaxUpdateList:
            url = @"/FFD/MAMARIN5/FFDReceiptNoTaxUpdateList.php";
            break;
        case urlReceiptNoTaxDeleteList:
            url = @"/FFD/MAMARIN5/FFDReceiptNoTaxDeleteList.php";
            break;
        case urlReceiptNoAndReceiptInsert:
            url = @"/FFD/MAMARIN5/FFDReceiptNoAndReceiptInsert.php";
            break;
        case urlReceiptCustomerTableInsert:
            url = @"/FFD/MAMARIN5/FFDReceiptCustomerTableInsert.php";
            break;
        case urlReceiptCustomerTableUpdate:
            url = @"/FFD/MAMARIN5/FFDReceiptCustomerTableUpdate.php";
            break;
        case urlReceiptCustomerTableDelete:
            url = @"/FFD/MAMARIN5/FFDReceiptCustomerTableDelete.php";
            break;
        case urlReceiptCustomerTableInsertList:
            url = @"/FFD/MAMARIN5/FFDReceiptCustomerTableInsertList.php";
            break;
        case urlReceiptCustomerTableUpdateList:
            url = @"/FFD/MAMARIN5/FFDReceiptCustomerTableUpdateList.php";
            break;
        case urlReceiptCustomerTableDeleteList:
            url = @"/FFD/MAMARIN5/FFDReceiptCustomerTableDeleteList.php";
            break;
        case urlRewardProgramInsert:
            url = @"/FFD/MAMARIN5/FFDRewardProgramInsert.php";
            break;
        case urlRewardProgramUpdate:
            url = @"/FFD/MAMARIN5/FFDRewardProgramUpdate.php";
            break;
        case urlRewardProgramDelete:
            url = @"/FFD/MAMARIN5/FFDRewardProgramDelete.php";
            break;
        case urlRewardProgramInsertList:
            url = @"/FFD/MAMARIN5/FFDRewardProgramInsertList.php";
            break;
        case urlRewardProgramUpdateList:
            url = @"/FFD/MAMARIN5/FFDRewardProgramUpdateList.php";
            break;
        case urlRewardProgramDeleteList:
            url = @"/FFD/MAMARIN5/FFDRewardProgramDeleteList.php";
            break;
        case urlRewardProgramGetList:
            url = @"/FFD/MAMARIN5/FFDRewardProgramGetList.php";
            break;
        case urlSpecialPriceProgramInsert:
            url = @"/FFD/MAMARIN5/FFDSpecialPriceProgramInsert.php";
            break;
        case urlSpecialPriceProgramUpdate:
            url = @"/FFD/MAMARIN5/FFDSpecialPriceProgramUpdate.php";
            break;
        case urlSpecialPriceProgramDelete:
            url = @"/FFD/MAMARIN5/FFDSpecialPriceProgramDelete.php";
            break;
        case urlSpecialPriceProgramInsertList:
            url = @"/FFD/MAMARIN5/FFDSpecialPriceProgramInsertList.php";
            break;
        case urlSpecialPriceProgramUpdateList:
            url = @"/FFD/MAMARIN5/FFDSpecialPriceProgramUpdateList.php";
            break;
        case urlSpecialPriceProgramDeleteList:
            url = @"/FFD/MAMARIN5/FFDSpecialPriceProgramDeleteList.php";
            break;
        case urlSpecialPriceProgramGetList:
            url = @"/FFD/MAMARIN5/FFDSpecialPriceProgramGetList.php";
            break;
        case urlMenuInsert:
            url = @"/FFD/MAMARIN5/FFDMenuInsert.php";
            break;
        case urlMenuUpdate:
            url = @"/FFD/MAMARIN5/FFDMenuUpdate.php";
            break;
        case urlMenuDelete:
            url = @"/FFD/MAMARIN5/FFDMenuDelete.php";
            break;
        case urlMenuInsertList:
            url = @"/FFD/MAMARIN5/FFDMenuInsertList.php";
            break;
        case urlMenuUpdateList:
            url = @"/FFD/MAMARIN5/FFDMenuUpdateList.php";
            break;
        case urlMenuDeleteList:
            url = @"/FFD/MAMARIN5/FFDMenuDeleteList.php";
            break;
        case urlMenuTypeInsert:
            url = @"/FFD/MAMARIN5/FFDMenuTypeInsert.php";
            break;
        case urlMenuTypeUpdate:
            url = @"/FFD/MAMARIN5/FFDMenuTypeUpdate.php";
            break;
        case urlMenuTypeDelete:
            url = @"/FFD/MAMARIN5/FFDMenuTypeDelete.php";
            break;
        case urlMenuTypeInsertList:
            url = @"/FFD/MAMARIN5/FFDMenuTypeInsertList.php";
            break;
        case urlMenuTypeUpdateList:
            url = @"/FFD/MAMARIN5/FFDMenuTypeUpdateList.php";
            break;
        case urlMenuTypeDeleteList:
            url = @"/FFD/MAMARIN5/FFDMenuTypeDeleteList.php";
            break;
        case urlMenuTypeAndSubMenuTypeInsert:
            url = @"/FFD/MAMARIN5/FFDMenuTypeAndSubMenuTypeInsert.php";
            break;
        case urlMenuIngredientInsert:
            url = @"/FFD/MAMARIN5/FFDMenuIngredientInsert.php";
            break;
        case urlMenuIngredientUpdate:
            url = @"/FFD/MAMARIN5/FFDMenuIngredientUpdate.php";
            break;
        case urlMenuIngredientDelete:
            url = @"/FFD/MAMARIN5/FFDMenuIngredientDelete.php";
            break;
        case urlMenuIngredientInsertList:
            url = @"/FFD/MAMARIN5/FFDMenuIngredientInsertList.php";
            break;
        case urlMenuIngredientUpdateList:
            url = @"/FFD/MAMARIN5/FFDMenuIngredientUpdateList.php";
            break;
        case urlMenuIngredientDeleteList:
            url = @"/FFD/MAMARIN5/FFDMenuIngredientDeleteList.php";
            break;
        case urlMenuAndMenuIngredientInsertList:
            url = @"/FFD/MAMARIN5/FFDMenuAndMenuIngredientInsertList.php";
            break;
        case urlIngredientTypeInsert:
            url = @"/FFD/MAMARIN5/FFDIngredientTypeInsert.php";
            break;
        case urlIngredientTypeUpdate:
            url = @"/FFD/MAMARIN5/FFDIngredientTypeUpdate.php";
            break;
        case urlIngredientTypeDelete:
            url = @"/FFD/MAMARIN5/FFDIngredientTypeDelete.php";
            break;
        case urlIngredientTypeInsertList:
            url = @"/FFD/MAMARIN5/FFDIngredientTypeInsertList.php";
            break;
        case urlIngredientTypeUpdateList:
            url = @"/FFD/MAMARIN5/FFDIngredientTypeUpdateList.php";
            break;
        case urlIngredientTypeDeleteList:
            url = @"/FFD/MAMARIN5/FFDIngredientTypeDeleteList.php";
            break;
        case urlIngredientInsert:
            url = @"/FFD/MAMARIN5/FFDIngredientInsert.php";
            break;
        case urlIngredientUpdate:
            url = @"/FFD/MAMARIN5/FFDIngredientUpdate.php";
            break;
        case urlIngredientDelete:
            url = @"/FFD/MAMARIN5/FFDIngredientDelete.php";
            break;
        case urlIngredientInsertList:
            url = @"/FFD/MAMARIN5/FFDIngredientInsertList.php";
            break;
        case urlIngredientUpdateList:
            url = @"/FFD/MAMARIN5/FFDIngredientUpdateList.php";
            break;
        case urlIngredientDeleteList:
            url = @"/FFD/MAMARIN5/FFDIngredientDeleteList.php";
            break;
        case urlSubMenuTypeInsert:
            url = @"/FFD/MAMARIN5/FFDSubMenuTypeInsert.php";
            break;
        case urlSubMenuTypeUpdate:
            url = @"/FFD/MAMARIN5/FFDSubMenuTypeUpdate.php";
            break;
        case urlSubMenuTypeDelete:
            url = @"/FFD/MAMARIN5/FFDSubMenuTypeDelete.php";
            break;
        case urlSubMenuTypeInsertList:
            url = @"/FFD/MAMARIN5/FFDSubMenuTypeInsertList.php";
            break;
        case urlSubMenuTypeUpdateList:
            url = @"/FFD/MAMARIN5/FFDSubMenuTypeUpdateList.php";
            break;
        case urlSubMenuTypeDeleteList:
            url = @"/FFD/MAMARIN5/FFDSubMenuTypeDeleteList.php";
            break;
        case urlSubMenuTypeAndMenuInsert:
            url = @"/FFD/MAMARIN5/FFDSubMenuTypeAndMenuInsert.php";
            break;
        case urlSubIngredientTypeInsert:
            url = @"/FFD/MAMARIN5/FFDSubIngredientTypeInsert.php";
            break;
        case urlSubIngredientTypeUpdate:
            url = @"/FFD/MAMARIN5/FFDSubIngredientTypeUpdate.php";
            break;
        case urlSubIngredientTypeDelete:
            url = @"/FFD/MAMARIN5/FFDSubIngredientTypeDelete.php";
            break;
        case urlSubIngredientTypeInsertList:
            url = @"/FFD/MAMARIN5/FFDSubIngredientTypeInsertList.php";
            break;
        case urlSubIngredientTypeUpdateList:
            url = @"/FFD/MAMARIN5/FFDSubIngredientTypeUpdateList.php";
            break;
        case urlSubIngredientTypeDeleteList:
            url = @"/FFD/MAMARIN5/FFDSubIngredientTypeDeleteList.php";
            break;
        case urlSubIngredientTypeAndIngredientInsert:
            url = @"/FFD/MAMARIN5/FFDSubIngredientTypeAndIngredientInsert.php";
            break;
        case urlIngredientTypeAndSubIngredientTypeInsert:
            url = @"/FFD/MAMARIN5/FFDIngredientTypeAndSubIngredientTypeInsert.php";
            break;
        case urlIngredientCheckInsert:
            url = @"/FFD/MAMARIN5/FFDIngredientCheckInsert.php";
            break;
        case urlIngredientCheckUpdate:
            url = @"/FFD/MAMARIN5/FFDIngredientCheckUpdate.php";
            break;
        case urlIngredientCheckDelete:
            url = @"/FFD/MAMARIN5/FFDIngredientCheckDelete.php";
            break;
        case urlIngredientCheckInsertList:
            url = @"/FFD/MAMARIN5/FFDIngredientCheckInsertList.php";
            break;
        case urlIngredientCheckUpdateList:
            url = @"/FFD/MAMARIN5/FFDIngredientCheckUpdateList.php";
            break;
        case urlIngredientCheckDeleteList:
            url = @"/FFD/MAMARIN5/FFDIngredientCheckDeleteList.php";
            break;
        case urlIngredientCheckGetList:
            url = @"/FFD/MAMARIN5/FFDIngredientCheckGetList.php";
            break;
        case urlIngredientNeededGetList:
            url = @"/FFD/MAMARIN5/FFDIngredientNeededGetList.php";
            break;
        case urlIngredientReceiveInsert:
            url = @"/FFD/MAMARIN5/FFDIngredientReceiveInsert.php";
            break;
        case urlIngredientReceiveUpdate:
            url = @"/FFD/MAMARIN5/FFDIngredientReceiveUpdate.php";
            break;
        case urlIngredientReceiveDelete:
            url = @"/FFD/MAMARIN5/FFDIngredientReceiveDelete.php";
            break;
        case urlIngredientReceiveInsertList:
            url = @"/FFD/MAMARIN5/FFDIngredientReceiveInsertList.php";
            break;
        case urlIngredientReceiveUpdateList:
            url = @"/FFD/MAMARIN5/FFDIngredientReceiveUpdateList.php";
            break;
        case urlIngredientReceiveDeleteList:
            url = @"/FFD/MAMARIN5/FFDIngredientReceiveDeleteList.php";
            break;
        case urlIngredientReceiveGetList:
            url = @"/FFD/MAMARIN5/FFDIngredientReceiveGetList.php";
            break;
        case urlReportSalesTransactionGetList:
            url = @"/FFD/MAMARIN5/FFDReportSalesTransactionGetList.php";
            break;
        case urlReportSalesEndDayGetList:
            url = @"/FFD/MAMARIN5/FFDReportSalesEndDayGetList.php";
            break;
        case urlReportSalesAllDailyGetList:
            url = @"/FFD/MAMARIN5/FFDReportSalesAllDailyGetList.php";
            break;
        case urlReportSalesAllWeeklyGetList:
            url = @"/FFD/MAMARIN5/FFDReportSalesAllWeeklyGetList.php";
            break;
        case urlReportSalesAllMonthlyGetList:
            url = @"/FFD/MAMARIN5/FFDReportSalesAllMonthlyGetList.php";
            break;
        case urlReportSalesByMenuTypeDailyGetList:
            url = @"/FFD/MAMARIN5/FFDReportSalesByMenuTypeDailyGetList.php";
            break;
        case urlReportSalesByMenuTypeWeeklyGetList:
            url = @"/FFD/MAMARIN5/FFDReportSalesByMenuTypeWeeklyGetList.php";
            break;
        case urlReportSalesByMenuTypeMonthlyGetList:
            url = @"/FFD/MAMARIN5/FFDReportSalesByMenuTypeMonthlyGetList.php";
            break;
        case urlReportSalesByMenuGetList:
            url = @"/FFD/MAMARIN5/FFDReportSalesByMenuGetList.php";
            break;
        case urlReportSalesByMemberGetList:
            url = @"/FFD/MAMARIN5/FFDReportSalesByMemberGetList.php";
            break;
        case urlOrderTakingOrderNoteOrderKitchenGetList:
            url = @"/FFD/MAMARIN5/FFDOrderTakingOrderNoteOrderKitchenGetList.php";
            break;
        case urlOrderTakingOrderNoteOrderKitchenReceiptInsertList:
            url = @"/FFD/MAMARIN5/FFDOrderTakingOrderNoteOrderKitchenReceiptInsertList.php";
            break;
        case urlOrderTakingOrderNoteOrderKitchenReceiptAndReceiptNoInsertList:
            url = @"/FFD/MAMARIN5/FFDOrderTakingOrderNoteOrderKitchenReceiptAndReceiptNoInsertList.php";
            break;
        case urlOrderTakingOrderNoteOrderKitchenCustomerTableInsertList:
            url = @"/FFD/MAMARIN5/FFDOrderTakingOrderNoteOrderKitchenCustomerTableInsertList.php";
            break;
        case urlOrderTakingOrderKitchenTableTakingReceiptUpdateList:
            url = @"/FFD/MAMARIN5/FFDOrderTakingOrderKitchenTableTakingReceiptUpdateList.php";
            break;
        case urlOrderTakingOrderNoteOrderKitchenCancelOrderInsertUpdateList:
            url = @"/FFD/MAMARIN5/FFDOrderTakingOrderNoteOrderKitchenCancelOrderInsertUpdateList.php";
            break;
        case urlOrderTakingOrderNoteOrderKitchenOrderCancelDiscountInsertUpdateList:
            url = @"/FFD/MAMARIN5/FFDOrderTakingOrderNoteOrderKitchenOrderCancelDiscountInsertUpdateList.php";
            break;
        case urlNoteTypeInsert:
            url = @"/FFD/MAMARIN5/FFDNoteTypeInsert.php";
            break;
        case urlNoteTypeUpdate:
            url = @"/FFD/MAMARIN5/FFDNoteTypeUpdate.php";
            break;
        case urlNoteTypeDelete:
            url = @"/FFD/MAMARIN5/FFDNoteTypeDelete.php";
            break;
        case urlNoteTypeInsertList:
            url = @"/FFD/MAMARIN5/FFDNoteTypeInsertList.php";
            break;
        case urlNoteTypeUpdateList:
            url = @"/FFD/MAMARIN5/FFDNoteTypeUpdateList.php";
            break;
        case urlNoteTypeDeleteList:
            url = @"/FFD/MAMARIN5/FFDNoteTypeDeleteList.php";
            break;
        case urlReceiptAndReceiptNoTaxPrintInsert:
            url = @"/FFD/MAMARIN5/FFDReceiptAndReceiptNoTaxPrintInsert.php";
            break;
        case urlUserTabMenuInsert:
            url = @"/FFD/MAMARIN5/FFDUserTabMenuInsert.php";
            break;
        case urlUserTabMenuUpdate:
            url = @"/FFD/MAMARIN5/FFDUserTabMenuUpdate.php";
            break;
        case urlUserTabMenuDelete:
            url = @"/FFD/MAMARIN5/FFDUserTabMenuDelete.php";
            break;
        case urlUserTabMenuInsertList:
            url = @"/FFD/MAMARIN5/FFDUserTabMenuInsertList.php";
            break;
        case urlUserTabMenuUpdateList:
            url = @"/FFD/MAMARIN5/FFDUserTabMenuUpdateList.php";
            break;
        case urlUserTabMenuDeleteList:
            url = @"/FFD/MAMARIN5/FFDUserTabMenuDeleteList.php";
            break;
        case urlBoardInsert:
            url = @"/FFD/MAMARIN5/FFDBoardInsert.php";
            break;
        case urlBoardUpdate:
            url = @"/FFD/MAMARIN5/FFDBoardUpdate.php";
            break;
        case urlBoardDelete:
            url = @"/FFD/MAMARIN5/FFDBoardDelete.php";
            break;
        case urlBoardInsertList:
            url = @"/FFD/MAMARIN5/FFDBoardInsertList.php";
            break;
        case urlBoardUpdateList:
            url = @"/FFD/MAMARIN5/FFDBoardUpdateList.php";
            break;
        case urlBoardDeleteList:
            url = @"/FFD/MAMARIN5/FFDBoardDeleteList.php";
            break;
        case urlMergeReceiptCloseTableInsert:
            url = @"/FFD/MAMARIN5/FFDMergeReceiptCloseTableInsert.php";
            break;
        case urlReceiptCloseTableUpdate:
            url = @"/FFD/MAMARIN5/FFDReceiptCloseTableUpdate.php";
            break;
        case urlBillPrintInsert:
            url = @"/FFD/MAMARIN5/FFDBillPrintInsert.php";
            break;
        case urlBillPrintUpdate:
            url = @"/FFD/MAMARIN5/FFDBillPrintUpdate.php";
            break;
        case urlBillPrintDelete:
            url = @"/FFD/MAMARIN5/FFDBillPrintDelete.php";
            break;
        case urlBillPrintInsertList:
            url = @"/FFD/MAMARIN5/FFDBillPrintInsertList.php";
            break;
        case urlBillPrintUpdateList:
            url = @"/FFD/MAMARIN5/FFDBillPrintUpdateList.php";
            break;
        case urlBillPrintDeleteList:
            url = @"/FFD/MAMARIN5/FFDBillPrintDeleteList.php";
            break;
        case urlPaySplitBillInsert:
            url = @"/FFD/MAMARIN5/FFDPaySplitBillInsert.php";
            break;
        case urlPaySplitBillInsertWithoutReceipt:
            url = @"/FFD/MAMARIN5/FFDPaySplitBillInsertWithoutReceipt.php";
            break;
        case urlPaySplitBillInsertAfterFirstTime:
            url = @"/FFD/MAMARIN5/FFDPaySplitBillInsertAfterFirstTime.php";
            break;
        case urlPaySplitBillInsertLastOne:
            url = @"/FFD/MAMARIN5/FFDPaySplitBillInsertLastOne.php";
            break;
        case urlTableTakingOrderTakingReceiptUpdateDelete:
            url = @"/FFD/MAMARIN5/FFDTableTakingOrderTakingReceiptUpdateDelete.php";
            break;
        case urlTableTakingReceiptOrderTakingListUpdate:
            url = @"/FFD/MAMARIN5/FFDTableTakingReceiptOrderTakingListUpdate.php";
            break;
        case urlMoveOrderInsert:
            url = @"/FFD/MAMARIN5/FFDMoveOrderInsert.php";
            break;
        case urlMoveOrderUpdate:
            url = @"/FFD/MAMARIN5/FFDMoveOrderUpdate.php";
            break;
        case urlOrderCancelDiscountInsert:
            url = @"/FFD/MAMARIN5/FFDOrderCancelDiscountInsert.php";
            break;
        case urlOrderCancelDiscountUpdate:
            url = @"/FFD/MAMARIN5/FFDOrderCancelDiscountUpdate.php";
            break;
        case urlOrderCancelDiscountDelete:
            url = @"/FFD/MAMARIN5/FFDOrderCancelDiscountDelete.php";
            break;
        case urlOrderCancelDiscountInsertList:
            url = @"/FFD/MAMARIN5/FFDOrderCancelDiscountInsertList.php";
            break;
        case urlOrderCancelDiscountUpdateList:
            url = @"/FFD/MAMARIN5/FFDOrderCancelDiscountUpdateList.php";
            break;
        case urlOrderCancelDiscountDeleteList:
            url = @"/FFD/MAMARIN5/FFDOrderCancelDiscountDeleteList.php";
            break;
        case urlOrderCancelDiscountOrderTakingInsertList:
            url = @"/FFD/MAMARIN5/FFDOrderCancelDiscountOrderTakingInsertList.php";
            break;
        case urlPrinterInsert:
            url = @"/FFD/MAMARIN5/FFDPrinterInsert.php";
            break;
        case urlPrinterUpdate:
            url = @"/FFD/MAMARIN5/FFDPrinterUpdate.php";
            break;
        case urlPrinterDelete:
            url = @"/FFD/MAMARIN5/FFDPrinterDelete.php";
            break;
        case urlPrinterInsertList:
            url = @"/FFD/MAMARIN5/FFDPrinterInsertList.php";
            break;
        case urlPrinterUpdateList:
            url = @"/FFD/MAMARIN5/FFDPrinterUpdateList.php";
            break;
        case urlPrinterDeleteList:
            url = @"/FFD/MAMARIN5/FFDPrinterDeleteList.php";
            break;
        case urlRoleTabMenuInsert:
            url = @"/FFD/MAMARIN5/FFDRoleTabMenuInsert.php";
            break;
        case urlRoleTabMenuUpdate:
            url = @"/FFD/MAMARIN5/FFDRoleTabMenuUpdate.php";
            break;
        case urlRoleTabMenuDelete:
            url = @"/FFD/MAMARIN5/FFDRoleTabMenuDelete.php";
            break;
        case urlRoleTabMenuInsertList:
            url = @"/FFD/MAMARIN5/FFDRoleTabMenuInsertList.php";
            break;
        case urlRoleTabMenuUpdateList:
            url = @"/FFD/MAMARIN5/FFDRoleTabMenuUpdateList.php";
            break;
        case urlRoleTabMenuDeleteList:
            url = @"/FFD/MAMARIN5/FFDRoleTabMenuDeleteList.php";
            break;
        case urlTabMenuInsert:
            url = @"/FFD/MAMARIN5/FFDTabMenuInsert.php";
            break;
        case urlTabMenuUpdate:
            url = @"/FFD/MAMARIN5/FFDTabMenuUpdate.php";
            break;
        case urlTabMenuDelete:
            url = @"/FFD/MAMARIN5/FFDTabMenuDelete.php";
            break;
        case urlTabMenuInsertList:
            url = @"/FFD/MAMARIN5/FFDTabMenuInsertList.php";
            break;
        case urlTabMenuUpdateList:
            url = @"/FFD/MAMARIN5/FFDTabMenuUpdateList.php";
            break;
        case urlTabMenuDeleteList:
            url = @"/FFD/MAMARIN5/FFDTabMenuDeleteList.php";
            break;
        case urlMoneyCheckInsert:
            url = @"/FFD/MAMARIN5/FFDMoneyCheckInsert.php";
            break;
        case urlMoneyCheckUpdate:
            url = @"/FFD/MAMARIN5/FFDMoneyCheckUpdate.php";
            break;
        case urlMoneyCheckDelete:
            url = @"/FFD/MAMARIN5/FFDMoneyCheckDelete.php";
            break;
        case urlMoneyCheckInsertList:
            url = @"/FFD/MAMARIN5/FFDMoneyCheckInsertList.php";
            break;
        case urlMoneyCheckUpdateList:
            url = @"/FFD/MAMARIN5/FFDMoneyCheckUpdateList.php";
            break;
        case urlMoneyCheckDeleteList:
            url = @"/FFD/MAMARIN5/FFDMoneyCheckDeleteList.php";
            break;
        case urlMoneyCheckInsertAndSendEmail:
            url = @"/FFD/MAMARIN5/FFDMoneyCheckInsertAndSendEmail.php";
            break;
        case urlMoneyCheckInsertListAndSendEmail:
            url = @"/FFD/MAMARIN5/FFDMoneyCheckInsertListAndSendEmail.php";
            break;
        case urlBranchInsert:
            url = @"/FFD/MAMARIN5/FFDBranchInsert.php";
            break;
        case urlBranchUpdate:
            url = @"/FFD/MAMARIN5/FFDBranchUpdate.php";
            break;
        case urlBranchDelete:
            url = @"/FFD/MAMARIN5/FFDBranchDelete.php";
            break;
        case urlBranchInsertList:
            url = @"/FFD/MAMARIN5/FFDBranchInsertList.php";
            break;
        case urlBranchUpdateList:
            url = @"/FFD/MAMARIN5/FFDBranchUpdateList.php";
            break;
        case urlBranchDeleteList:
            url = @"/FFD/MAMARIN5/FFDBranchDeleteList.php";
            break;
        case urlBranchGet:
            url = @"/FFD/MAMARIN5/FFDBranchGet.php";
            break;
        case urlReceiptSummaryGetList:
            url = @"/FFD/MAMARIN5/JMMReceiptSummaryGetList.php";
            break;
        case urlReceiptPrintInsert:
            url = @"/FFD/MAMARIN5/FFDReceiptPrintInsert.php";
            break;
        case urlReceiptPrintUpdate:
            url = @"/FFD/MAMARIN5/FFDReceiptPrintUpdate.php";
            break;
        case urlReceiptPrintDelete:
            url = @"/FFD/MAMARIN5/FFDReceiptPrintDelete.php";
            break;
        case urlReceiptPrintInsertList:
            url = @"/FFD/MAMARIN5/FFDReceiptPrintInsertList.php";
            break;
        case urlReceiptPrintUpdateList:
            url = @"/FFD/MAMARIN5/FFDReceiptPrintUpdateList.php";
            break;
        case urlReceiptPrintDeleteList:
            url = @"/FFD/MAMARIN5/FFDReceiptPrintDeleteList.php";
            break;
        case urlJummumReceiptGetList:
            url = @"/FFD/MAMARIN5/FFDJummumReceiptGetList.php";
            break;
        case urlJummumReceiptUpdate:
            url = @"/FFD/MAMARIN5/FFDJummumReceiptUpdate.php";
            break;
        case urlDisputeReasonGetList:
            url = @"/FFD/MAMARIN5/JMMDisputeReasonGetList.php";
            break;
        case urlDisputeInsert:
            url = @"/FFD/MAMARIN5/JMMDisputeInsert.php";
            break;
        default:
            break;
    }
    url = [NSString stringWithFormat:@"%@%@", [self domainName],url];
    return url;
}

+ (NSString *) appendRandomParam:(NSString *)url
{
    return [NSString stringWithFormat:@"%@?%@&",url,[Utility randomStringWithLength:6]];
}

+ (NSString *) formatDate:(NSString *)strDate fromFormat:(NSString *)fromFormat toFormat:(NSString *)toFormat
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];//local time +7
    df.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//year christ
    df.dateStyle = NSDateFormatterMediumStyle;
    df.dateFormat = fromFormat;
    NSDate *date  = [df dateFromString:strDate];
    
    // Convert to new Date Format
    [df setDateFormat:toFormat];///////uncomment dont forget
    
    //must set timezone to normal
    NSString *newStrDate = [df stringFromDate:date];
    return newStrDate;
}

+ (nullable NSDate *) stringToDate:(NSString *)strDate fromFormat:(NSString *)fromFormat
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];//local time +7
    df.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//year christ
    df.dateStyle = NSDateFormatterMediumStyle;
    df.dateFormat = fromFormat;
    
    NSDate *date = [df dateFromString:strDate];
    return date;
}

+ (NSString *) dateToString:(NSDate *)date toFormat:(NSString *)toFormat
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];//local time +7
    df.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//year christ
    df.dateStyle = NSDateFormatterMediumStyle;
    df.dateFormat = toFormat;
    
    
    NSString *strDate = [df stringFromDate:date];
    if(!strDate)
    {
        strDate = @"";
    }
    return strDate;
}

+ (NSDate *) setDateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:day];
    [comps setMonth:month];
    [comps setYear:year];
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:comps];
    return date;
}

+(NSString *)modifiedUser
{
    return globalModifiedUser;
}

+(void)setModifiedUser:(NSString *)modifiedUser
{
    globalModifiedUser = modifiedUser;
}

+ (NSInteger) numberOfDaysFromDate:(NSDate *)dateFrom dateTo:(NSDate *)dateTo
{
    NSTimeInterval secondsBetween = [dateTo timeIntervalSinceDate:dateFrom];
    int numberOfDays = secondsBetween / 86400 + 1;
    return numberOfDays;
}

+ (NSDate *) dateFromDateTime:(NSDate *)dateTime
{
    NSDateComponents *components = [[NSCalendar currentCalendar]
                                    components:NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay
                                    fromDate:dateTime];
    NSDate *date = [[NSCalendar currentCalendar]
                    dateFromComponents:components];
    
    return date;
}

+ (NSInteger) dayFromDateTime:(NSDate *)dateTime
{
    NSDateComponents *components = [[NSCalendar currentCalendar]
                                    components:NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay
                                    fromDate:dateTime];
    
    NSInteger day = [components day];
    return day;
}

+ (NSDate *) GMTDate:(NSDate *)dateTime
{
    NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
    NSDate *dateTimeInLocalTimezone = [dateTime dateByAddingTimeInterval:timeZoneSeconds];
    
    return dateTimeInLocalTimezone;
}

+ (NSDate *) currentDateTime
{
    return [Utility GMTDate:[NSDate date]];
}

+ (NSString *)percentEscapeString:(NSString *)string
{
    NSString *result = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                 (CFStringRef)string,
                                                                                 (CFStringRef)@" ",
                                                                                 (CFStringRef)@":/?@!$&'()*+,;=",
                                                                                 kCFStringEncodingUTF8));
    return [result stringByReplacingOccurrencesOfString:@" " withString:@"+"];
}

+ (NSString *)concatParameter:(NSDictionary *)condition
{
    NSString *value;
    NSString *urlParameter = @"";
    for(id key in condition)
    {
        value = [condition objectForKey:key];
        urlParameter = [NSString stringWithFormat:@"%@&%@=%@",urlParameter,key,value];
    }
    
    NSRange needleRange = NSMakeRange(1,[urlParameter length]-1);
    urlParameter = [urlParameter substringWithRange:needleRange];
    
    return urlParameter;
}

+ (NSString *) getNoteDataString: (NSObject *)object
{
    NSMutableDictionary *dicCondition = [[NSMutableDictionary alloc]init];
    
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList([object class], &propertyCount);
    
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [object valueForKey:key];
        
        NSString *escapeString = value;
        if(![value isKindOfClass:NSClassFromString(@"__NSCFNumber")] && ![value isKindOfClass:NSClassFromString(@"__NSCFBoolean")] && ![value isKindOfClass:NSClassFromString(@"__NSTaggedDate")]  && ![value isKindOfClass:NSClassFromString(@"__NSDate")]){//__NSCFConstantString //__NSCFNumber  //__NSCFString //
            NSString *trimString;
            if(![value isEqual:[NSNull null]] && [value length]>0)
            {
                trimString = [Utility trimString:escapeString];
            }
            else
            {
                trimString = @"";
            }
            
            escapeString = [self percentEscapeString:trimString];//สำหรับส่ง ให้ php script
        }
        
        [dicCondition setValue:escapeString forKey:key];
    }
    free(properties);
    
    return [self concatParameter:dicCondition];
}

+ (NSString *) getNoteDataString: (NSObject *)object withRunningNo:(long)runningNo
{
    NSMutableDictionary *dicCondition = [[NSMutableDictionary alloc]init];
    
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList([object class], &propertyCount);
    
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [object valueForKey:key];
        
        NSString *escapeString = value;
        if(![value isKindOfClass:NSClassFromString(@"__NSCFNumber")] && ![value isKindOfClass:NSClassFromString(@"__NSCFBoolean")] && ![value isKindOfClass:NSClassFromString(@"__NSTaggedDate")] && ![value isKindOfClass:NSClassFromString(@"__NSDate")]){//__NSCFConstantString //__NSCFNumber  //__NSCFString //
            NSString *trimString = [Utility trimString:escapeString];
            escapeString = [self percentEscapeString:trimString];//สำหรับส่ง ให้ php script
        }
        key = [NSString stringWithFormat:@"%@%02ld",key,runningNo];
        [dicCondition setValue:escapeString forKey:key];
    }
    free(properties);
    
    return [self concatParameter:dicCondition];
}

+ (NSString *) getNoteDataString: (NSObject *)object withRunningNo3Digit:(long)runningNo
{
    NSMutableDictionary *dicCondition = [[NSMutableDictionary alloc]init];
    
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList([object class], &propertyCount);
    
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [object valueForKey:key];
        
        NSString *escapeString = value;
        if(![value isKindOfClass:NSClassFromString(@"__NSCFNumber")] && ![value isKindOfClass:NSClassFromString(@"__NSCFBoolean")] && ![value isKindOfClass:NSClassFromString(@"__NSTaggedDate")] && ![value isKindOfClass:NSClassFromString(@"__NSDate")]){//__NSCFConstantString //__NSCFNumber  //__NSCFString //
            NSString *trimString = [Utility trimString:escapeString];
            escapeString = [self percentEscapeString:trimString];//สำหรับส่ง ให้ php script
        }
        key = [NSString stringWithFormat:@"%@%03ld",key,runningNo];
        [dicCondition setValue:escapeString forKey:key];
    }
    free(properties);
    
    return [self concatParameter:dicCondition];
}
+ (NSString *) getNoteDataString: (NSObject *)object withPrefix:(NSString *)prefix
{
    NSMutableDictionary *dicCondition = [[NSMutableDictionary alloc]init];
    
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList([object class], &propertyCount);
    
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [object valueForKey:key];
        
        NSString *escapeString = value;
        if(![value isKindOfClass:NSClassFromString(@"__NSCFNumber")] && ![value isKindOfClass:NSClassFromString(@"__NSCFBoolean")] && ![value isKindOfClass:NSClassFromString(@"__NSTaggedDate")]  && ![value isKindOfClass:NSClassFromString(@"__NSDate")]){//__NSCFConstantString //__NSCFNumber  //__NSCFString //
            NSString *trimString;
            if(![value isEqual:[NSNull null]] && [value length]>0)
            {
                trimString = [Utility trimString:escapeString];
            }
            else
            {
                trimString = @"";
            }
            
            escapeString = [self percentEscapeString:trimString];//สำหรับส่ง ให้ php script
        }
        
        NSString *keyWithPrefix = [NSString stringWithFormat:@"%@%@",prefix,[self makeFirstLetterUpperCase:key]];
        [dicCondition setValue:escapeString forKey:keyWithPrefix];
    }
    free(properties);
    
    return [self concatParameter:dicCondition];
}
+ (NSString *) getNoteDataString: (NSObject *)object withPrefix:(NSString *)prefix runningNo:(long)runningNo
{
    NSMutableDictionary *dicCondition = [[NSMutableDictionary alloc]init];
    
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList([object class], &propertyCount);
    
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [object valueForKey:key];
        
        NSString *escapeString = value;
        if(![value isKindOfClass:NSClassFromString(@"__NSCFNumber")] && ![value isKindOfClass:NSClassFromString(@"__NSCFBoolean")] && ![value isKindOfClass:NSClassFromString(@"__NSTaggedDate")]  && ![value isKindOfClass:NSClassFromString(@"__NSDate")]){//__NSCFConstantString //__NSCFNumber  //__NSCFString //
            NSString *trimString;
            if(![value isEqual:[NSNull null]] && [value length]>0)
            {
                trimString = [Utility trimString:escapeString];
            }
            else
            {
                trimString = @"";
            }
            
            escapeString = [self percentEscapeString:trimString];//สำหรับส่ง ให้ php script
        }
        
        NSString *keyWithPrefix = [NSString stringWithFormat:@"%@%@%02ld",prefix,[self makeFirstLetterUpperCase:key],runningNo];
        [dicCondition setValue:escapeString forKey:keyWithPrefix];
    }
    free(properties);
    
    return [self concatParameter:dicCondition];
}
+ (NSObject *) trimAndFixEscapeString: (NSObject *)object
{
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList([object class], &propertyCount);
    
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        NSString *key = [NSString stringWithUTF8String:name];
        
        id value = [object valueForKey:key];
        
        NSString *escapeString = value;
        if(![value isKindOfClass:NSClassFromString(@"__NSCFNumber")]){
            NSString *trimString = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            escapeString = [self percentEscapeString:trimString];
        }
        [object setValue:escapeString forKey:key];
    }
    free(properties);
    
    return object;
}

+ (NSString *)formatDecimal:(float)number
{
    NSNumberFormatter *formatterBaht = [[NSNumberFormatter alloc]init];
    [formatterBaht setNumberStyle:NSNumberFormatterDecimalStyle];
    formatterBaht.minimumFractionDigits = 0;
    formatterBaht.maximumFractionDigits = 2;
    NSString *strFormattedBaht = [formatterBaht stringFromNumber:[NSNumber numberWithFloat:number]];
    return strFormattedBaht;
}

+ (NSString *)formatDecimal:(float)number withMinFraction:(NSInteger)min andMaxFraction:(NSInteger)max
{
    NSNumberFormatter *formatterBaht = [[NSNumberFormatter alloc]init];
    [formatterBaht setNumberStyle:NSNumberFormatterDecimalStyle];
    formatterBaht.minimumFractionDigits = min;
    formatterBaht.maximumFractionDigits = max;
    NSString *strFormattedBaht = [formatterBaht stringFromNumber:[NSNumber numberWithFloat:number]];
    return strFormattedBaht;
}

+ (NSString *)trimString:(NSString *)text
{
    if([text length] != 0)
    {
        text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    return text;
}

+ (NSString *)setPhoneNoFormat:(NSString *)text
{
    if(!text)
    {
        return @"";
    }
    if([text length] == 10)
    {
        NSMutableString *mu = [NSMutableString stringWithString:text];
        [mu insertString:@"-" atIndex:3];
        [mu insertString:@"-" atIndex:7];
        return [NSString stringWithString:mu];
    }
    else if([text length] > 10)
    {
        NSString *strPhoneNo = @"";
        NSArray *arrPhoneNo = [text componentsSeparatedByString:@","];
        for(int i=0; i<[arrPhoneNo count]; i++)
        {
            if(i==0)
            {
                strPhoneNo = [self setPhoneNoFormat:arrPhoneNo[i]];
            }
            else
            {
                strPhoneNo = [NSString stringWithFormat:@"%@,%@",strPhoneNo,[self setPhoneNoFormat:arrPhoneNo[i]]];
            }
        }
        return strPhoneNo;
    }
    return text;
}
+ (NSString *)removeDashAndSpaceAndParenthesis:(NSString *)text
{
    text = [text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"(" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@")" withString:@""];
    return text;
}
+ (NSString *)removeComma:(NSString *)text
{
    text = [text stringByReplacingOccurrencesOfString:@"," withString:@""];
    return text;
}
+ (NSString *)removeApostrophe:(NSString *)text
{
    text = [text stringByReplacingOccurrencesOfString:@"'" withString:@""];
    return text;
}
+ (NSString *)removeKeyword:(NSArray *)arrKeyword text:(NSString *)text
{
    for(NSString *keyword in arrKeyword)
    {
        text = [text stringByReplacingOccurrencesOfString:keyword withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [text length])];
    }
    
    return text;
}

+ (NSData *)dataFromHexString:(NSString *)string
{
    string = [string lowercaseString];
    NSMutableData *data= [NSMutableData new];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i = 0;
    NSInteger length = string.length;
    while (i < length-1) {
        char c = [string characterAtIndex:i++];
        if (c < '0' || (c > '9' && c < 'a') || c > 'f')
            continue;
        byte_chars[0] = c;
        byte_chars[1] = [string characterAtIndex:i++];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    return data;
}

+ (NSString *)makeFirstLetterLowerCase:(NSString *)text
{
    NSRange needleRange;
    needleRange = NSMakeRange(0,1);
    NSString *firstLetter = [text substringWithRange:needleRange];
    needleRange = NSMakeRange(1,[text length]-1);
    NSString *theRestLetters = [text substringWithRange:needleRange];
    return [NSString stringWithFormat:@"%@%@",[firstLetter lowercaseString],theRestLetters];
}

+ (NSString *)makeFirstLetterUpperCase:(NSString *)text
{
    NSRange needleRange;
    needleRange = NSMakeRange(0,1);
    NSString *firstLetter = [text substringWithRange:needleRange];
    needleRange = NSMakeRange(1,[text length]-1);
    NSString *theRestLetters = [text substringWithRange:needleRange];
    return [NSString stringWithFormat:@"%@%@",[firstLetter uppercaseString],theRestLetters];
}

+ (NSString *)makeFirstLetterUpperCaseOtherLower:(NSString *)text
{
    NSRange needleRange;
    needleRange = NSMakeRange(0,1);
    NSString *firstLetter = [text substringWithRange:needleRange];
    needleRange = NSMakeRange(1,[text length]-1);
    NSString *theRestLetters = [text substringWithRange:needleRange];
    return [NSString stringWithFormat:@"%@%@",[firstLetter uppercaseString],[theRestLetters lowercaseString]];
}

+ (NSString *)getPrimaryKeyFromClassName:(NSString *)className
{
    NSRange needleRange;
    needleRange = NSMakeRange(0,1);
    NSString *firstLetter = [className substringWithRange:needleRange];
    needleRange = NSMakeRange(1,[className length]-1);
    NSString *theRestLetter = [className substringWithRange:needleRange];
    return [NSString stringWithFormat:@"%@%@ID",[firstLetter lowercaseString],theRestLetter];
}

+ (NSString *)getMasterClassName:(NSInteger)i
{
    NSArray *arrMasterClass = @[@"UserAccount",@"LogIn",@"CustomerTable",@"MenuType",@"Menu",@"TableTaking",@"OrderTaking",@"MenuTypeNote",@"Note",@"OrderNote",@"OrderKitchen",@"Member",@"SubMenuType",@"Address",@"Receipt",@"Discount",@"Setting",@"RewardProgram",@"RewardPoint",@"ReceiptCustomerTable",@"SpecialPriceProgram",@"MenuIngredient",@"IngredientType",@"Ingredient",@"SubIngredientType",@"NoteType",@"Board",@"BillPrint",@"OrderCancelDiscount",@"Printer",@"RoleTabMenu",@"TabMenu",@"SubDistrict",@"District",@"Province",@"ZipCode",@"MoneyCheck",@"Receipt",@"OrderTaking",@"OrderNote",@"Dispute",@"ReceiptPrint",@"DisputeReason"];
    
    
    return arrMasterClass[i];
}

+ (NSString *)getMasterClassName:(NSInteger)i from:(NSArray *)arrClassName
{
    return arrClassName[i];
}

+ (BOOL)isNumeric:(NSString *)text
{
    if([text isKindOfClass:[NSString class]])
    {
        NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        if ([text rangeOfCharacterFromSet:notDigits].location == NSNotFound)
        {
            // newString consists only of the digits 0 through 9
            return YES;
        }
    }
    
    return NO;
}

+(NSString *)getSqlFailTitle
{
    return @"Error occur";
}
+(NSString *)getSqlFailMessage
{
    return @"Please check recent transactions again";
}

+(NSString *)getConnectionLostTitle
{
    return @"Connection lost";
}
+(NSString *)getConnectionLostMessage
{
    return @"The network connection was lost";
}
+(NSInteger)getNumberOfRowForExecuteSql
{
    return 30;
}
//+(NSString *)getAppKey
//{
//    NSString *appKey;
//    NSString *dbName = @"SAIM";
//    NSString *strDBName = [NSString stringWithFormat:@"/%@/",dbName];
//    if([@"/FFD/MAMARIN5/" isEqualToString:strDBName])
//    {
//        appKey = @"wzksbywfw7kg52k";
//    }
//    else
//    {
//        //        appKey = @"0zoszvv007lfx4x";
//        appKey = @"j7s3q4s6ludo5dz";
//    }
//
//    return appKey;
//}
//+(NSString *)getAppSecret
//{
//    NSString *appSecret;
//    NSString *dbName = @"SAIM";
//    NSString *strDBName = [NSString stringWithFormat:@"/%@/",dbName];
//    if([@"/FFD/MAMARIN5/" isEqualToString:strDBName])
//    {
//        appSecret = @"rny8l0357sss0pn";
//    }
//    else
//    {
//        appSecret = @"cwq0v9grdruvfqx";
//    }
//
//    return appSecret;
//}

+(NSInteger)getScanTimeInterVal
{
    return 4;
}
+(NSInteger)getScanTimeInterValCaseBlur
{
    return 2;
}

+ (float)floatValue:(NSString *)text
{
    return [[self removeComma:text] floatValue];
}

+ (NSInteger)getLastDayOfMonth:(NSDate *)datetime;
{
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSRange daysRange =
    [currentCalendar
     rangeOfUnit:NSCalendarUnitDay
     inUnit:NSCalendarUnitMonth
     forDate:datetime];
    
    // daysRange.length will contain the number of the last day
    // of the month containing curDate
    
    return daysRange.length;
}

+ (void)itemsSynced:(NSString *)type action:(NSString *)action data:(NSArray *)data
{
    NSLog(@"items synced table:%@",type);
    NSString *className = type;
    NSString *strNameID = [Utility getPrimaryKeyFromClassName:type];
    
    
    Class class = NSClassFromString([NSString stringWithFormat:@"Shared%@",className]);
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"shared%@",className]);
    SEL selectorList = NSSelectorFromString([NSString stringWithFormat:@"%@List",[Utility makeFirstLetterLowerCase:className]]);
    NSMutableArray *dataList = [[class performSelector:selector] performSelector:selectorList];
    
    
    //insert,update,delete data
    for(int i=0; i<[data count]; i++)
    {
        NSDictionary *jsonElement = data[i];
        NSObject *object = [[NSClassFromString(className) alloc] init];
        
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
        
        
        if([action isEqualToString:@"u"])
        {
            for(NSObject *item in dataList)
            {
                if([[item valueForKey:strNameID] integerValue] == [[object valueForKey:strNameID] integerValue])
                {
                    unsigned int propertyCount = 0;
                    objc_property_t * properties = class_copyPropertyList([item class], &propertyCount);
                    
                    for (unsigned int i = 0; i < propertyCount; ++i)
                    {
                        objc_property_t property = properties[i];
                        const char * name = property_getName(property);
                        NSString *key = [NSString stringWithUTF8String:name];
                        
                        if([type isEqualToString:@"UserAccount"] && [key isEqualToString:@"deviceToken"])
                        {
                            NSLog(@"UserAccount deviceToken from push: (%@,%@)",key,[object valueForKey:key]);
                        }
                        [item setValue:[object valueForKey:key] forKey:key];
                    }
                    break;
                }
            }
        }
        else if([action isEqualToString:@"i"])
        {
            [self addObjectIfNotDuplicate:object];
//            if(![Utility duplicate:object])
//            {
//                [dataList addObject:object];
//            }
//            
        }
        else if([action isEqualToString:@"d"])
        {
            //////////
            for(NSObject *item in dataList)
            {
                //replaceSelf ถ้าเท่ากับ 1 ให้ เช็ค column modifiedUser = ตัวเอง ถึงจะมองว่า match (ที่ให้เช็คไม่เท่ากับตัวเอง เนื่องจากแก้ปัญหา duplicate key ตอน insert พร้อมกัน 2 เครื่อง เราดึงข้อมูลของตัวที่ insert ก่อนเข้ามา เพื่อมาลบตัว insert ทีหลังออก แล้ว insert ตัวหลังด้วย ID ใหม่แทน)
                //ถ้าเท่ากับ 0 ให้ remove item โดยการเช็ค ID ตามปกติ
                
                
                BOOL match = [[item valueForKey:strNameID] integerValue] == [[object valueForKey:strNameID] integerValue];
                
                if([[object valueForKey:@"replaceSelf"] integerValue]==1)
                {
                    match = match && [[item valueForKey:@"modifiedUser"] isEqualToString:[object valueForKey:@"modifiedUser"]];
                    
                    
                }
                
                
                if(match)
                {
                    [dataList removeObject:item];
                    break;
                }
            }
        }
    }
}

+ (BOOL)duplicate:(NSObject *)object
{
    Class classDB = [object class];
    NSString *className = NSStringFromClass(classDB);
    Class class = NSClassFromString([NSString stringWithFormat:@"Shared%@",className]);
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"shared%@",className]);
    SEL selectorList = NSSelectorFromString([NSString stringWithFormat:@"%@List",[Utility makeFirstLetterLowerCase:className]]);
    NSMutableArray *dataList = [[class performSelector:selector] performSelector:selectorList];
    
    
    NSString *propertyName = [NSString stringWithFormat:@"%@ID",[Utility makeFirstLetterLowerCase:className]];
    NSString *propertyNamePredicate = [NSString stringWithFormat:@"_%@",propertyName];
    NSInteger value = [[object valueForKey:propertyName] integerValue];
    NSString *modifiedUser = [object valueForKey:@"modifiedUser"];
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %ld and _modifiedUser = %@",propertyNamePredicate,value,modifiedUser];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    
    return [filterArray count]>0;
}

+ (void)addObjectIfNotDuplicate:(NSObject *)object
{
    Class classDB = [object class];
    NSString *className = NSStringFromClass(classDB);
    Class class = NSClassFromString([NSString stringWithFormat:@"Shared%@",className]);
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"shared%@",className]);
    SEL selectorList = NSSelectorFromString([NSString stringWithFormat:@"%@List",[Utility makeFirstLetterLowerCase:className]]);
    NSMutableArray *dataList = [[class performSelector:selector] performSelector:selectorList];
    
    
    NSString *propertyName = [NSString stringWithFormat:@"%@ID",[Utility makeFirstLetterLowerCase:className]];
    NSString *propertyNamePredicate = [NSString stringWithFormat:@"_%@",propertyName];
    NSInteger value = [[object valueForKey:propertyName] integerValue];
    NSString *modifiedUser = [object valueForKey:@"modifiedUser"];
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %ld and _modifiedUser = %@ and branchID = %ld",propertyNamePredicate,value,modifiedUser,[Utility branchID]];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    
    if([filterArray count]==0)
    {
        [dataList addObject:object];
    }
    
}

+ (BOOL)duplicateID:(NSObject *)object
{
    Class classDB = [object class];
    NSString *className = NSStringFromClass(classDB);
    Class class = NSClassFromString([NSString stringWithFormat:@"Shared%@",className]);
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"shared%@",className]);
    SEL selectorList = NSSelectorFromString([NSString stringWithFormat:@"%@List",[Utility makeFirstLetterLowerCase:className]]);
    NSMutableArray *dataList = [[class performSelector:selector] performSelector:selectorList];
    
    
    NSString *propertyName = [NSString stringWithFormat:@"%@ID",[Utility makeFirstLetterLowerCase:className]];
    NSString *propertyNamePredicate = [NSString stringWithFormat:@"_%@",propertyName];
    NSInteger value = [[object valueForKey:propertyName] integerValue];
    NSString *modifiedUser = [object valueForKey:@"modifiedUser"];
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %ld",propertyNamePredicate,value];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    
    return [filterArray count]>0;
}

+ (void)itemsDownloaded:(NSArray *)items
{
    for(int j=0; j<[items count]; j++)
    {
        NSArray *arrTable = items[j];
        if([arrTable count]>0)
        {
            NSObject *object = arrTable[0];
            Class classDB = [object class];
            NSString *className = NSStringFromClass(classDB);
            Class class = NSClassFromString([NSString stringWithFormat:@"Shared%@",className]);
            SEL selector = NSSelectorFromString([NSString stringWithFormat:@"shared%@",className]);
            SEL selectorList = NSSelectorFromString([NSString stringWithFormat:@"%@List",[Utility makeFirstLetterLowerCase:className]]);
            NSMutableArray *dataList = [[class performSelector:selector] performSelector:selectorList];
            [dataList removeAllObjects];
            for(NSMutableArray *item in items[j])
            {
                [dataList addObject:item];
            }
        }
    }
}

+ (NSDate *)addDay:(NSDate *)dateFrom numberOfDay:(NSInteger)days
{
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = days;
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *addedDate = [theCalendar dateByAddingComponents:dayComponent toDate:dateFrom options:0];
    return addedDate;
}

+ (void)setUserDefaultPreOrderEventID:(NSString *) strSelectedEventID
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [defaults stringForKey:@"username"];
    NSMutableDictionary *dicPreOrderEventIDByUser = [[defaults dictionaryForKey:@"PreOrderEventIDByUser"] mutableCopy];
    if(!dicPreOrderEventIDByUser)
    {
        dicPreOrderEventIDByUser = [[NSMutableDictionary alloc]init];
    }
    [dicPreOrderEventIDByUser setValue:strSelectedEventID forKey:username];
    [defaults setObject:dicPreOrderEventIDByUser forKey:@"PreOrderEventIDByUser"];
}

+ (NSString *)getUserDefaultPreOrderEventID
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [defaults stringForKey:@"username"];
    NSMutableDictionary *dicPreOrderEventIDByUser = [[defaults dictionaryForKey:@"PreOrderEventIDByUser"] mutableCopy];
    if(!dicPreOrderEventIDByUser)
    {
        dicPreOrderEventIDByUser = [[NSMutableDictionary alloc]init];
    }
    NSString *strEventID = [dicPreOrderEventIDByUser objectForKey:username];
    if(!strEventID)
    {
        strEventID = @"0";
        [dicPreOrderEventIDByUser setValue:strEventID forKey:username];
        [defaults setObject:dicPreOrderEventIDByUser forKey:@"PreOrderEventIDByUser"];
    }
    
    
    return strEventID;
    
}

+ (NSArray *)intersectArray1:(NSArray *)array1 array2:(NSArray *)array2
{
    NSMutableSet *set1 = [NSMutableSet setWithArray: array1];
    NSSet *set2 = [NSSet setWithArray: array2];
    [set1 intersectSet: set2];
    NSArray *resultArray = [set1 allObjects];
    return resultArray;
}

+(BOOL)isStringEmpty:(NSString *)text
{
    if([[Utility trimString:text] isEqualToString:@""])
    {
        return YES;
    }
    return NO;
}

+ (NSDate *)notIdentifiedDate
{
    return [Utility stringToDate:@"0000-00-00 00:00:00" fromFormat:@"yyyy-MM-dd HH:mm:ss"];
}

+ (BOOL)isDateColumn:(NSString *)columnName
{
    if([columnName length] < 4)
    {
        return NO;
    }
    NSRange needleRange = NSMakeRange([columnName length]-4,4);
    return [[columnName substringWithRange:needleRange] isEqualToString:@"Date"];
}

+ (NSString *)getDay:(NSInteger)dayOfWeekIndex
{
    NSArray *days = @[@"Sun",@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat"];
    return days[dayOfWeekIndex-1];
}

+(NSDate *)getPreviousMonthFirstDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];//local time +7]
    NSDateComponents *comps = [NSDateComponents new];
    comps.day = 1;
    comps.month = -1;
    NSDate *date = [calendar dateByAddingComponents:comps toDate:[Utility currentDateTime] options:0];
    
    return  date;
}

+(NSDate *)getPreviousMonthLastDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];//local time +7]
    NSDateComponents *comps = [NSDateComponents new];
    comps.day = 0;
    NSDate *date = [calendar dateByAddingComponents:comps toDate:[Utility currentDateTime] options:0];
    
    return date;
    
}

+(NSDate *)getPrevious14Days
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];//local time +7]
    NSDateComponents *comps = [NSDateComponents new];
    comps.day = -14;
    NSDate *date = [calendar dateByAddingComponents:comps toDate:[Utility currentDateTime] options:0];
    
    
    return date;
}

+(NSDate *)getPreviousOrNextDay:(NSInteger)days
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];//local time +7]
    NSDateComponents *comps = [NSDateComponents new];
    comps.day = days;
    NSDate *date = [calendar dateByAddingComponents:comps toDate:[Utility currentDateTime] options:0];
    
    
    return date;
}

+(NSDate *)getPreviousOrNextDay:(NSInteger)days fromDate:(NSDate *)fromDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];//local time +7]
    NSDateComponents *comps = [NSDateComponents new];
    comps.day = days;
    NSDate *date = [calendar dateByAddingComponents:comps toDate:fromDate options:0];
    
    
    return date;
}

+(NSDate *)getPrevious30Min:(NSDate *)inputDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];//local time +7]
    NSDateComponents *comps = [NSDateComponents new];
    comps.minute = -30;
    NSDate *date = [calendar dateByAddingComponents:comps toDate:inputDate options:0];
    
    
    return date;
}

+ (void) setExpectedSales:(float)expectedSales
{
    [[NSUserDefaults standardUserDefaults] setFloat:expectedSales forKey:@"expectedSales"];
}

+ (float) expectedSales
{
    return [[NSUserDefaults standardUserDefaults] floatForKey:@"expectedSales"];
}

+(NSDate *)setStartOfTheDay:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//year christ
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];//local time +7]
    NSDate *startOfTheDayDate = [calendar dateBySettingHour:0 minute:0 second:0 ofDate:date options:0];
    return startOfTheDayDate;
}

+(NSDate *)setEndOfTheDay:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//year christ
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];//local time +7]
    NSDate *endOfTheDayDate = [calendar dateBySettingHour:23 minute:59 second:59 ofDate:date options:0];
    return endOfTheDayDate;
}

+(NSDate *)getLatestMonday
{
    NSDate *today = [Utility currentDateTime];
    
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//year christ
    NSDateComponents *comps = [calendar components:NSCalendarUnitWeekday fromDate:today];
    NSInteger weekday = [comps weekday];
    NSInteger days = 0;
    switch (weekday) {
        case 1:
            days = -6;
            break;
        case 2:
            days = 0;
            break;
        case 3:
            days = -1;
            break;
        case 4:
            days = -2;
            break;
        case 5:
            days = -3;
            break;
        case 6:
            days = -4;
            break;
        case 7:
            days = -5;
            break;
        default:
            break;
    }
    
    
    return [self getPreviousOrNextDay:days];
}

+(NSDate *)getNextSunday
{
    return [self getPreviousOrNextDay:6 fromDate:[self getLatestMonday]];
}

+(int)hexStringToInt:(NSString *)hexString
{
    unsigned int outVal;
    NSScanner* scanner = [NSScanner scannerWithString:hexString];
    [scanner scanHexInt:&outVal];
    
    return outVal;
}


+(NSArray *)jsonToArray:(NSArray *)arrDataJson arrClassName:(NSArray *)arrClassName
{
    NSMutableArray *arrItem = [[NSMutableArray alloc] init];
    
    
    for(int i=0; i<[arrDataJson count]; i++)
    {
        //arrdatatemp <= arrdata
        NSMutableArray *arrDataTemp = [[NSMutableArray alloc]init];
        NSArray *arrData = arrDataJson[i];
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
            
            [arrDataTemp addObject:object];
        }
        [arrItem addObject:arrDataTemp];
    }
    
    return arrItem;
}

+(NSMutableArray *)sortDataByColumn:(NSMutableArray *)dataList numOfColumn:(NSInteger)numOfColumn
{
    NSMutableArray *sortDataList = [[NSMutableArray alloc]init];
    NSInteger numOfRowPerColumn = ceilf(1.0*[dataList count]/numOfColumn);
    for(int i=0; i<numOfRowPerColumn; i++)
    {
        for(int j=0; j<numOfColumn; j++)
        {
            if(i+j*numOfRowPerColumn >= [dataList count])
            {
                continue;
            }
            else
            {
                [sortDataList addObject:dataList[i+j*numOfRowPerColumn]];
            }
        }
    }
    return sortDataList;
    
}

+(NSString *)getFirstLetter:(NSString *)text
{
    NSRange needleRange;
    needleRange = NSMakeRange(0,1);
    NSString *firstLetter = [text substringWithRange:needleRange];
    return firstLetter;
}

+(NSString *)getTextOmitFirstLetter:(NSString *)text
{
    NSRange needleRange;
    needleRange = NSMakeRange(1,[text length]-1);
    NSString *resultText = [text substringWithRange:needleRange];
    
    
    return resultText;
}

+(NSString *)replaceNewLineForDB:(NSString *)text
{
    return [text stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];//replace ด้วยอะไรก้ได้ ที่ไม่ใช่ new line
}

+(NSString *)replaceNewLineForApp:(NSString *)text
{
    return [text stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
}

+(NSString *)insertDashForPhoneNo:(NSString *)text
{
    int i=0;
    NSString *strPhoneNo;
    NSArray* phoneNoList = [text componentsSeparatedByString: @","];
    for(NSString *item in phoneNoList)
    {
        if(i==0)
        {
            strPhoneNo = [Utility insertDash:item];
        }
        else
        {
            strPhoneNo = [NSString stringWithFormat:@"%@,%@",strPhoneNo,[Utility insertDash:item]];
        }
    }
    return strPhoneNo;
}

+ (NSString *)insertDash:(NSString *)text
{
    if([text length] == 10)
    {
        NSMutableString *mu = [NSMutableString stringWithString:text];
        [mu insertString:@"-" atIndex:3];
        [mu insertString:@"-" atIndex:7];
        return [NSString stringWithString:mu];
    }
    return text;
}

+(NSString*)addPrefixBahtSymbol:(NSString *)strAmount
{
    return [NSString stringWithFormat:@"฿ %@",strAmount];
}

+(void)addToSharedDataList:(NSArray *)items
{
    for(int j=0; j<[items count]; j++)
    {
        NSMutableArray *dataGetList = items[j];
        for(int k=0; k<[dataGetList count]; k++)
        {
            NSObject *object = dataGetList[k];
            NSString *className = NSStringFromClass([object class]);
            NSString *strNameID = [Utility getPrimaryKeyFromClassName:className];
            
            
            Class class = NSClassFromString([NSString stringWithFormat:@"Shared%@",className]);
            SEL selector = NSSelectorFromString([NSString stringWithFormat:@"shared%@",className]);
            SEL selectorList = NSSelectorFromString([NSString stringWithFormat:@"%@List",[Utility makeFirstLetterLowerCase:className]]);
            NSMutableArray *dataList = [[class performSelector:selector] performSelector:selectorList];
            
            
            if(![Utility duplicate:object])
            {
                [dataList addObject:object];
            }
        }
    }
}
@end


