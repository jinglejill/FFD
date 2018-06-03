//
//  CustomViewController.m
//  Eventoree
//
//  Created by Thidaporn Kijkamjai on 8/29/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "OrderTakingViewController.h"
#import "HomeModel.h"
#import "Utility.h"
#import "PushSync.h"


@interface CustomViewController ()

@end

@implementation CustomViewController
@synthesize homeModel;
@synthesize indicator;
@synthesize overlayView;


- (void)loadView
{
    [super loadView];
    homeModel = [[HomeModel alloc]init];
    homeModel.delegate = self;
    
    
    {
        overlayView = [[UIView alloc] initWithFrame:self.view.frame];
        overlayView.backgroundColor = [UIColor colorWithRed:256 green:256 blue:256 alpha:0];
        
        
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.frame = CGRectMake(self.view.bounds.size.width/2-indicator.frame.size.width/2,self.view.bounds.size.height/2-indicator.frame.size.height/2,indicator.frame.size.width,indicator.frame.size.height);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void) loadingOverlayView
{
    [indicator startAnimating];
    indicator.layer.zPosition = 1;
    indicator.alpha = 1;
    
    
    // and just add them to navigationbar view
    [self.view addSubview:overlayView];
    [self.view addSubview:indicator];
}

-(void) removeOverlayViews{
    UIView *view = overlayView;
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         view.alpha = 0.0;
                         indicator.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         dispatch_async(dispatch_get_main_queue(),^ {
                             [view removeFromSuperview];
                             [indicator stopAnimating];
                             [indicator removeFromSuperview];
                         } );
                     }
     ];
}

- (void) connectionFail
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:[Utility subjectNoConnection]
                                                                   message:[Utility detailNoConnection]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        [homeModel downloadItems:dbMasterWithProgressBar];
                                    }];
    
    [alert addAction:defaultAction];
    dispatch_async(dispatch_get_main_queue(),^ {
        [self presentViewController:alert animated:YES completion:nil];
    } );
}

- (void)itemsFail
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:[Utility getConnectionLostTitle]
                                                                   message:[Utility getConnectionLostMessage]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              if(![indicator isAnimating])
                                                              {
                                                                  [self loadingOverlayView];
                                                              }
                                                              [homeModel downloadItems:dbMaster];
                                                          }];
    
    [alert addAction:defaultAction];
    dispatch_async(dispatch_get_main_queue(),^ {
        [self presentViewController:alert animated:YES completion:nil];
    } );
}

- (void)itemsInserted
{
    [self syncItems];
}

- (void)itemsUpdated
{

}

- (void)syncItems
{
    PushSync *pushSync = [[PushSync alloc]init];
    pushSync.deviceToken = [Utility deviceToken];
    [homeModel syncItems:dbPushSync withData:pushSync];
}

- (void) showAlert:(NSString *)title message:(NSString *)message
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        [self loadingOverlayView];
                                        PushSync *pushSync = [[PushSync alloc]init];
                                        pushSync.deviceToken = [Utility deviceToken];
                                        [homeModel syncItems:dbPushSync withData:pushSync];
                                    }];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) showAlertAndCallPushSync:(NSString *)title message:(NSString *)message
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        [self loadingOverlayView];
                                        PushSync *pushSync = [[PushSync alloc]init];
                                        pushSync.deviceToken = [Utility deviceToken];
                                        [homeModel syncItems:dbPushSync withData:pushSync];
                                    }];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)itemsSynced:(NSArray *)items
{
    if([items count] == 0)
    {
        [self removeOverlayViews];
        return;
    }
    NSMutableArray *pushSyncList = [[NSMutableArray alloc]init];
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
        
        
        if([type isEqualToString:@"alert"])
        {
            NSString *alertMsg = [NSString stringWithFormat:@"%@ is fail",(NSString *)data];
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:[Utility getSqlFailTitle]
                                                                           message:alertMsg
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action)
                                            {
                                                [self loadingOverlayView];
                                                [homeModel downloadItems:dbMaster];
                                            }];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            if([data isKindOfClass:[NSArray class]])
            {
                [Utility itemsSynced:type action:action data:data];
            }
        }
    }
    
    
    //update pushsync ที่ sync แล้ว
    if([pushSyncList count]>0)
    {
        [homeModel updateItems:dbPushSyncUpdateTimeSynced withData:pushSyncList actionScreen:@"Update synced time by id"];
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
        if([self isMemberOfClass:[OrderTakingViewController class]])//check กรณีเดียวก่อนคือ OrderTakingViewController
        {
            NSArray *arrReferenceTable = @[@"MenuType",@"Menu",@"TableTaking",@"CustomerTable",@"OrderTaking",@"MenuTypeNote",@"OrderNote"];
            
            NSArray *resultArray = [Utility intersectArray1:arrAllType array2:arrReferenceTable];
            if([resultArray count] > 0)
            {
//                [self loadingOverlayView];
                [self loadViewProcess];
                [self removeOverlayViews];
            }
        }
    }
}

-(void)itemsDownloaded:(NSArray *)items
{
    PushSync *pushSync = [[PushSync alloc]init];
    pushSync.deviceToken = [Utility deviceToken];
    [homeModel updateItems:dbPushSyncUpdateByDeviceToken withData:pushSync actionScreen:@"Update synced time by device token"];
    
    
    [Utility itemsDownloaded:items];
    [self removeOverlayViews];
    [self loadViewProcess];//call child process
}

-(void)loadViewProcess
{
    
}

-(void)setShadow:(UIView *)view
{
//    view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
//    view.layer.shadowOffset = CGSizeMake(0, 2.0f);
//    view.layer.shadowRadius = 2.0f;
//    view.layer.shadowOpacity = 0.8f;
//    view.layer.masksToBounds = NO;
    [self setShadow:view radius:2];
}

-(void)setShadow:(UIView *)view radius:(NSInteger)radius
{
    view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(0, radius);
    view.layer.shadowRadius = radius;
    view.layer.shadowOpacity = 0.8f;
    view.layer.masksToBounds = NO;
}

-(void)setCornerAndShadow:(UIView *)view
{
    [self setCornerAndShadow:view radius:4];
}

-(void)setCornerAndShadow:(UIView *)view radius:(NSInteger)radius
{
    view.layer.cornerRadius = radius;
    [self setShadow:view];
}
@end
