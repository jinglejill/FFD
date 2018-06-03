//
//  CustomTableViewCellCreditCardType.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 9/30/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCellCreditCardType : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *btnAmericanExpress;
@property (strong, nonatomic) IBOutlet UIButton *btnJCB;
@property (strong, nonatomic) IBOutlet UIButton *btnMasterCard;
@property (strong, nonatomic) IBOutlet UIButton *btnUnionPay;
@property (strong, nonatomic) IBOutlet UIButton *btnVisa;
@property (strong, nonatomic) IBOutlet UIButton *btnOther;

@end
