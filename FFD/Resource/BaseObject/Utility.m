//
//  Utility.m
//  Eventoree
//
//  Created by Thidaporn Kijkamjai on 8/6/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "Utility.h"
#import "RNEncryptor.h"
#import "RNDecryptor.h"
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
    return [[NSUserDefaults standardUserDefaults] stringForKey:USERNAME];
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
        case urlUserAccountInsert:
        url = @"/FFD/FFDUserAccountInsert.php";
        break;
        case urlSendEmail:
        url = @"/FFD/sendEmail.php";
        break;
        case urlMasterGet:
        url = @"/FFD/FFDMasterGet.php?%@";
        break;
        case urlUploadPhoto:
        url = @"/FFD/uploadPhoto.php";
        break;
        case urlDownloadPhoto:
        url = @"/FFD/downloadImage.php";
        break;
        case urlDownloadFile:
        url = @"/FFD/downloadFile.php";
        break;
        case urlUserAccountDeviceTokenUpdate:
        url = @"/FFD/FFDUserAccountDeviceTokenUpdate.php";
        break;
        case urlLogInInsert:
        url = @"/FFD/FFDLogInInsert.php";
        break;
        case urlPushSyncSync:
        url = @"/FFD/FFDPushSyncSync.php";
        break;
        case urlPushSyncUpdateByDeviceToken:
        url = @"/FFD/FFDPushSyncUpdateByDeviceToken.php";
        break;
        case urlCredentialsValidate:
        url = @"/FFD/FFDCredentialsValidate.php";
        break;
        case urlDeviceInsert:
        url = @"/FFD/FFDDeviceInsert.php";
        break;
        case urlPushSyncUpdateTimeSynced:
        url = @"/FFD/FFDPushSyncUpdateTimeSynced.php";
        break;
        case urlRewardProgramGet:
        url = @"/FFD/SAIMRewardProgramGet.php?%@";
        break;
        case urlRewardProgramInsert:
        url = @"/FFD/SAIMRewardProgramInsert.php";
        break;
        case urlRewardProgramUpdate:
        url = @"/FFD/SAIMRewardProgramUpdate.php";
        break;
        case urlRewardProgramDelete:
        url = @"/FFD/SAIMRewardProgramDelete.php";
        break;
        case urlWriteLog:
        url = @"/FFD/FFDWriteLog.php";
        break;
        case urlTableTakingInsert:
        url = @"/FFD/FFDTableTakingInsert.php";
        break;
        case urlTableTakingUpdate:
        url = @"/FFD/FFDTableTakingUpdate.php";
        break;
        case urlTableTakingDelete:
        url = @"/FFD/FFDTableTakingDelete.php";
        break;
        case urlOrderTakingInsert:
        url = @"/FFD/FFDOrderTakingInsert.php";
        break;
        case urlOrderTakingUpdate:
        url = @"/FFD/FFDOrderTakingUpdate.php";
        break;
        case urlOrderTakingDelete:
        url = @"/FFD/FFDOrderTakingDelete.php";
        break;
        case urlOrderTakingUpdateList:
        url = @"/FFD/FFDOrderTakingUpdateList.php";
        break;
        case urlOrderTakingDeleteList:
        url = @"/FFD/FFDOrderTakingDeleteList.php";
        break;
        case urlOrderNoteInsert:
        url = @"/FFD/FFDOrderNoteInsert.php";
        break;
        case urlOrderNoteDelete:
        url = @"/FFD/FFDOrderNoteDelete.php";
        break;
        case urlOrderNoteDeleteList:
        url = @"/FFD/FFDOrderNoteDeleteList.php";
        break;
        case urlOrderKitchenInsertList:
        url = @"/FFD/FFDOrderKitchenInsertList.php";
        break;
        case urlMemberInsert:
        url = @"/FFD/FFDMemberInsert.php";
        break;
        default:
        break;
    }
    return [NSString stringWithFormat:@"%@%@", [self domainName],url];
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

+ (NSString *) formatDateForDB:(NSString *)strDate
{
    return [self formatDate:strDate fromFormat:[Utility setting:vFormatDateDisplay] toFormat:[Utility setting:vFormatDateDB]];
}

+ (NSString *) formatDateForDisplay:(NSString *)strDate
{
    return [self formatDate:strDate fromFormat:[Utility setting:vFormatDateDB] toFormat:[Utility setting:vFormatDateDisplay]];
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
    df.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//year christ
    df.dateStyle = NSDateFormatterMediumStyle;
    df.dateFormat = toFormat;
    
    
    NSString *strDate = [df stringFromDate:date];
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

+(NSData *)encrypt:(NSString *)data
{
    NSData *nsData = [data dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSData *encryptedData = [RNEncryptor encryptData:nsData
                                        withSettings:kRNCryptorAES256Settings
                                            password:[self cipher]
                                               error:&error];
    return encryptedData;
}

+(NSString *)decrypt:(NSData *)encryptedData
{
    NSError *error;
    NSData *decryptedData = [RNDecryptor decryptData:encryptedData
                                        withPassword:[self cipher]
                                               error:&error];
    NSString* strOriginal = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
    
    return strOriginal;
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
    for(id key in condition){
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

+ (NSString *) currentDateTimeStringForDB
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];// here set format which you want...
    NSString *convertedString = [dateFormatter stringFromDate:[NSDate date]];
    return convertedString;
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

+ (NSString *)getCurrentDateString:(NSString *)format
{
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    NSString *dateString = [dateFormat stringFromDate:today];
    return dateString;
}

+ (NSData *)dataFromHexString:(NSString *)string
{
    string = [string lowercaseString];
    NSMutableData *data= [NSMutableData new];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i = 0;
    int length = string.length;
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
    NSArray *arrMasterClass = @[@"UserAccount",@"LogIn",@"CustomerTable",@"MenuType",@"Menu",@"TableTaking",@"OrderTaking",@"MenuTypeNote",@"Note",@"OrderNote",@"OrderKitchen",@"Member"];
    
    
    return arrMasterClass[i];
}
+ (NSString *)getMasterClassName:(NSInteger)i from:(NSArray *)arrClassName
{
    return arrClassName[i];
}
+ (NSString *)getDecryptedHexString:(NSString *)hexString
{
    NSData *nsDataEncrypted = [self dataFromHexString:hexString];
    NSString *decryptedString = [self decrypt:nsDataEncrypted];
    return  decryptedString;
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
//    if([@"/FFD/" isEqualToString:strDBName])
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
//    if([@"/FFD/" isEqualToString:strDBName])
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
            
            [object setValue:jsonElement[dbColumnName] forKey:key];
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
                        
                        
                        [item setValue:[object valueForKey:key] forKey:key];
                    }
                    break;
                }
            }
        }
        else if([action isEqualToString:@"i"])
        {
            if(![Utility duplicate:object])
            {
                [dataList addObject:object];
            }
            
        }
        else if([action isEqualToString:@"d"])
        {
            for(NSObject *item in dataList)
            {
                //replaceSelf ถ้าเท่ากับ 1 ให้ เช็ค column modifiedUser != ตัวเอง ถึงจะมองว่า match (ที่ให้เช็คไม่เท่ากับตัวเอง เนื่องจากแก้ปัญหา duplicate key ตอน insert พร้อมกัน 2 เครื่อง เราดึงข้อมูลของตัวที่ insert ก่อนเข้ามา เพื่อมาลบตัว insert ทีหลังออก แล้ว insert ตัวหลังด้วย ID ใหม่แทน)
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
            for(NSObject *item in items[j])
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

+ (NSString *)setPhoneNoFormat:(NSString *)text
{
    if([text length] == 0)
    {
        return @"-";
    }
    else if([text length] == 10)
    {
        NSMutableString *mu = [NSMutableString stringWithString:text];
        [mu insertString:@"-" atIndex:3];
        [mu insertString:@"-" atIndex:7];
        return [NSString stringWithString:mu];
    }
    return text;
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
@end


