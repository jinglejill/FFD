//
//  AppDelegate.m
//  Eventoree
//
//  Created by Thidaporn Kijkamjai on 8/4/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "AppDelegate.h"
#import "OrderTakingViewController.h"
#import "ReceiptViewController.h"
#import "CustomerTableViewController.h"
#import "CustomerKitchenViewController.h"
#import "OrderDetailViewController.h"
#import "LogInViewController.h"
#import "HomeModel.h"
#import "Utility.h"
#import <objc/runtime.h>
#import <DropboxSDK/DropboxSDK.h>
#import "PushSync.h"
#import "OrderTaking.h"
#import "Receipt.h"
#import "Dispute.h"



#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)



@interface AppDelegate ()
{
    HomeModel *_homeModel;
    HomeModel *_homeModelPushSyncUpdate;
    HomeModel *_homeModelPushSyncUpdateByDevice;
    HomeModel *_homeModelSyncItems;
    
    NSInteger _testReceiptID;
}
//printer part*******
@property (nonatomic, copy) NSString *portName;
@property (nonatomic, copy) NSString *portSettings;
@property (nonatomic, copy) NSString *modelName;
@property (nonatomic, copy) NSString *macAddress;

@property (nonatomic) StarIoExtEmulation emulation;
@property (nonatomic) BOOL               cashDrawerOpenActiveHigh;
@property (nonatomic) NSInteger          allReceiptsSettings;
@property (nonatomic) NSInteger          selectedIndex;
@property (nonatomic) LanguageIndex      selectedLanguage;
@property (nonatomic) PaperSizeIndex     selectedPaperSize;

- (void)loadParam;
//*******
@end

extern BOOL globalRotateFromSeg;



@implementation AppDelegate
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
- (void)photoUploaded
{
    
}

void myExceptionHandler(NSException *exception)
{
    
    NSString *stackTrace = [[[exception callStackSymbols] valueForKey:@"description"] componentsJoinedByString:@"\\n"];
    stackTrace = [NSString stringWithFormat:@"%@,%@\\n%@\\n%@",[Utility modifiedUser],[Utility deviceToken],exception.reason,stackTrace];
//    NSLog(@"Stack Trace callStackSymbols: %@", stackTrace);
    
    [[NSUserDefaults standardUserDefaults] setValue:stackTrace forKey:@"exception"];
    
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _testReceiptID = 349;
    //printer part*******
    [self loadParam];
    
    _selectedIndex     = 0;
    _selectedLanguage  = LanguageIndexEnglish;
    _selectedPaperSize = PaperSizeIndexThreeInch;
    //*******
    
    
    UIBarButtonItem *barButtonAppearance = [UIBarButtonItem appearance];
    [barButtonAppearance setBackgroundImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault]; // Change to your colour
    //        [barButtonAppearance setBackButtonBackgroundImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    
    
    [Utility setFinishLoadSharedData:NO];
    _homeModel = [[HomeModel alloc]init];
    _homeModel.delegate = self;
    _homeModelPushSyncUpdate = [[HomeModel alloc]init];
    _homeModelPushSyncUpdate.delegate = self;
    _homeModelSyncItems = [[HomeModel alloc]init];
    _homeModelSyncItems.delegate = self;
    
    
    globalRotateFromSeg = NO;
    
    // Override point for customization after application launch.
    NSString *strplistPath = [[NSBundle mainBundle] pathForResource:@"Property List" ofType:@"plist"];
    
    // read property list into memory as an NSData  object
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:strplistPath];
    NSError *strerrorDesc = nil;
    NSPropertyListFormat plistFormat;
    
    // convert static property list into dictionary object
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization propertyListWithData:plistXML options:NSPropertyListMutableContainersAndLeaves format:&plistFormat error:&strerrorDesc];
    if (!temp) {
        NSLog(@"Error reading plist: %@, format: %lu", strerrorDesc, (unsigned long)plistFormat);
    } else {
        // assign values
        
        [Utility setPingAddress:[temp objectForKey:@"PingAddress"]];
        [Utility setDomainName:[temp objectForKey:@"DomainName"]];
        [Utility setSubjectNoConnection:[temp objectForKey:@"SubjectNoConnection"]];
        [Utility setDetailNoConnection:[temp objectForKey:@"DetailNoConnection"]];
        [Utility setCipher:[temp objectForKey:@"Cipher"]];
        
    }
    
    
    //write exception of latest app crash to log file
    NSSetUncaughtExceptionHandler(&myExceptionHandler);
    NSString *stackTrace = [[NSUserDefaults standardUserDefaults] stringForKey:@"exception"];
    if(![stackTrace isEqualToString:@""])
    {
        [_homeModel insertItems:dbWriteLog withData:stackTrace actionScreen:@"Logging"];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"exception"];
    }
    
    
    //push notification
    {

        if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0"))
        {
            
            UNNotificationAction *notificationAction1 = [UNNotificationAction actionWithIdentifier:@"Print"
                                                                                             title:@"Print"
                                                                                           options:UNNotificationActionOptionForeground];
            UNNotificationAction *notificationAction2 = [UNNotificationAction actionWithIdentifier:@"View"
                                                                                             title:@"View"
                                                                                           options:UNNotificationActionOptionForeground];
            UNNotificationCategory *notificationCategory = [UNNotificationCategory categoryWithIdentifier:@"printKitchenBill"                                                                                                     actions:@[notificationAction1,notificationAction2] intentIdentifiers:@[] options:UNNotificationCategoryOptionNone];
            
            
            // Register the notification categories.
            UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
            center.delegate = self;
            [center setNotificationCategories:[NSSet setWithObjects:notificationCategory,nil]];
            
            
        }
        else
        {
            UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
            [application registerUserNotificationSettings:settings];
            [application registerForRemoteNotifications];
        }
    }
    
    
    //load shared at the begining of everyday
    NSDictionary *todayLoadShared = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"todayLoadShared"];
    NSString *strCurrentDate = [Utility dateToString:[Utility currentDateTime] toFormat:@"yyyy-MM-dd"];
    NSString *alreadyLoaded = [todayLoadShared objectForKey:strCurrentDate];
    if(!alreadyLoaded)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionaryWithObject:@"1" forKey:strCurrentDate] forKey:@"todayLoadShared"];
    }
    
    
    #if (TARGET_OS_SIMULATOR)
        NSString *token = @"simulator";
        [[NSUserDefaults standardUserDefaults] setValue:token forKey:TOKEN];
    #endif


    return YES;
}
//[UIApplicationDelegate application:didReceiveRemoteNotification:fetchCompletionHandler:]

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    
    //Called when a notification is delivered to a foreground app.
    
    NSLog(@"Userinfo %@",notification.request.content.userInfo);
    
    
    if(![Utility finishLoadSharedData])
    {
        return;
    }
    
    NSDictionary *userInfo = notification.request.content.userInfo;
    NSLog(@"Received notification: %@", userInfo);
    
    
    NSDictionary *myAps = [userInfo objectForKey:@"aps"];
    NSString *categoryIdentifier = [myAps objectForKey:@"category"];
    NSNumber *contentAvailable = [myAps objectForKey:@"content-available"];
    if([contentAvailable integerValue] == 1)
    {
        //check timesynced = null where devicetoken = [Utility deviceToken];
        PushSync *pushSync = [[PushSync alloc]init];
        pushSync.deviceToken = [Utility deviceToken];
        [_homeModelSyncItems syncItems:dbPushSync withData:pushSync];
        NSLog(@"syncitems");
    }
    
    if([categoryIdentifier isEqualToString:@"cancelOrder"])
    {
        //        if([response.actionIdentifier isEqualToString:@"Print"])
        {
            NSNumber *receiptID = [myAps objectForKey:@"receiptID"];
            _homeModel = [[HomeModel alloc]init];
            _homeModel.delegate = self;
            [_homeModel downloadItems:dbJummumReceiptUpdate withData:receiptID];
        }
    }
}


-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    
    //Called to let your app know which action was selected by the user for a given notification.
    
    NSLog(@"Userinfo %@",response.notification.request.content.userInfo);
    
    
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    NSDictionary *myAps = [userInfo objectForKey:@"aps"];
    NSString *categoryIdentifier = [myAps objectForKey:@"category"];
    if([categoryIdentifier isEqualToString:@"printKitchenBill"])
    {
        if([response.actionIdentifier isEqualToString:@"Print"])
        {
            NSNumber *receiptID = [myAps objectForKey:@"receiptID"];
            [_homeModel downloadItems:dbJummumReceipt withData:receiptID];
        }
    }
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"])
    {
        NSLog(@"decline action");
    }
    else if ([identifier isEqualToString:@"answerAction"])
    {
        NSLog(@"answer action");
    }
}
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"token---%@", token);
    //    globalDeviceToken = token;
    
    
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:TOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    

}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    //    NSLog([error localizedDescription]);
}
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    NSLog(@"didRegisterUserNotificationSettings");
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    if(application.applicationState == UIApplicationStateInactive) {
        
        NSLog(@"Inactive");
        
        //Show the view with the content of the push
        
        completionHandler(UIBackgroundFetchResultNewData);
        
    } else if (application.applicationState == UIApplicationStateBackground) {
        
        NSLog(@"Background");
        
        //Refresh the local model
        
        completionHandler(UIBackgroundFetchResultNewData);
        
        
        if(![Utility finishLoadSharedData])
        {
            return;
        }
        
        
        NSLog(@"Received notification: %@", userInfo);
        NSDictionary *myAps = [userInfo objectForKey:@"aps"];
        NSNumber *contentAvailable = [myAps objectForKey:@"content-available"];
        if([contentAvailable integerValue] == 1)
        {
            //check timesynced = null where devicetoken = [Utility deviceToken];
            PushSync *pushSync = [[PushSync alloc]init];
            pushSync.deviceToken = [Utility deviceToken];
            [_homeModelSyncItems syncItems:dbPushSync withData:pushSync];
            NSLog(@"syncitems");
        }
        
    } else {
        
        NSLog(@"Active");
        
        //Show an in-app banner
        
        completionHandler(UIBackgroundFetchResultNewData);
        
    }
}

//- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
//{
//    if(![Utility finishLoadSharedData])
//    {
//        return;
//    }
//    
//    
//    NSLog(@"Received notification: %@", userInfo);
//    NSDictionary *myAps = [userInfo objectForKey:@"aps"];
//    NSNumber *contentAvailable = [myAps objectForKey:@"content-available"];
//    if([contentAvailable integerValue] == 1)
//    {
//        //check timesynced = null where devicetoken = [Utility deviceToken];
//        PushSync *pushSync = [[PushSync alloc]init];
//        pushSync.deviceToken = [Utility deviceToken];
//        [_homeModelSyncItems syncItems:dbPushSync withData:pushSync];
//        NSLog(@"syncitems");
//    }
//
//}

- (void)itemsSynced:(NSArray *)items
{
    NSLog(@"items count: %ld",[items count]);
    if([items count] == 0)
    {
        UINavigationController * navigationController = self.navController;
        UIViewController *viewController = navigationController.visibleViewController;
        SEL s = NSSelectorFromString(@"removeOverlayViews");
        if([viewController respondsToSelector:s])
        {
            [viewController performSelector:s];
        }
        
        return;
    }
    
    
    NSMutableArray *pushSyncList = [[NSMutableArray alloc]init];
    
    
    //type == exit
    for(int j=0; j<[items count]; j++)
    {
        NSDictionary *payload = items[j];
        NSString *type = [payload objectForKey:@"downltype"];
        NSString *strPushSyncID = [payload objectForKey:@"pushSyncID"];
        
        
        if([type isEqualToString:@"exitApp"])
        {
            //เช็คว่าเคย sync pushsyncid นี้ไปแล้วยัง
            if([PushSync alreadySynced:[strPushSyncID integerValue]])
            {
                continue;
            }
            else
            {
                //update shared ใช้ในกรณี เรียก homemodel > 1 อันต่อหนึ่ง click คำสั่ง ซึ่งทำให้เกิดการ เรียก function syncitems ตัวที่ 2 ก่อนเกิดการ update timesynced จึงทำให้เกิดการเบิ้ล sync
                PushSync *pushSync = [[PushSync alloc]initWithPushSyncID:[strPushSyncID integerValue]];
                [PushSync addObject:pushSync];
                [pushSyncList addObject:pushSync];
            }
            


            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"มีการปรับปรุงแอพ"
                                                                           message:@"กรุณาเปิดแอพใหม่อีกครั้งเพื่อใช้งาน"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action)
                                            {
                                                exit(0);
                                            }];
            
            [alert addAction:defaultAction];
            [self.vc presentViewController:alert animated:YES completion:nil];
        }
    }
    
    
    
    
    
    
    //type == alert
    for(int j=0; j<[items count]; j++)
    {
        NSDictionary *payload = items[j];
        NSString *type = [payload objectForKey:@"type"];
        NSString *strPushSyncID = [payload objectForKey:@"pushSyncID"];
        NSArray *data = [payload objectForKey:@"data"];
        
        
        if([type isEqualToString:@"alert"])
        {
            //เช็คว่าเคย sync pushsyncid นี้ไปแล้วยัง
            if([PushSync alreadySynced:[strPushSyncID integerValue]])
            {
                continue;
            }
            else
            {
                //update shared ใช้ในกรณี เรียก homemodel > 1 อันต่อหนึ่ง click คำสั่ง ซึ่งทำให้เกิดการ เรียก function syncitems ตัวที่ 2 ก่อนเกิดการ update timesynced จึงทำให้เกิดการเบิ้ล sync
                PushSync *pushSync = [[PushSync alloc]initWithPushSyncID:[strPushSyncID integerValue]];
                [PushSync addObject:pushSync];
                [pushSyncList addObject:pushSync];
            }
            
        
            
            NSString *alertMsg = [NSString stringWithFormat:@"%@ is fail",[(NSDictionary *)data objectForKey:@"alert"]];
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:[Utility getSqlFailTitle]
                                                                           message:alertMsg
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action)
                                            {
                                                SEL s = NSSelectorFromString(@"loadingOverlayView");
                                                [self.vc performSelector:s];
                                                [_homeModel downloadItems:dbMaster];
                                            }];
            
            [alert addAction:defaultAction];
            [self.vc presentViewController:alert animated:YES completion:nil];
        }
    }
    
    
    
    //type == usernameconflict
    for(int j=0; j<[items count]; j++)
    {
        NSDictionary *payload = items[j];
        NSString *type = [payload objectForKey:@"type"];
        NSString *strPushSyncID = [payload objectForKey:@"pushSyncID"];
        NSArray *data = [payload objectForKey:@"data"];
        
        
        if([type isEqualToString:@"usernameconflict"])
        {
            //เช็คว่าเคย sync pushsyncid นี้ไปแล้วยัง
            if([PushSync alreadySynced:[strPushSyncID integerValue]])
            {
                continue;
            }
            else
            {
                //update shared ใช้ในกรณี เรียก homemodel > 1 อันต่อหนึ่ง click คำสั่ง ซึ่งทำให้เกิดการ เรียก function syncitems ตัวที่ 2 ก่อนเกิดการ update timesynced จึงทำให้เกิดการเบิ้ล sync
                PushSync *pushSync = [[PushSync alloc]initWithPushSyncID:[strPushSyncID integerValue]];
                [PushSync addObject:pushSync];
                [pushSyncList addObject:pushSync];
            }
            
            
            //you have login in another device และ unwind to หน้า sign in
            if(![self.vc isMemberOfClass:[LogInViewController class]])
            {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                               message:@"Username นี้กำลังถูกใช้เข้าระบบที่เครื่องอื่น"
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action)
                {
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    LogInViewController *logInViewController = [storyboard instantiateViewControllerWithIdentifier:@"LogInViewController"];
                                        [UIApplication sharedApplication].keyWindow.rootViewController = logInViewController;
                }];
                
                [alert addAction:defaultAction];
                [self.vc presentViewController:alert animated:YES completion:nil];
            }
        }
    }





    
    
    for(int j=0; j<[items count]; j++)
    {
        NSDictionary *payload = items[j];
        NSString *type = [payload objectForKey:@"type"];
        NSString *action = [payload objectForKey:@"action"];
        NSString *strPushSyncID = [payload objectForKey:@"pushSyncID"];
        NSArray *data = [payload objectForKey:@"data"];
        
        
        //เช็คว่าเคย sync pushsyncid นี้ไปแล้วยัง
        if([PushSync alreadySynced:[strPushSyncID integerValue]])
        {
            continue;
        }
        else
        {
            //update shared ใช้ในกรณี เรียก homemodel > 1 อันต่อหนึ่ง click คำสั่ง ซึ่งทำให้เกิดการ เรียก function syncitems ตัวที่ 2 ก่อนเกิดการ update timesynced จึงทำให้เกิดการเบิ้ล sync
            PushSync *pushSync = [[PushSync alloc]initWithPushSyncID:[strPushSyncID integerValue]];
            [PushSync addObject:pushSync];
            [pushSyncList addObject:pushSync];
        }
        
        

        if([data isKindOfClass:[NSArray class]])
        {
            [Utility itemsSynced:type action:action data:data];
        }
    }
    
    
    //update pushsync ที่ sync แล้ว
    if([pushSyncList count]>0)
    {
        NSLog(@"push sync list count: %ld",[pushSyncList count]);
        [_homeModelPushSyncUpdate updateItems:dbPushSyncUpdateTimeSynced withData:pushSyncList actionScreen:@"Update synced time"];
    }
    
    
    //ให้ refresh ข้อมูลที่ Show ที่หน้านั้นหลังจาก sync ข้อมูลมาใหม่ ตอนนี้ทำเฉพาะหน้า OrderTakingViewController ก่อน
    NSMutableArray *arrAllType = [[NSMutableArray alloc]init];
    for(int j=0; j<[items count]; j++)
    {
        NSDictionary *payload = items[j];
        NSString *type = [payload objectForKey:@"type"];
        [arrAllType addObject:type];
    }
    if([items count] > 0)
    {
        BOOL loadViewProcess = NO;
        NSArray *arrReferenceTable;
        if([self.vc isMemberOfClass:[OrderTakingViewController class]])
        {
            arrReferenceTable = @[@"MenuType",@"Menu",@"TableTaking",@"CustomerTable",@"OrderTaking",@"MenuTypeNote",@"OrderNote"];
            
            
            //ถ้า ordertaking เป็น โต๊ะตัวเองถึงจะ loadviewprocess
            OrderTakingViewController *orderTakingVc = (OrderTakingViewController *)self.vc;
            for(int j=0; j<[items count]; j++)
            {
                NSDictionary *payload = items[j];
                NSString *type = [payload objectForKey:@"type"];
                NSString *action = [payload objectForKey:@"action"];
                //NSString *strPushSyncID = [payload objectForKey:@"pushSyncID"];
                NSArray *data = [payload objectForKey:@"data"];
                
                
                if([type isEqualToString:@"OrderTaking"])
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
                        
                        
                        if([action isEqualToString:@"i"])
                        {
                            OrderTaking *orderTaking = (OrderTaking *)object;
                            if(orderTaking.customerTableID == orderTakingVc.customerTable.customerTableID)
                            {
                                loadViewProcess = YES;
                                break;
                            }
                        }
                    }
                }
            }
        }
        else if([self.vc isMemberOfClass:[ReceiptViewController class]])
        {
            arrReferenceTable = @[@"OrderTaking",@"Menu",@"OrderNote",@"Member",@"Address",@"Receipt",@"Discount",@"Setting",@"UserAccount",@"RewardProgram",@"RewardPoint",@"ReceiptNo",@"ReceiptNoTax",@"ReceiptCustomerTable",@"TableTaking",@"BillPrint"];
            
            
            
            //ถ้า receipt เป็น โต๊ะตัวเองถึงจะ loadviewprocess
            ReceiptViewController *receiptVc = (ReceiptViewController *)self.vc;
            for(int j=0; j<[items count]; j++)
            {
                NSDictionary *payload = items[j];
                NSString *type = [payload objectForKey:@"type"];
                NSString *action = [payload objectForKey:@"action"];
                //NSString *strPushSyncID = [payload objectForKey:@"pushSyncID"];
                NSArray *data = [payload objectForKey:@"data"];
                
                
                if([type isEqualToString:@"Receipt"])
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
                        
                        
                        if([action isEqualToString:@"i"] || [action isEqualToString:@"u"])
                        {
                            Receipt *receipt = (Receipt *)object;
                            if(receipt.customerTableID == receiptVc.customerTable.customerTableID)
                            {
                                loadViewProcess = YES;                                
                                break;
                            }
                        }
                    }
                }
                else if([type isEqualToString:@"OrderTaking"])
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
                        
                        
                        if([action isEqualToString:@"i"])
                        {
                            OrderTaking *orderTaking = (OrderTaking *)object;
                            if(orderTaking.customerTableID == receiptVc.customerTable.customerTableID)
                            {
                                loadViewProcess = YES;
                                NSLog(@"test loadviewprocess yes ordertaking");
                                break;
                            }
                        }
                    }
                }
            }
        }
        else if([self.vc isMemberOfClass:[CustomerTableViewController class]])
        {
            arrReferenceTable = @[@"UserAccount",@"TableTaking",@"OrderTaking",@"UserTabMenu",@"Board",@"Receipt"];
            loadViewProcess = YES;
        }
        else if([self.vc isMemberOfClass:[CustomerKitchenViewController class]])
        {
            arrReferenceTable = @[@"OrderTaking",@"Receipt",@"OrderNote",@"PrintReceipt"];
            loadViewProcess = YES;
        }
        NSArray *resultArray = [Utility intersectArray1:arrAllType array2:arrReferenceTable];
        if([resultArray count] > 0)
        {
            if(loadViewProcess)
            {
                {
                    SEL s = NSSelectorFromString(@"loadingOverlayView");
                    if([self.vc respondsToSelector:s])
                    {
                        [self.vc performSelector:s];
                    }
                }
            
                {
                    SEL s = NSSelectorFromString(@"loadViewProcess");
                    if([self.vc respondsToSelector:s])
                    {
                        [self.vc performSelector:s];
                    }
                }
            
                {
                    SEL s = NSSelectorFromString(@"removeOverlayViews");
                    if([self.vc respondsToSelector:s])
                    {
                        [self.vc performSelector:s];
                    }
                }
            }
        }
    }
}

//- (void)itemsSyncedPrintKitchenBill:(NSArray *)items receiptID:(NSInteger)receiptID
//{
//    NSLog(@"items count: %ld",[items count]);
//    if([items count] == 0)
//    {
//        UINavigationController * navigationController = self.navController;
//        UIViewController *viewController = navigationController.visibleViewController;
//        SEL s = NSSelectorFromString(@"removeOverlayViews");
//        if([viewController respondsToSelector:s])
//        {
//            [viewController performSelector:s];
//        }
//
//        return;
//    }
//
//
//    NSMutableArray *pushSyncList = [[NSMutableArray alloc]init];
//
//
//    //type == exit
//    for(int j=0; j<[items count]; j++)
//    {
//        NSDictionary *payload = items[j];
//        NSString *type = [payload objectForKey:@"type"];
//        NSString *strPushSyncID = [payload objectForKey:@"pushSyncID"];
//
//
//        if([type isEqualToString:@"exitApp"])
//        {
//            //เช็คว่าเคย sync pushsyncid นี้ไปแล้วยัง
//            if([PushSync alreadySynced:[strPushSyncID integerValue]])
//            {
//                continue;
//            }
//            else
//            {
//                //update shared ใช้ในกรณี เรียก homemodel > 1 อันต่อหนึ่ง click คำสั่ง ซึ่งทำให้เกิดการ เรียก function syncitems ตัวที่ 2 ก่อนเกิดการ update timesynced จึงทำให้เกิดการเบิ้ล sync
//                PushSync *pushSync = [[PushSync alloc]initWithPushSyncID:[strPushSyncID integerValue]];
//                [PushSync addObject:pushSync];
//                [pushSyncList addObject:pushSync];
//            }
//
//
//
//            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"มีการปรับปรุงแอพ"
//                                                                           message:@"กรุณาเปิดแอพใหม่อีกครั้งเพื่อใช้งาน"
//                                                                    preferredStyle:UIAlertControllerStyleAlert];
//
//            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                                  handler:^(UIAlertAction * action)
//                                            {
//                                                exit(0);
//                                            }];
//
//            [alert addAction:defaultAction];
//            [self.vc presentViewController:alert animated:YES completion:nil];
//        }
//    }
//
//
//
//
//
//
//    //type == alert
//    for(int j=0; j<[items count]; j++)
//    {
//        NSDictionary *payload = items[j];
//        NSString *type = [payload objectForKey:@"type"];
//        NSString *strPushSyncID = [payload objectForKey:@"pushSyncID"];
//        NSArray *data = [payload objectForKey:@"data"];
//
//
//        if([type isEqualToString:@"alert"])
//        {
//            //เช็คว่าเคย sync pushsyncid นี้ไปแล้วยัง
//            if([PushSync alreadySynced:[strPushSyncID integerValue]])
//            {
//                continue;
//            }
//            else
//            {
//                //update shared ใช้ในกรณี เรียก homemodel > 1 อันต่อหนึ่ง click คำสั่ง ซึ่งทำให้เกิดการ เรียก function syncitems ตัวที่ 2 ก่อนเกิดการ update timesynced จึงทำให้เกิดการเบิ้ล sync
//                PushSync *pushSync = [[PushSync alloc]initWithPushSyncID:[strPushSyncID integerValue]];
//                [PushSync addObject:pushSync];
//                [pushSyncList addObject:pushSync];
//            }
//
//
//
//            NSString *alertMsg = [NSString stringWithFormat:@"%@ is fail",[(NSDictionary *)data objectForKey:@"alert"]];
//            UIAlertController* alert = [UIAlertController alertControllerWithTitle:[Utility getSqlFailTitle]
//                                                                           message:alertMsg
//                                                                    preferredStyle:UIAlertControllerStyleAlert];
//
//            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                                  handler:^(UIAlertAction * action)
//                                            {
//                                                SEL s = NSSelectorFromString(@"loadingOverlayView");
//                                                [self.vc performSelector:s];
//                                                [_homeModel downloadItems:dbMaster];
//                                            }];
//
//            [alert addAction:defaultAction];
//            [self.vc presentViewController:alert animated:YES completion:nil];
//        }
//    }
//
//
//
//    //type == usernameconflict
//    for(int j=0; j<[items count]; j++)
//    {
//        NSDictionary *payload = items[j];
//        NSString *type = [payload objectForKey:@"type"];
//        NSString *strPushSyncID = [payload objectForKey:@"pushSyncID"];
//        NSArray *data = [payload objectForKey:@"data"];
//
//
//        if([type isEqualToString:@"usernameconflict"])
//        {
//            //เช็คว่าเคย sync pushsyncid นี้ไปแล้วยัง
//            if([PushSync alreadySynced:[strPushSyncID integerValue]])
//            {
//                continue;
//            }
//            else
//            {
//                //update shared ใช้ในกรณี เรียก homemodel > 1 อันต่อหนึ่ง click คำสั่ง ซึ่งทำให้เกิดการ เรียก function syncitems ตัวที่ 2 ก่อนเกิดการ update timesynced จึงทำให้เกิดการเบิ้ล sync
//                PushSync *pushSync = [[PushSync alloc]initWithPushSyncID:[strPushSyncID integerValue]];
//                [PushSync addObject:pushSync];
//                [pushSyncList addObject:pushSync];
//            }
//
//
//            //you have login in another device และ unwind to หน้า sign in
//            if(![self.vc isMemberOfClass:[LogInViewController class]])
//            {
//                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
//                                                                               message:@"Username นี้กำลังถูกใช้เข้าระบบที่เครื่องอื่น"
//                                                                        preferredStyle:UIAlertControllerStyleAlert];
//
//                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                                      handler:^(UIAlertAction * action)
//                                                {
//                                                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                                                    LogInViewController *logInViewController = [storyboard instantiateViewControllerWithIdentifier:@"LogInViewController"];
//                                                    [UIApplication sharedApplication].keyWindow.rootViewController = logInViewController;
//                                                }];
//
//                [alert addAction:defaultAction];
//                [self.vc presentViewController:alert animated:YES completion:nil];
//            }
//        }
//    }
//
//
//
//
//
//
//
//    for(int j=0; j<[items count]; j++)
//    {
//        NSDictionary *payload = items[j];
//        NSString *type = [payload objectForKey:@"type"];
//        NSString *action = [payload objectForKey:@"action"];
//        NSString *strPushSyncID = [payload objectForKey:@"pushSyncID"];
//        NSArray *data = [payload objectForKey:@"data"];
//
//
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
//
//        if([data isKindOfClass:[NSArray class]])
//        {
//            [Utility itemsSynced:type action:action data:data];
//        }
//    }
//
//
//
//
//
//    //************Print kitchen bill
//    NSMutableArray *receiptList = [[NSMutableArray alloc]init];
//    Receipt *receipt = [Receipt getReceipt:receiptID branchID:[Utility branchID]];
//    [receiptList addObject:receipt];
//    CustomViewController *vc = (CustomViewController *)self.vc;
//    [vc printReceipt:receiptList];
//    //************
//
//
//
//
//
//
//    //update pushsync ที่ sync แล้ว
//    if([pushSyncList count]>0)
//    {
//        NSLog(@"push sync list count: %ld",[pushSyncList count]);
//        [_homeModel updateItems:dbPushSyncUpdateTimeSynced withData:pushSyncList actionScreen:@"Update synced time"];
//    }
//
//
//    //ให้ refresh ข้อมูลที่ Show ที่หน้านั้นหลังจาก sync ข้อมูลมาใหม่ ตอนนี้ทำเฉพาะหน้า OrderTakingViewController ก่อน
//    NSMutableArray *arrAllType = [[NSMutableArray alloc]init];
//    for(int j=0; j<[items count]; j++)
//    {
//        NSDictionary *payload = items[j];
//        NSString *type = [payload objectForKey:@"type"];
//        [arrAllType addObject:type];
//    }
//    if([items count] > 0)
//    {
//        BOOL loadViewProcess = NO;
//        NSArray *arrReferenceTable;
//        if([self.vc isMemberOfClass:[OrderTakingViewController class]])
//        {
//            arrReferenceTable = @[@"MenuType",@"Menu",@"TableTaking",@"CustomerTable",@"OrderTaking",@"MenuTypeNote",@"OrderNote"];
//
//
//            //ถ้า ordertaking เป็น โต๊ะตัวเองถึงจะ loadviewprocess
//            OrderTakingViewController *orderTakingVc = (OrderTakingViewController *)self.vc;
//            for(int j=0; j<[items count]; j++)
//            {
//                NSDictionary *payload = items[j];
//                NSString *type = [payload objectForKey:@"type"];
//                NSString *action = [payload objectForKey:@"action"];
//                //NSString *strPushSyncID = [payload objectForKey:@"pushSyncID"];
//                NSArray *data = [payload objectForKey:@"data"];
//
//
//                if([type isEqualToString:@"OrderTaking"])
//                {
//                    NSString *className = type;
//                    NSString *strNameID = [Utility getPrimaryKeyFromClassName:type];
//
//
//                    Class class = NSClassFromString([NSString stringWithFormat:@"Shared%@",className]);
//                    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"shared%@",className]);
//                    SEL selectorList = NSSelectorFromString([NSString stringWithFormat:@"%@List",[Utility makeFirstLetterLowerCase:className]]);
//                    NSMutableArray *dataList = [[class performSelector:selector] performSelector:selectorList];
//
//
//                    //insert,update,delete data
//                    for(int i=0; i<[data count]; i++)
//                    {
//                        NSDictionary *jsonElement = data[i];
//                        NSObject *object = [[NSClassFromString(className) alloc] init];
//
//                        unsigned int propertyCount = 0;
//                        objc_property_t * properties = class_copyPropertyList([object class], &propertyCount);
//
//                        for (unsigned int i = 0; i < propertyCount; ++i)
//                        {
//                            objc_property_t property = properties[i];
//                            const char * name = property_getName(property);
//                            NSString *key = [NSString stringWithUTF8String:name];
//
//
//                            NSString *dbColumnName = [Utility makeFirstLetterUpperCase:key];
//                            if(!jsonElement[dbColumnName])
//                            {
//                                continue;
//                            }
//
//
//                            if([Utility isDateColumn:dbColumnName])
//                            {
//                                NSDate *date = [Utility stringToDate:jsonElement[dbColumnName] fromFormat:@"yyyy-MM-dd HH:mm:ss"];
//                                [object setValue:date forKey:key];
//                            }
//                            else
//                            {
//                                [object setValue:jsonElement[dbColumnName] forKey:key];
//                            }
//                        }
//
//
//                        if([action isEqualToString:@"i"])
//                        {
//                            OrderTaking *orderTaking = (OrderTaking *)object;
//                            if(orderTaking.customerTableID == orderTakingVc.customerTable.customerTableID)
//                            {
//                                loadViewProcess = YES;
//                                break;
//                            }
//                        }
//                    }
//                }
//            }
//        }
//        else if([self.vc isMemberOfClass:[ReceiptViewController class]])
//        {
//            arrReferenceTable = @[@"OrderTaking",@"Menu",@"OrderNote",@"Member",@"Address",@"Receipt",@"Discount",@"Setting",@"UserAccount",@"RewardProgram",@"RewardPoint",@"ReceiptNo",@"ReceiptNoTax",@"ReceiptCustomerTable",@"TableTaking",@"BillPrint"];
//
//
//
//            //ถ้า receipt เป็น โต๊ะตัวเองถึงจะ loadviewprocess
//            ReceiptViewController *receiptVc = (ReceiptViewController *)self.vc;
//            for(int j=0; j<[items count]; j++)
//            {
//                NSDictionary *payload = items[j];
//                NSString *type = [payload objectForKey:@"type"];
//                NSString *action = [payload objectForKey:@"action"];
//                //NSString *strPushSyncID = [payload objectForKey:@"pushSyncID"];
//                NSArray *data = [payload objectForKey:@"data"];
//
//
//                if([type isEqualToString:@"Receipt"])
//                {
//                    NSString *className = type;
//                    NSString *strNameID = [Utility getPrimaryKeyFromClassName:type];
//
//
//                    Class class = NSClassFromString([NSString stringWithFormat:@"Shared%@",className]);
//                    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"shared%@",className]);
//                    SEL selectorList = NSSelectorFromString([NSString stringWithFormat:@"%@List",[Utility makeFirstLetterLowerCase:className]]);
//                    NSMutableArray *dataList = [[class performSelector:selector] performSelector:selectorList];
//
//
//                    //insert,update,delete data
//                    for(int i=0; i<[data count]; i++)
//                    {
//                        NSDictionary *jsonElement = data[i];
//                        NSObject *object = [[NSClassFromString(className) alloc] init];
//
//                        unsigned int propertyCount = 0;
//                        objc_property_t * properties = class_copyPropertyList([object class], &propertyCount);
//
//                        for (unsigned int i = 0; i < propertyCount; ++i)
//                        {
//                            objc_property_t property = properties[i];
//                            const char * name = property_getName(property);
//                            NSString *key = [NSString stringWithUTF8String:name];
//
//
//                            NSString *dbColumnName = [Utility makeFirstLetterUpperCase:key];
//                            if(!jsonElement[dbColumnName])
//                            {
//                                continue;
//                            }
//
//
//                            if([Utility isDateColumn:dbColumnName])
//                            {
//                                NSDate *date = [Utility stringToDate:jsonElement[dbColumnName] fromFormat:@"yyyy-MM-dd HH:mm:ss"];
//                                [object setValue:date forKey:key];
//                            }
//                            else
//                            {
//                                [object setValue:jsonElement[dbColumnName] forKey:key];
//                            }
//                        }
//
//
//                        if([action isEqualToString:@"i"] || [action isEqualToString:@"u"])
//                        {
//                            Receipt *receipt = (Receipt *)object;
//                            if(receipt.customerTableID == receiptVc.customerTable.customerTableID)
//                            {
//                                loadViewProcess = YES;
//                                break;
//                            }
//                        }
//                    }
//                }
//                else if([type isEqualToString:@"OrderTaking"])
//                {
//                    NSString *className = type;
//                    NSString *strNameID = [Utility getPrimaryKeyFromClassName:type];
//
//
//                    Class class = NSClassFromString([NSString stringWithFormat:@"Shared%@",className]);
//                    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"shared%@",className]);
//                    SEL selectorList = NSSelectorFromString([NSString stringWithFormat:@"%@List",[Utility makeFirstLetterLowerCase:className]]);
//                    NSMutableArray *dataList = [[class performSelector:selector] performSelector:selectorList];
//
//
//                    //insert,update,delete data
//                    for(int i=0; i<[data count]; i++)
//                    {
//                        NSDictionary *jsonElement = data[i];
//                        NSObject *object = [[NSClassFromString(className) alloc] init];
//
//                        unsigned int propertyCount = 0;
//                        objc_property_t * properties = class_copyPropertyList([object class], &propertyCount);
//
//                        for (unsigned int i = 0; i < propertyCount; ++i)
//                        {
//                            objc_property_t property = properties[i];
//                            const char * name = property_getName(property);
//                            NSString *key = [NSString stringWithUTF8String:name];
//
//
//                            NSString *dbColumnName = [Utility makeFirstLetterUpperCase:key];
//                            if(!jsonElement[dbColumnName])
//                            {
//                                continue;
//                            }
//
//
//                            if([Utility isDateColumn:dbColumnName])
//                            {
//                                NSDate *date = [Utility stringToDate:jsonElement[dbColumnName] fromFormat:@"yyyy-MM-dd HH:mm:ss"];
//                                [object setValue:date forKey:key];
//                            }
//                            else
//                            {
//                                [object setValue:jsonElement[dbColumnName] forKey:key];
//                            }
//                        }
//
//
//                        if([action isEqualToString:@"i"])
//                        {
//                            OrderTaking *orderTaking = (OrderTaking *)object;
//                            if(orderTaking.customerTableID == receiptVc.customerTable.customerTableID)
//                            {
//                                loadViewProcess = YES;
//                                NSLog(@"test loadviewprocess yes ordertaking");
//                                break;
//                            }
//                        }
//                    }
//                }
//            }
//        }
//        else if([self.vc isMemberOfClass:[CustomerTableViewController class]])
//        {
//            arrReferenceTable = @[@"UserAccount",@"TableTaking",@"OrderTaking",@"UserTabMenu",@"Board",@"Receipt"];
//            loadViewProcess = YES;
//        }
//        else if([self.vc isMemberOfClass:[CustomerKitchenViewController class]])
//        {
//            arrReferenceTable = @[@"OrderTaking",@"Receipt",@"OrderNote",@"PrintReceipt"];
//            loadViewProcess = YES;
//        }
//        NSArray *resultArray = [Utility intersectArray1:arrAllType array2:arrReferenceTable];
//        if([resultArray count] > 0)
//        {
//            if(loadViewProcess)
//            {
//                {
//                    SEL s = NSSelectorFromString(@"loadingOverlayView");
//                    if([self.vc respondsToSelector:s])
//                    {
//                        [self.vc performSelector:s];
//                    }
//                }
//
//                {
//                    SEL s = NSSelectorFromString(@"loadViewProcess");
//                    if([self.vc respondsToSelector:s])
//                    {
//                        [self.vc performSelector:s];
//                    }
//                }
//
//                {
//                    SEL s = NSSelectorFromString(@"removeOverlayViews");
//                    if([self.vc respondsToSelector:s])
//                    {
//                        [self.vc performSelector:s];
//                    }
//                }
//            }
//        }
//    }
//}

- (void)itemsUpdated
{
    
}

- (void)itemsInserted
{
    
}

- (void)itemsDeleted
{
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    if(![Utility finishLoadSharedData])
    {
        return;
    }
    
    
    //load shared at the begining of everyday
    NSDictionary *todayLoadShared = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"todayLoadShared"];
    NSString *strCurrentDate = [Utility dateToString:[Utility currentDateTime] toFormat:@"yyyy-MM-dd"];
    NSString *alreadyLoaded = [todayLoadShared objectForKey:strCurrentDate];
    
    if(!alreadyLoaded)
    {
        //download dbMaster
//        UINavigationController * navigationController = self.navController;
//        UIViewController *viewController = navigationController.visibleViewController;
        SEL s = NSSelectorFromString(@"loadingOverlayView");
        [self.vc performSelector:s];
        
        [_homeModel downloadItems:dbMaster];
        [[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionaryWithObject:@"1" forKey:strCurrentDate] forKey:@"todayLoadShared"];
        
    }
    else
    {
        //check timesynced = null where devicetoken = [Utility deviceToken];
        PushSync *pushSync = [[PushSync alloc]init];
        pushSync.deviceToken = [Utility deviceToken];
        [_homeModelSyncItems syncItems:dbPushSync withData:pushSync];
        NSLog(@"syncitems");
    }
    
    NSNumber *receiptID = [NSNumber numberWithInteger:_testReceiptID];
//    [_homeModel downloadItems:dbJummumReceipt withData:receiptID];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(void)itemsDownloaded:(NSArray *)items
{
    if(_homeModel.propCurrentDB == dbMaster)
    {
        {
            PushSync *pushSync = [[PushSync alloc]init];
            pushSync.deviceToken = [Utility deviceToken];
            [_homeModelPushSyncUpdateByDevice updateItems:dbPushSyncUpdateByDeviceToken withData:pushSync actionScreen:@"update synced time by device token"];
        }
        
        
        [Utility itemsDownloaded:items];
        {
            SEL s = NSSelectorFromString(@"loadViewProcess");
            [self.vc performSelector:s];
        }
        {
            SEL s = NSSelectorFromString(@"removeOverlayViews");
            [self.vc performSelector:s];
        }
    }
    else if(_homeModel.propCurrentDB == dbJummumReceipt)
    {
        for(NSArray *itemList in items)
        {
            for(NSObject *object in itemList)
            {
                [Utility addObjectIfNotDuplicate:object];
            }
        }


        Receipt *receipt = items[0][0];
        
        
        
        //************Print kitchen bill
        NSMutableArray *receiptList = [[NSMutableArray alloc]init];
        [receiptList addObject:receipt];
        CustomerKitchenViewController *vc = (CustomerKitchenViewController *)self.vc;
        [vc printReceiptKitchenBill:receiptList];
        //************
    }
    else if(_homeModel.propCurrentDB == dbJummumReceiptUpdate)
    {
        NSMutableArray *receiptList = items[0];
        NSMutableArray *disputeList = items[3];
        if([receiptList count]>0)
        {
            Receipt *receipt = receiptList[0];
            [Receipt updateStatus:receipt];
            
            
            if([self.vc isMemberOfClass:[CustomerKitchenViewController class]])
            {
                CustomerKitchenViewController *vc = (CustomerKitchenViewController *)self.vc;
                [vc setReceiptList];
                [vc.tbvData reloadData];
            }
            else if([self.vc isMemberOfClass:[OrderDetailViewController class]])
            {
                OrderDetailViewController *vc = (OrderDetailViewController *)self.vc;
                [vc.tbvData reloadData];
            }
        }
        if([disputeList count] > 0)
        {
            NSMutableArray *dataList = [[NSMutableArray alloc]init];
            [dataList addObject:disputeList];
            [Utility addToSharedDataList:dataList];            
        }
    }
}

- (void)itemsFail
{
//    UINavigationController * navigationController = self.navController;
//    UIViewController *viewController = navigationController.visibleViewController;
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:[Utility getConnectionLostTitle]
                                                                   message:[Utility getConnectionLostMessage]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        SEL s = NSSelectorFromString(@"loadingOverlayView");
                                        [self.vc performSelector:s];
                                        [_homeModel downloadItems:dbMaster];
                                    }];
    
    [alert addAction:defaultAction];
    dispatch_async(dispatch_get_main_queue(),^ {
        [self.vc presentViewController:alert animated:YES completion:nil];
    });
}

- (void) connectionFail
{
//    UINavigationController * navigationController = self.navController;
//    UIViewController *viewController = navigationController.visibleViewController;
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:[Utility subjectNoConnection]
                                                                   message:[Utility detailNoConnection]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              //                                                              exit(0);
                                                          }];
    
    [alert addAction:defaultAction];
    dispatch_async(dispatch_get_main_queue(),^ {
        [self.vc presentViewController:alert animated:YES completion:nil];
    } );
}

//printer part******
- (void)loadParam {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults registerDefaults:[NSDictionary dictionaryWithObject:@""                           forKey:@"portName"]];
    [userDefaults registerDefaults:[NSDictionary dictionaryWithObject:@""                           forKey:@"portSettings"]];
    [userDefaults registerDefaults:[NSDictionary dictionaryWithObject:@""                           forKey:@"modelName"]];
    [userDefaults registerDefaults:[NSDictionary dictionaryWithObject:@""                           forKey:@"macAddress"]];
    [userDefaults registerDefaults:[NSDictionary dictionaryWithObject:@(StarIoExtEmulationStarPRNT) forKey:@"emulation"]];
    [userDefaults registerDefaults:[NSDictionary dictionaryWithObject:@YES                          forKey:@"cashDrawerOpenActiveHigh"]];
    [userDefaults registerDefaults:[NSDictionary dictionaryWithObject:@0x00000007                   forKey:@"allReceiptsSettings"]];
    
    _portName                 = [userDefaults stringForKey :@"portName"];
    _portSettings             = [userDefaults stringForKey :@"portSettings"];
    _modelName                = [userDefaults stringForKey :@"modelName"];
    _macAddress               = [userDefaults stringForKey :@"macAddress"];
    _emulation                = [userDefaults integerForKey:@"emulation"];
    _cashDrawerOpenActiveHigh = [userDefaults boolForKey   :@"cashDrawerOpenActiveHigh"];
    _allReceiptsSettings      = [userDefaults integerForKey:@"allReceiptsSettings"];
}

+ (NSString *)getPortName {
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    return delegate.portName;
}

+ (void)setPortName:(NSString *)portName {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    delegate.portName = portName;
    
    [userDefaults setObject:delegate.portName forKey:@"portName"];
    
    [userDefaults synchronize];
}

+ (NSString*)getPortSettings {
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    return delegate.portSettings;
}

+ (void)setPortSettings:(NSString *)portSettings {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    delegate.portSettings = portSettings;
    
    [userDefaults setObject :delegate.portSettings forKey:@"portSettings"];
    
    [userDefaults synchronize];
}

+ (NSString *)getModelName {
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    return delegate.modelName;
}

+ (void)setModelName:(NSString *)modelName {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    delegate.modelName = modelName;
    
    [userDefaults setObject:delegate.modelName forKey:@"modelName"];
    
    [userDefaults synchronize];
}

+ (NSString *)getMacAddress {
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    return delegate.macAddress;
}

+ (void)setMacAddress:(NSString *)macAddress {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    delegate.macAddress = macAddress;
    
    [userDefaults setObject:delegate.macAddress forKey:@"macAddress"];
    
    [userDefaults synchronize];
}

+ (StarIoExtEmulation)getEmulation {
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    return delegate.emulation;
}

+ (void)setEmulation:(StarIoExtEmulation)emulation {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    delegate.emulation = emulation;
    
    [userDefaults setInteger:delegate.emulation forKey:@"emulation"];
    
    [userDefaults synchronize];
}

+ (BOOL)getCashDrawerOpenActiveHigh {
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    return delegate.cashDrawerOpenActiveHigh;
}

+ (void)setCashDrawerOpenActiveHigh:(BOOL)activeHigh {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    delegate.cashDrawerOpenActiveHigh = activeHigh;
    
    [userDefaults setInteger:delegate.cashDrawerOpenActiveHigh forKey:@"cashDrawerOpenActiveHigh"];
    
    [userDefaults synchronize];
}

+ (NSInteger)getAllReceiptsSettings {
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    return delegate.allReceiptsSettings;
}

+ (void)setAllReceiptsSettings:(NSInteger)allReceiptsSettings {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    delegate.allReceiptsSettings = allReceiptsSettings;
    
    [userDefaults setInteger:delegate.allReceiptsSettings forKey:@"allReceiptsSettings"];
    
    [userDefaults synchronize];
}

+ (NSInteger)getSelectedIndex {
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    return delegate.selectedIndex;
}

+ (void)setSelectedIndex:(NSInteger)index {
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    delegate.selectedIndex = index;
}

+ (LanguageIndex)getSelectedLanguage {
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    return delegate.selectedLanguage;
}

+ (void)setSelectedLanguage:(LanguageIndex)index {
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    delegate.selectedLanguage = index;
}

+ (PaperSizeIndex)getSelectedPaperSize {
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    return delegate.selectedPaperSize;
}

+ (void)setSelectedPaperSize:(PaperSizeIndex)index {
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    delegate.selectedPaperSize = index;
}
@end
