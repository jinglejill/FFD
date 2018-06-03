//
//  CustomTableViewCell.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/11/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *lblDetailTextLabel;
@property (strong, nonatomic) UILongPressGestureRecognizer *longPressGestureRecognizer;
@end
