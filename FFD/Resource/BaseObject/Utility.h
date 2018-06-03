//
//  Utility.h
//  Eventoree
//
//  Created by Thidaporn Kijkamjai on 8/6/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeModel.h"
//#import "RNEncryptor.h"
//#import "RNDecryptor.h"
#import <objc/runtime.h>
#import "ChristmasConstants.h"



#define mRedThemeColor      [UIColor colorWithRed:255/255.0 green:51/255.0 blue:51/255.0 alpha:1]
#define mGrayColor          [UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1]
#define mLightGrayColor     [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1]
#define mDarkGrayColor      [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1]
#define mYellowColor        [UIColor colorWithRed:255/255.0 green:255/255.0 blue:253/255.0 alpha:1]
#define mBlueColor          [UIColor colorWithRed:51/255.0 green:153/255.0 blue:255/255.0 alpha:1]
#define mLightBlueColor     [UIColor colorWithRed:211/255.0 green:229/255.0 blue:249/255.0 alpha:1]
#define mBlueBackGroundColor     [UIColor colorWithRed:220/255.0 green:239/255.0 blue:244/255.0 alpha:1]
#define mLightGreen         [UIColor colorWithRed:193/255.0 green:245/255.0 blue:192/255.0 alpha:1]
#define mLightYellowColor   [UIColor colorWithRed:248/255.0 green:247/255.0 blue:123/255.0 alpha:1]
#define mLightPink          [UIColor colorWithRed:242/255.0 green:209/255.0 blue:248/255.0 alpha:1]
#define mRed                [UIColor colorWithRed:255/255.0 green:56/255.0 blue:36/255.0 alpha:1]
//#define mDarkBlue              [UIColor colorWithRed:0/255.0 green:113/255.0 blue:206/255.0 alpha:1]
#define mColVwBgColor       [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1]
#define mGreen              [UIColor colorWithRed:0/255.0 green:168/255.0 blue:136/255.0 alpha:1]
#define mSeparatorLine      [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1]
#define mPlaceHolder     [UIColor colorWithRed:199/255.0 green:199/255.0 blue:205/255.0 alpha:1]
#define mButtonColor     [UIColor colorWithRed:30/255.0 green:177/255.0 blue:237/255.0 alpha:1]
#define mSelectionStyleGray     [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1]
#define mPlaceHolder     [UIColor colorWithRed:199/255.0 green:199/255.0 blue:205/255.0 alpha:1]
#define mOrange     [UIColor colorWithRed:246/255.0 green:139/255.0 blue:31/255.0 alpha:1]
#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

enum reportView
{
    reportViewGraph = 0,
    reportViewTable = 1
};

enum frequency
{
    frequencyDaily = 0,
    frequencyWeekly = 1,
    frequencyMonthly = 2
};

enum reportType
{
    reportTypeSalesAll = 0,
    reportTypeSalesByMenuType = 1,
    reportTypeSalesByMenu = 2,
    reportTypeSalesByMember = 3
};

enum reportGroup
{
    reportGroupSales = 0,
    reportGroupInventory = 1,
    reportGroupExpense = 2,
    reportGroupTurnover = 3,
    reportGroupMember = 4
};

enum settingGroup
{
    settingGroupPrinter = 0,
    settingGroupCustomerTable = 1,
    settingGroupPromotion = 2,
    settingGroupReward = 3,
    settingGroupDiscount = 4,
    settingGroupUserTabMenu = 5
};

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
    dbMaster,
    dbMasterWithProgressBar,
    dbSettingDeviceToken,
    dbLogIn,
    dbPushSync,
    dbPushSyncPrintKitchenBill,
    dbPushSyncUpdateByDeviceToken,
    dbCredentials,
    dbCredentialsDb,
    dbDevice,
    dbPushSyncUpdateTimeSynced,
    dbWriteLog,
    dbTableTaking,
    dbTableTakingWithCustomerTable,
    dbTableTakingInsertUpdate,
    dbTableTakingList,
    dbUserAccountDeviceToken,
    dbOrderTaking,
    dbOrderTakingInsertUpdate,
    dbOrderTakingList,
    dbOrderNote,
    dbOrderNoteList,
    dbOrderKitchenList,
    dbOrderTakingOrderNoteOrderKitchenReceipt,
    dbOrderTakingOrderNoteOrderKitchenReceiptAndReceiptNo,
    dbOrderTakingOrderNoteOrderKitchenCustomerTable,
    dbOrderTakingOrderKitchenTableTakingReceiptList,
    dbOrderTakingOrderNoteOrderKitchenCancelOrder,
    dbOrderTakingOrderNoteOrderKitchenOrderCancelDiscount,
    dbMember,
    dbAddress,
    dbAddressList,
    dbReceipt,
    dbReceiptList,
    dbDiscount,
    dbDiscountList,
    dbSetting,
    dbSettingList,
    dbRewardPoint,
    dbRewardPointList,
    dbReceiptNo,
    dbReceiptNoList,
    dbReceiptNoTax,
    dbReceiptNoTaxList,
    dbReceiptNoTaxBill,
    dbReceiptNoAndReceipt,
    dbReceiptCustomerTable,
    dbReceiptCustomerTableList,
    dbRewardProgram,
    dbRewardProgramList,
    dbSpecialPriceProgram,
    dbSpecialPriceProgramList,
    dbMenu,
    dbMenuList,
    dbMenuType,
    dbMenuTypeList,
    dbMenuTypeAndSubMenuType,
    dbMenuIngredient,
    dbMenuIngredientList,
    dbMenuAndMenuIngredientList,
    dbIngredientType,
    dbIngredientTypeList,
    dbIngredient,
    dbIngredientList,
    dbIngredientTypeAndSubIngredientType,
    dbSubMenuType,
    dbSubMenuTypeList,
    dbSubMenuTypeAndMenu,
    dbSubIngredientType,
    dbSubIngredientTypeList,
    dbSubIngredientTypeAndIngredient,
    dbIngredientNeeded,
    dbIngredientCheck,
    dbIngredientCheckList,
    dbIngredientReceive,
    dbIngredientReceiveList,
    dbReportSalesAllDaily,
    dbReportSalesAllWeekly,
    dbReportSalesAllMonthly,
    dbReportSalesByMenuTypeDaily,
    dbReportSalesByMenuTypeWeekly,
    dbReportSalesByMenuTypeMonthly,
    dbReportSalesByMenu,
    dbReportSalesByMember,
    dbNoteType,
    dbNoteTypeList,
    dbReceiptAndReceiptNoTaxPrint,
    dbUserTabMenu,
    dbUserTabMenuList,
    dbReportOrderTransaction,
    dbReportEndDay,
    dbBoard,
    dbBoardList,
    dbMergeReceiptCloseTable,
    dbReceiptCloseTable,
    dbBillPrint,
    dbBillPrintList,
    dbPaySplitBillInsert,
    dbPaySplitBillInsertWithoutReceipt,
    dbPaySplitBillInsertAfterFirstTime,
    dbPaySplitBillInsertLastOne,
    dbTableTakingOrderTakingReceiptUpdateDelete,
    dbTableTakingReceiptOrderTakingListUpdate,
    dbMoveOrderInsert,
    dbMoveOrderUpdate,
    dbOrderCancelDiscount,
    dbOrderCancelDiscountList,
    dbOrderCancelDiscountOrderTakingList,
    dbPrinter,
    dbPrinterList,
    dbRoleTabMenu,
    dbRoleTabMenuList,
    dbTabMenu,
    dbTabMenuList,
    dbMoneyCheck,
    dbMoneyCheckList,
//    dbMoneyCheckAndSendMail,
    dbMoneyCheckListAndSendMail,
    dbBranch,
    dbBranchList,
    dbReceiptSummary,
    dbReceiptPrint,
    dbReceiptPrintList,
    dbJummumReceipt,
    dbJummumReceiptUpdate,
    dbDisputeReasonList,
    dbDispute
    
};

enum enumUrl
{
    urlUserAccountInsert,
    urlUserAccountUpdate,
    urlUserAccountDelete,
    urlSendEmail,
    urlCredentialsDbGet,
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
    urlWriteLog,
    urlTableTakingInsert,
    urlTableTakingInsertUpdate,
    urlTableTakingUpdate,
    urlTableTakingDelete,
    urlTableTakingWithCustomerTableDelete,
    urlTableTakingInsertList,
    urlTableTakingUpdateList,
    urlTableTakingDeleteList,
    urlOrderTakingInsert,
    urlOrderTakingUpdate,
    urlOrderTakingDelete,
    urlOrderTakingInsertUpdate,
    urlOrderTakingUpdateList,
    urlOrderTakingDeleteList,
    urlOrderNoteInsert,
    urlOrderNoteUpdate,
    urlOrderNoteDelete,
    urlOrderNoteInsertList,
    urlOrderNoteUpdateList,
    urlOrderNoteDeleteList,
    urlOrderKitchenInsertList,
    urlOrderTakingOrderNoteOrderKitchenGetList,
    urlOrderTakingOrderNoteOrderKitchenReceiptInsertList,
    urlOrderTakingOrderNoteOrderKitchenReceiptAndReceiptNoInsertList,
    urlOrderTakingOrderNoteOrderKitchenCustomerTableInsertList,
    urlOrderTakingOrderKitchenTableTakingReceiptUpdateList,
    urlOrderTakingOrderNoteOrderKitchenCancelOrderInsertUpdateList,
    urlOrderTakingOrderNoteOrderKitchenOrderCancelDiscountInsertUpdateList,
    urlMemberInsert,
    urlAddressInsert,
    urlAddressDelete,
    urlAddressUpdate,
    urlAddressUpdateList,
    urlReceiptInsert,
    urlReceiptUpdate,
    urlReceiptDelete,
    urlReceiptInsertList,
    urlReceiptUpdateList,
    urlReceiptDeleteList,
    urlReceiptGetList,
    urlDiscountInsert,
    urlDiscountUpdate,
    urlDiscountDelete,
    urlDiscountInsertList,
    urlDiscountUpdateList,
    urlDiscountDeleteList,
    urlDiscountGetList,
    urlSettingUpdate,
    urlSettingUpdateList,
    urlRewardPointInsert,
    urlRewardPointUpdate,
    urlRewardPointDelete,
    urlRewardPointInsertList,
    urlRewardPointUpdateList,
    urlRewardPointDeleteList,
    urlReceiptNoInsert,
    urlReceiptNoUpdate,
    urlReceiptNoDelete,
    urlReceiptNoInsertList,
    urlReceiptNoUpdateList,
    urlReceiptNoDeleteList,
    urlReceiptNoTaxInsert,
    urlReceiptNoTaxUpdate,
    urlReceiptNoTaxDelete,
    urlReceiptNoTaxInsertList,
    urlReceiptNoTaxUpdateList,
    urlReceiptNoTaxDeleteList,
    urlReceiptNoAndReceiptInsert,
    urlReceiptCustomerTableInsert,
    urlReceiptCustomerTableUpdate,
    urlReceiptCustomerTableDelete,
    urlReceiptCustomerTableInsertList,
    urlReceiptCustomerTableUpdateList,
    urlReceiptCustomerTableDeleteList,
    urlRewardProgramInsert,
    urlRewardProgramUpdate,
    urlRewardProgramDelete,
    urlRewardProgramInsertList,
    urlRewardProgramUpdateList,
    urlRewardProgramDeleteList,
    urlRewardProgramGetList,
    urlSpecialPriceProgramInsert,
    urlSpecialPriceProgramUpdate,
    urlSpecialPriceProgramDelete,
    urlSpecialPriceProgramInsertList,
    urlSpecialPriceProgramUpdateList,
    urlSpecialPriceProgramDeleteList,
    urlSpecialPriceProgramGetList,
    urlMenuInsert,
    urlMenuUpdate,
    urlMenuDelete,
    urlMenuInsertList,
    urlMenuUpdateList,
    urlMenuDeleteList,
    urlMenuTypeInsert,
    urlMenuTypeUpdate,
    urlMenuTypeDelete,
    urlMenuTypeInsertList,
    urlMenuTypeUpdateList,
    urlMenuTypeDeleteList,
    urlMenuTypeAndSubMenuTypeInsert,
    urlMenuIngredientInsert,
    urlMenuIngredientUpdate,
    urlMenuIngredientDelete,
    urlMenuIngredientInsertList,
    urlMenuIngredientUpdateList,
    urlMenuIngredientDeleteList,
    urlMenuAndMenuIngredientInsertList,
    urlIngredientTypeInsert,
    urlIngredientTypeUpdate,
    urlIngredientTypeDelete,
    urlIngredientTypeInsertList,
    urlIngredientTypeUpdateList,
    urlIngredientTypeDeleteList,
    urlIngredientInsert,
    urlIngredientUpdate,
    urlIngredientDelete,
    urlIngredientInsertList,
    urlIngredientUpdateList,
    urlIngredientDeleteList,
    urlSubMenuTypeInsert,
    urlSubMenuTypeUpdate,
    urlSubMenuTypeDelete,
    urlSubMenuTypeInsertList,
    urlSubMenuTypeUpdateList,
    urlSubMenuTypeDeleteList,
    urlSubMenuTypeAndMenuInsert,
    urlSubIngredientTypeInsert,
    urlSubIngredientTypeUpdate,
    urlSubIngredientTypeDelete,
    urlSubIngredientTypeInsertList,
    urlSubIngredientTypeUpdateList,
    urlSubIngredientTypeDeleteList,
    urlSubIngredientTypeAndIngredientInsert,
    urlIngredientTypeAndSubIngredientTypeInsert,
    urlIngredientCheckInsert,
    urlIngredientCheckUpdate,
    urlIngredientCheckDelete,
    urlIngredientCheckInsertList,
    urlIngredientCheckUpdateList,
    urlIngredientCheckDeleteList,
    urlIngredientCheckGetList,
    urlIngredientNeededGetList,
    urlIngredientReceiveInsert,
    urlIngredientReceiveUpdate,
    urlIngredientReceiveDelete,
    urlIngredientReceiveInsertList,
    urlIngredientReceiveUpdateList,
    urlIngredientReceiveDeleteList,
    urlIngredientReceiveGetList,
    urlReportSalesAllDailyGetList,
    urlReportSalesAllWeeklyGetList,
    urlReportSalesAllMonthlyGetList,
    urlReportSalesByMenuTypeDailyGetList,
    urlReportSalesByMenuTypeWeeklyGetList,
    urlReportSalesByMenuTypeMonthlyGetList,
    urlReportSalesByMenuGetList,
    urlReportSalesByMemberGetList,
    urlReportSalesTransactionGetList,
    urlReportSalesEndDayGetList,
    urlNoteTypeInsert,
    urlNoteTypeUpdate,
    urlNoteTypeDelete,
    urlNoteTypeInsertList,
    urlNoteTypeUpdateList,
    urlNoteTypeDeleteList,
    urlReceiptAndReceiptNoTaxPrintInsert,
    urlUserTabMenuInsert,
    urlUserTabMenuUpdate,
    urlUserTabMenuDelete,
    urlUserTabMenuInsertList,
    urlUserTabMenuUpdateList,
    urlUserTabMenuDeleteList,
    urlBoardInsert,
    urlBoardUpdate,
    urlBoardDelete,
    urlBoardInsertList,
    urlBoardUpdateList,
    urlBoardDeleteList,
    urlMergeReceiptCloseTableInsert,
    urlReceiptCloseTableUpdate,
    urlPaySplitBillInsert,
    urlPaySplitBillInsertWithoutReceipt,
    urlPaySplitBillInsertAfterFirstTime,
    urlPaySplitBillInsertLastOne,
    urlBillPrintInsert,
    urlBillPrintUpdate,
    urlBillPrintDelete,
    urlBillPrintInsertList,
    urlBillPrintUpdateList,
    urlBillPrintDeleteList,
    urlTableTakingOrderTakingReceiptUpdateDelete,
    urlTableTakingReceiptOrderTakingListUpdate,
    urlMoveOrderInsert,
    urlMoveOrderUpdate,
    urlOrderCancelDiscountInsert,
    urlOrderCancelDiscountUpdate,
    urlOrderCancelDiscountDelete,
    urlOrderCancelDiscountInsertList,
    urlOrderCancelDiscountUpdateList,
    urlOrderCancelDiscountDeleteList,
    urlOrderCancelDiscountOrderTakingInsertList,
    urlPrinterInsert,
    urlPrinterUpdate,
    urlPrinterDelete,
    urlPrinterInsertList,
    urlPrinterUpdateList,
    urlPrinterDeleteList,
    urlRoleTabMenuInsert,
    urlRoleTabMenuUpdate,
    urlRoleTabMenuDelete,
    urlRoleTabMenuInsertList,
    urlRoleTabMenuUpdateList,
    urlRoleTabMenuDeleteList,
    urlTabMenuInsert,
    urlTabMenuUpdate,
    urlTabMenuDelete,
    urlTabMenuInsertList,
    urlTabMenuUpdateList,
    urlTabMenuDeleteList,
    urlMoneyCheckInsert,
    urlMoneyCheckUpdate,
    urlMoneyCheckDelete,
    urlMoneyCheckInsertList,
    urlMoneyCheckUpdateList,
    urlMoneyCheckDeleteList,
    urlMoneyCheckInsertAndSendEmail,
    urlMoneyCheckInsertListAndSendEmail,
    urlBranchInsert,
    urlBranchUpdate,
    urlBranchDelete,
    urlBranchInsertList,
    urlBranchUpdateList,
    urlBranchDeleteList,
    urlBranchGet,
    urlReceiptSummaryGetList,
    urlReceiptPrintInsert,
    urlReceiptPrintUpdate,
    urlReceiptPrintDelete,
    urlReceiptPrintInsertList,
    urlReceiptPrintUpdateList,
    urlReceiptPrintDeleteList,
    urlJummumReceiptGetList,
    urlJummumReceiptUpdate,
    urlDisputeReasonGetList,
    urlDisputeInsert
    
};

@interface Utility : NSObject<HomeModelProtocol>
+ (NSString *) randomStringWithLength: (int) len;
+ (BOOL) validateEmailWithString:(NSString*)email;
+ (NSString *) msg:(enum enumMessage)eMessage;
+ (NSString *) setting:(enum enumSetting)eSetting;
+ (NSString *) url:(enum enumUrl)eUrl;
+ (NSString *) appendRandomParam:(NSString *)url;
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
+ (void)setBranchID:(NSInteger)branchID;
+ (NSInteger) branchID;
+ (NSString *) formatDate:(NSString *)strDate fromFormat:(NSString *)fromFormat toFormat:(NSString *)toFormat;
+ (NSDate *) stringToDate:(NSString *)strDate fromFormat:(NSString *)fromFormat;
+ (NSString *) dateToString:(NSDate *)date toFormat:(NSString *)toFormat;
+ (NSDate *) setDateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
//+ (NSData *) encrypt:(NSString *)data;
//+ (NSString *) decrypt:(NSData *)encryptedData;
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
+ (NSString *) getNoteDataString: (NSObject *)object withPrefix:(NSString *)prefix;
+ (NSString *) getNoteDataString: (NSObject *)object withPrefix:(NSString *)prefix runningNo:(long)runningNo;
+ (NSObject *) trimAndFixEscapeString: (NSObject *)object;
+ (NSString *)formatDecimal:(float)number;
+ (NSString *)formatDecimal:(float)number withMinFraction:(NSInteger)min andMaxFraction:(NSInteger)max;
+ (NSString *)trimString:(NSString *)text;
+ (NSString *)setPhoneNoFormat:(NSString *)text;
+ (NSString *)removeDashAndSpaceAndParenthesis:(NSString *)text;
+ (NSString *)removeComma:(NSString *)text;
+ (NSString *)removeApostrophe:(NSString *)text;
+ (NSString *)removeKeyword:(NSArray *)arrKeyword text:(NSString *)text;
+ (NSString *)modifiedUser;
+ (NSString *)modifiedVC;
+ (void)setModifiedUser:(NSString *)modifiedUser;
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
+ (NSInteger)getScanTimeInterVal;
+ (NSInteger)getScanTimeInterValCaseBlur;
+ (BOOL)duplicate:(NSObject *)object;
+ (void)addObjectIfNotDuplicate:(NSObject *)object;
+ (BOOL)duplicateID:(NSObject *)object;
+ (float)floatValue:(NSString *)text;
+ (NSInteger)getLastDayOfMonth:(NSDate *)datetime;
+ (void)itemsSynced:(NSString *)type action:(NSString *)action data:(NSArray *)data;
+ (void)itemsDownloaded:(NSArray *)items;
+ (NSDate *)addDay:(NSDate *)dateFrom numberOfDay:(NSInteger)days;
+ (NSString *)getUserDefaultPreOrderEventID;
+ (BOOL)alreadySynced:(NSInteger)pushSyncID;
+ (NSArray *)intersectArray1:(NSArray *)array1 array2:(NSArray *)array2;
+ (BOOL)isStringEmpty:(NSString *)text;
+ (NSDate *)notIdentifiedDate;
+ (BOOL)isDateColumn:(NSString *)columnName;
+ (NSString *)getDay:(NSInteger)dayOfWeekIndex;
+(NSDate *)getPreviousMonthFirstDate;
+(NSDate *)getPreviousMonthLastDate;
+(NSDate *)getPrevious14Days;
+(NSDate *)getPreviousOrNextDay:(NSInteger)days;
+(NSDate *)getPreviousOrNextDay:(NSInteger)days fromDate:(NSDate *)fromDate;
+(NSDate *)getPrevious30Min:(NSDate *)inputDate;
+ (void) setExpectedSales:(float)expectedSales;
+ (float) expectedSales;
+(NSDate *)setStartOfTheDay:(NSDate *)date;
+(NSDate *)setEndOfTheDay:(NSDate *)date;
+(NSDate *)getLatestMonday;
+(NSDate *)getNextSunday;
+(int)hexStringToInt:(NSString *)hexString;
+(NSArray *)jsonToArray:(NSArray *)arrDataJson arrClassName:(NSArray *)arrClassName;
+(NSMutableArray *)sortDataByColumn:(NSMutableArray *)dataList numOfColumn:(NSInteger)numOfColumn;
+(NSString *)getFirstLetter:(NSString *)text;
+(NSString *)getTextOmitFirstLetter:(NSString *)text;
+(NSString *)replaceNewLineForDB:(NSString *)text;
+(NSString *)replaceNewLineForApp:(NSString *)text;
+(NSString *)insertDashForPhoneNo:(NSString *)text;
+(NSString*)addPrefixBahtSymbol:(NSString *)strAmount;
+(void)addToSharedDataList:(NSArray *)items;
@end

