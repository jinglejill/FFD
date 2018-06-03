//
//  ApiViewController.m
//  ObjectiveC SDK
//
//  Created by Yuji on 2016/**/**.
//  Copyright © 2016年 Star Micronics. All rights reserved.
//

#import "ApiViewController.h"

#import "AppDelegate.h"

#import "ApiFunctions.h"

#import "Communication.h"

@interface ApiViewController ()

@end

@implementation ApiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return 22;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    static NSString *CellIdentifier = @"UITableViewCellStyleValue1";
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    if (cell != nil) {
        switch (indexPath.row) {
            default :
//          case 0  :
                cell.textLabel.text = @"Generic";
                break;
            case 1  :
                cell.textLabel.text = @"Font Style";
                break;
            case 2  :
                cell.textLabel.text = @"Initialization";
                break;
            case 3  :
                cell.textLabel.text = @"Code Page";
                break;
            case 4  :
                cell.textLabel.text = @"International";
                break;
            case 5  :
                cell.textLabel.text = @"Feed";
                break;
            case 6  :
                cell.textLabel.text = @"Character Space";
                break;
            case 7  :
                cell.textLabel.text = @"Line Space";
                break;
            case 8  :
                cell.textLabel.text = @"Emphasis";
                break;
            case 9  :
                cell.textLabel.text = @"Invert";
                break;
            case 10 :
                cell.textLabel.text = @"Under Line";
                break;
            case 11 :
                cell.textLabel.text = @"Multiple";
                break;
            case 12 :
                cell.textLabel.text = @"Absolute Position";
                break;
            case 13 :
                cell.textLabel.text = @"Alignment";
                break;
            case 14 :
                cell.textLabel.text = @"Logo";
                break;
            case 15 :
                cell.textLabel.text = @"Cut Paper";
                break;
            case 16 :
                cell.textLabel.text = @"Peripheral";
                break;
            case 17 :
                cell.textLabel.text = @"Sound";
                break;
            case 18 :
                cell.textLabel.text = @"Bitmap";
                break;
            case 19 :
                cell.textLabel.text = @"Barcode";
                break;
            case 20 :
                cell.textLabel.text = @"PDF417";
                break;
            case 21 :
                cell.textLabel.text = @"QR Code";
                break;
        }
        
        cell.detailTextLabel.text = @"";
        
        cell.      textLabel.textColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Sample";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSData *commands = nil;
    
    StarIoExtEmulation emulation = [AppDelegate getEmulation];
    
    NSInteger width = [AppDelegate getSelectedPaperSize];
    
    switch (indexPath.row) {
        default :
//      case 0  :
            commands = [ApiFunctions createGenericData:emulation];
            break;
        case 1  :
            commands = [ApiFunctions createFontStyleData:emulation];
            break;
        case 2  :
            commands = [ApiFunctions createInitializationData:emulation];
            break;
        case 3  :
            commands = [ApiFunctions createCodePageData:emulation];
            break;
        case 4  :
            commands = [ApiFunctions createInternationalData:emulation];
            break;
        case 5  :
            commands = [ApiFunctions createFeedData:emulation];
            break;
        case 6  :
            commands = [ApiFunctions createCharacterSpaceData:emulation];
            break;
        case 7  :
            commands = [ApiFunctions createLineSpaceData:emulation];
            break;
        case 8  :
            commands = [ApiFunctions createEmphasisData:emulation];
            break;
        case 9  :
            commands = [ApiFunctions createInvertData:emulation];
            break;
        case 10 :
            commands = [ApiFunctions createUnderLineData:emulation];
            break;
        case 11 :
            commands = [ApiFunctions createMultipleData:emulation];
            break;
        case 12 :
            commands = [ApiFunctions createAbsolutePositionData:emulation];
            break;
        case 13 :
            commands = [ApiFunctions createAlignmentData:emulation];
            break;
        case 14 :
            commands = [ApiFunctions createLogoData:emulation];
            break;
        case 15 :
            commands = [ApiFunctions createCutPaperData:emulation];
            break;
        case 16 :
            commands = [ApiFunctions createPeripheralData:emulation];
            break;
        case 17 :
            commands = [ApiFunctions createSoundData:emulation];
            break;
        case 18 :
            commands = [ApiFunctions createBitmapData:emulation width:width];
            break;
        case 19 :
            commands = [ApiFunctions createBarcodeData:emulation];
            break;
        case 20 :
            commands = [ApiFunctions createPdf417Data:emulation];
            break;
        case 21 :
            commands = [ApiFunctions createQrCodeData:emulation];
            break;
    }
    
    self.blind = YES;
    
    NSString *portName     = [AppDelegate getPortName];
    NSString *portSettings = [AppDelegate getPortSettings];
    
    [Communication sendCommands:commands portName:portName portSettings:portSettings timeout:10000 completionHandler:^(BOOL result, NSString *title, NSString *message) {     // 10000mS!!!
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
    }];
    
    self.blind = NO;
}

@end
