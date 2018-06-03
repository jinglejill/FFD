//
//  BranchSelectViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 7/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "BranchSelectViewController.h"
#import "LogInViewController.h"
#import "CredentialsDb.h"
#import "Device.h"
#import "PushSync.h"


//extern NSArray *globalMessage;
@interface BranchSelectViewController ()
{
    NSInteger _selectedIndexPicker;
    CredentialsDb *_credentialsDb;
}
@end

@implementation BranchSelectViewController
@synthesize credentialsDbList;
@synthesize pickerVw;
@synthesize btnOk;
@synthesize txtBranch;
@synthesize progressBar;


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CredentialsDb *credentialsDb = credentialsDbList[_selectedIndexPicker];
    textField.text = credentialsDb.name;
    [pickerVw selectRow:_selectedIndexPicker inComponent:0 animated:NO];
}

-(void)loadView
{
    [super loadView];

    
    [pickerVw removeFromSuperview];
    txtBranch.delegate = self;
    txtBranch.inputView = pickerVw;
    pickerVw.delegate = self;
    pickerVw.dataSource = self;
    pickerVw.showsSelectionIndicator = YES;
    
    
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"rememberMe"])
    {
        NSString *dbName = [[NSUserDefaults standardUserDefaults] stringForKey:BRANCH];
        NSString *branchName = [CredentialsDb getNameWithDbName:dbName credentialsDbList:credentialsDbList];
        _selectedIndexPicker = [CredentialsDb getSelectedIndexWithDbName:dbName credentialsDbList:credentialsDbList];
        txtBranch.text = branchName;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    progressBar = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    
    {
        CGRect frame = progressBar.frame;
        frame.size.width = self.view.frame.size.width-200;
        progressBar.frame = frame;
    }
    progressBar.center = self.view.center;
    
    {
        CGRect frame = progressBar.frame;
        frame.origin.y = self.view.frame.size.height-20;
        progressBar.frame = frame;
    }
    
    [self.view addSubview:progressBar];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component
{
    // Handle the selection
    
    if([txtBranch isFirstResponder])
    {
        _selectedIndexPicker = row;
        CredentialsDb *credentialsDb = credentialsDbList[row];
        txtBranch.text = credentialsDb.name;
        [txtBranch resignFirstResponder];
    }
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if([txtBranch isFirstResponder])
    {
        return [credentialsDbList count];
    }
    
    return 0;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *strText = @"";
    if([txtBranch isFirstResponder])
    {
        CredentialsDb *credentialsDb = credentialsDbList[row];
        strText = credentialsDb.name;
    }
    
    return strText;
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return self.view.frame.size.width;
}

- (IBAction)okAction:(id)sender
{
    NSString *dbName = [[NSUserDefaults standardUserDefaults] stringForKey:BRANCH];
    _credentialsDb = credentialsDbList[_selectedIndexPicker];
    [Utility setBranchID:_credentialsDb.branchID];
    
    
    if(![dbName isEqualToString:_credentialsDb.dbName])
    {
        [[NSUserDefaults standardUserDefaults] setValue:_credentialsDb.dbName forKey:BRANCH];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"logInUsername"];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"logInPassword"];
        [[NSUserDefaults standardUserDefaults] setBool:0 forKey:@"rememberMe"];
    }
    
    


    //insert device for pushNotification to update data in the same branch, so delete deviceToken that stay in other db(เพราะได้ switch มาใช้ branch นี้แล้ว)
    Device *device = [[Device alloc]init];
    device.deviceToken = [Utility deviceToken];
    device.remark = [self deviceName];
    [self.homeModel insertItems:dbDevice withData:device actionScreen:@"Add device in branchSelect screen"];

}

-(void)itemsInserted
{
    [self downloadData];
}

- (void)downloadData
{
    [self.homeModel downloadItems:dbMasterWithProgressBar];
}

- (void)itemsDownloaded:(NSArray *)items
{
    if([items count] == 0)
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Warning"
                                                                       message:@"Memory fail"
                                                                preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action)
                                        {

                                        }];

        [alert addAction:defaultAction];
        dispatch_async(dispatch_get_main_queue(),^ {
            [self presentViewController:alert animated:YES completion:nil];
        } );
        return;
    }

    {
        PushSync *pushSync = [[PushSync alloc]init];
        pushSync.deviceToken = [Utility deviceToken];
        [self.homeModelPushSyncUpdateByDevice updateItems:dbPushSyncUpdateByDeviceToken withData:pushSync actionScreen:@"update synced time by device token"];
    }



    [Utility itemsDownloaded:items];
    [self removeOverlayViews];//อาจ มีการเรียกจากหน้า customViewController



    [Utility setFinishLoadSharedData:YES];
    [self performSegueWithIdentifier:@"segSignIn" sender:self];
}

- (void)downloadProgress:(float)percent
{
    progressBar.progress = percent;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    LogInViewController *vc = segue.destinationViewController;
    vc.credentialsDb = _credentialsDb;
}
@end
