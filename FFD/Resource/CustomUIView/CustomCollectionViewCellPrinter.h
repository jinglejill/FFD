//
//  CustomCollectionViewCellPrinter.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 24/1/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionViewCellPrinter : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblPrinterName;
@property (strong, nonatomic) IBOutlet UILabel *lblModel;
@property (strong, nonatomic) IBOutlet UIImageView *imVwStatus;
@property (strong, nonatomic) IBOutlet UILabel *lblPortAndMacAddress;
@property (strong, nonatomic) IBOutlet UIButton *btnTrash;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *vwWidthConstant;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblModelTopConstant;

@end
