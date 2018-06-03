//
//  CustomTableViewCellLabelCorrectIncorrect.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 3/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCellLabelCorrectIncorrect : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblText;
@property (strong, nonatomic) IBOutlet UIButton *btnCorrect;
@property (strong, nonatomic) IBOutlet UIButton *btnIncorrect;
@end
