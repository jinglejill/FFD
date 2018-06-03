//
//  Utility.h
//  Eventoree
//
//  Created by Thidaporn Kijkamjai on 8/6/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeModel.h"
#import "RNEncryptor.h"
#import "RNDecryptor.h"
#import <objc/runtime.h>
#import "ChristmasConstants.h"



#define mRedThemeColor      [UIColor colorWithRed:255/255.0 green:51/255.0 blue:51/255.0 alpha:1]
#define mGrayColor          [UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1]
#define mLightGrayColor     [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1]
#define mDarkGrayColor      [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1]
#define mYellowColor        [UIColor colorWithRed:255/255.0 green:255/255.0 blue:253/255.0 alpha:1]
#define mBlueColor          [UIColor colorWithRed:51/255.0 green:153/255.0 blue:255/255.0 alpha:1]
#define mLightBlueColor     [UIColor colorWithRed:211/255.0 green:229/255.0 blue:249/255.0 alpha:1]


enum enumMessage
{
    skipMessage1,
    incorrectPasscode,
    skipMessage2,
    emailSubjectAdd,
    emailBodyAdd,
    emailSubjectReset,
    emailBodyReset,
    emailInvalid,
    emailExisted,
    wrongEmail,
    wrongPassword,
    newPasswordNotMatch,
    changePasswordSuccess,
    emailSubjectChangePassword,
    emailBodyChangePassword,
    newPasswordEmpty,
    passwordEmpty,
    passwordChanged,
    emailSubjectForgotPassword,
    emailBodyForgotPassword,
    forgotPasswordReset,
    forgotPasswordMailSent,
    locationEmpty,
    periodFromEmpty,
    periodToEmpty,
    deleteSubject,
    confirmDeleteUserAccount,
    confirmDeleteEvent,
    periodToLessThanPeriodFrom,
    noEventChosenSubject,
    noEventChosenDetail,
    codeMismatch,
    passwordIncorrect,
    emailIncorrect
    
};
enum enumSetting
{
    vZero,
    vOne,
    vFormatDateDB,
    vFormatDateDisplay,
    vFormatDateTimeDB,
    vBrand,
    vPasscode,
    vAllowUserCount,
    vAdminDeviceToken,
    vAdminEmail,
    vExpiredDate
};
enum enumDB
{
    dbUserAccount,
    dbMessage,
    dbSetting,
    dbMaster,
    dbMasterWithProgressBar,
    dbSettingDeviceToken,
    dbLogIn,
    dbPushSync,
    dbPushSyncUpdateByDeviceToken,
    dbCredentials,
    dbDevice,
    dbPushSyncUpdateTimeSynced,
    dbWriteLog,
    dbTableTaking,
    dbUserAccountDeviceToken,
    dbOrderTaking,
    dbOrderTakingList,
    dbOrderNote,
    dbOrderNoteList,
    dbOrderKitchenList,
    dbMember
};

enum enumUrl
{
    urlUserAccountInsert,
    urlUserAccountUpdate,
    urlUserAccountDelete,
    urlSendEmail,
    urlMasterGet,
    urlUploadPhoto,
    urlDownloadPhoto,
    urlDownloadFile,
    urlUserAccountDeviceTokenUpdate,
    urlLogInInsert,
    urlPushSyncSync,
    urlPushSyncUpdateByDeviceToken,
    urlCredentialsValidate,
    urlDeviceInsert,
    urlPushSyncUpdateTimeSynced,
    urlRewardProgramGet,
    urlRewardProgramInsert,
    urlRewardProgramUpdate,
    urlRewardProgramDelete,
    urlWriteLog,
    urlTableTakingInsert,
    urlTableTakingUpdate,
    urlTableTakingDelete,
    urlOrderTakingInsert,
    urlOrderTakingUpdate,
    urlOrderTakingDelete,
    urlOrderTakingUpdateList,
    urlOrderTakingDeleteList,
    urlOrderNoteInsert,
    urlOrderNoteDelete,
    urlOrderNoteDeleteList,
    urlOrderKitchenInsertList,
    urlMemberInsert
};

@interface Utility : NSObject<HomeModelProtocol>
+ (NSString *) randomStringWithLength: (int) len;
+ (BOOL) validateEmailWithString:(NSString*)email;
+ (NSString *) msg:(enum enumMessage)eMessage;
+ (NSString *) setting:(enum enumSetting)eSetting;
+ (NSString *) url:(enum enumUrl)eUrl;
+ (void) setPingAddress:(NSString *)pingAddress;
+ (NSString *) pingAddress;
+ (void) setDomainName:(NSString *)domainName;
+ (NSString *) domainName;
+ (void) setSubjectNoConnection:(NSString *)subjectNoConnection;
+ (NSString *) subjectNoConnection;
+ (void) setDetailNoConnection:(NSString *)detailNoConnection;
+ (NSString *) detailNoConnection;
+ (void)setCipher:(NSString *)cipher;
+ (NSString *) cipher;
+ (NSString *) deviceToken;
+ (NSInteger) deviceID;
+ (NSString *) dbName;
+ (NSString *) formatDate:(NSString *)strDate fromFormat:(NSString *)fromFormat toFormat:(NSString *)toFormat;
+ (NSString *) formatDateForDB:(NSString *)strDate;
+ (NSString *) formatDateForDisplay:(NSString *)strDate;
+ (NSDate *) stringToDate:(NSString *)strDate fromFormat:(NSString *)fromFormat;
+ (NSString *) dateToString:(NSDate *)date toFormat:(NSString *)toFormat;
+ (NSDate *) setDateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
+ (NSData *) encrypt:(NSString *)data;
+ (NSString *) decrypt:(NSData *)encryptedData;
+ (NSInteger) numberOfDaysFromDate:(NSDate *)dateFrom dateTo:(NSDate *)dateTo;
+ (NSDate *) dateFromDateTime:(NSDate *)dateTime;
+ (NSInteger) dayFromDateTime:(NSDate *)dateTime;
+ (NSDate *) GMTDate:(NSDate *)dateTime;
+ (NSDate *) currentDateTime;
+ (NSString *)percentEscapeString:(NSString *)string;
+ (NSString *)concatParameter:(NSDictionary *)condition;
+ (NSString *) getNoteDataString: (NSObject *)object;
+ (NSString *) getNoteDataString: (NSObject *)object withRunningNo:(long)runningNo;
+ (NSString *) getNoteDataString: (NSObject *)object withRunningNo3Digit:(long)runningNo;
+ (NSObject *) trimAndFixEscapeString: (NSObject *)object;
+ (NSString *) currentDateTimeStringForDB;
+ (NSString *)formatDecimal:(float)number;
+ (NSString *)formatDecimal:(float)number withMinFraction:(NSInteger)min andMaxFraction:(NSInteger)max;
+ (NSString *)trimString:(NSString *)text;
+ (NSString *)insertDash:(NSString *)text;
+ (NSString *)removeDashAndSpaceAndParenthesis:(NSString *)text;
+ (NSString *)removeComma:(NSString *)text;
+ (NSString *)removeApostrophe:(NSString *)text;
+ (NSString *)removeKeyword:(NSArray *)arrKeyword text:(NSString *)text;
+ (NSString *)modifiedUser;
+ (NSString *)modifiedVC;
+ (void)setModifiedUser:(NSString *)modifiedUser;
+ (NSString *)getCurrentDateString:(NSString *)format;
+ (BOOL) finishLoadSharedData;
+ (void) setFinishLoadSharedData:(BOOL)finish;
+ (NSData *)dataFromHexString:(NSString *)string;
+ (NSString *)makeFirstLetterLowerCase:(NSString *)text;
+ (NSString *)makeFirstLetterUpperCase:(NSString *)text;
+ (NSString *)makeFirstLetterUpperCaseOtherLower:(NSString *)text;
+ (NSString *)getPrimaryKeyFromClassName:(NSString *)className;
+ (NSString *)getMasterClassName:(NSInteger)i;
+ (NSString *)getMasterClassName:(NSInteger)i from:(NSArray *)arrClassName;
+ (NSString *)getDecryptedHexString:(NSString *)hexString;
+ (BOOL)isNumeric:(NSString *)text;
+ (NSString *)getSqlFailTitle;
+ (NSString *)getSqlFailMessage;
+ (NSString *)getConnectionLostTitle;
+ (NSString *)getConnectionLostMessage;
+ (NSInteger)getNumberOfRowForExecuteSql;
//+ (NSString *)getAppKey;
//+ (NSString *)getAppSecret;
+ (NSInteger)getScanTimeInterVal;
+ (NSInteger)getScanTimeInterValCaseBlur;
+ (BOOL)duplicate:(NSObject *)object;
//+ (BOOL)duplicate:(NSString *)className record:(NSObject *)object;
+ (float)floatValue:(NSString *)text;
+ (NSInteger)getLastDayOfMonth:(NSDate *)datetime;
+ (void)itemsSynced:(NSString *)type action:(NSString *)action data:(NSArray *)data;
+ (void)itemsDownloaded:(NSArray *)items;
+ (NSDate *)addDay:(NSDate *)dateFrom numberOfDay:(NSInteger)days;
+ (NSString *)setPhoneNoFormat:(NSString *)text;
+ (NSString *)getUserDefaultPreOrderEventID;
+ (BOOL)alreadySynced:(NSInteger)pushSyncID;
+ (NSArray *)intersectArray1:(NSArray *)array1 array2:(NSArray *)array2;
+ (BOOL)isStringEmpty:(NSString *)text;
@end
