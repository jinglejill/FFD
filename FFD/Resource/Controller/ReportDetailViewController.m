//
//  ReportDetailViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/20/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "ReportDetailViewController.h"


@interface ReportDetailViewController ()
{
}
@end

@implementation ReportDetailViewController
@synthesize startDate;
@synthesize endDate;
@synthesize reportView;
@synthesize frequency;
@synthesize reportType;
@synthesize reportGroup;

- (void)segToVCWithReportGroup:(enum reportGroup)reportGroup reportType:(enum reportType)reportType frequency:(enum frequency)frequency reportView:(enum reportView)reportView
{
    switch (reportGroup)
    {
        case reportGroupSales:
        {
            switch (reportType)
            {
                case reportTypeSalesAll:
                {
                    switch (frequency)
                    {
                        case frequencyDaily:
                        {
                            switch (reportView)
                            {
                                case reportViewGraph:
                                {
                                    [self performSegueWithIdentifier:@"segReportSalesAllDailyGraph" sender:self];
                                    return;
                                }
                                    break;
                                case reportViewTable:
                                {
                                    [self performSegueWithIdentifier:@"segReportSalesAllDailyTable" sender:self];
                                    return;
                                }
                                    break;
                                default:
                                    break;
                            }
                        }
                            break;
                        case frequencyWeekly:
                        {
                            switch (reportView)
                            {
                                case reportViewGraph:
                                {
                                    [self performSegueWithIdentifier:@"segReportSalesAllWeeklyGraph" sender:self];
                                    return;
                                }
                                break;
                                case reportViewTable:
                                {
                                    [self performSegueWithIdentifier:@"segReportSalesAllWeeklyTable" sender:self];
                                    return;
                                }
                                break;
                                default:
                                break;
                            }
                        }
                        break;
                        case frequencyMonthly:
                        {
                            switch (reportView)
                            {
                                case reportViewGraph:
                                {
                                    [self performSegueWithIdentifier:@"segReportSalesAllMonthlyGraph" sender:self];
                                    return;
                                }
                                break;
                                case reportViewTable:
                                {
                                    [self performSegueWithIdentifier:@"segReportSalesAllMonthlyTable" sender:self];
                                    return;
                                }
                                break;
                                default:
                                break;
                            }
                        }
                        break;

                        default:
                            break;
                    }
                }
                    break;
                case reportTypeSalesByMenuType:
                {
                    switch (frequency) {
                        case frequencyDaily:
                        {
                            switch (reportView) {
                                case reportViewGraph:
                                {
                                    [self performSegueWithIdentifier:@"segReportSalesByMenuTypeDailyGraph" sender:self];
                                    return;
                                }
                                    break;
                                case reportViewTable:
                                {
                                    [self performSegueWithIdentifier:@"segReportSalesByMenuTypeDailyTable" sender:self];
                                    return;
                                }
                                    break;
                                default:
                                    break;
                            }
                        }
                            break;
                        case frequencyWeekly:
                        {
                            switch (reportView) {
                                case reportViewGraph:
                                {
                                    [self performSegueWithIdentifier:@"segReportSalesByMenuTypeWeeklyGraph" sender:self];
                                    return;
                                }
                                break;
                                case reportViewTable:
                                {
                                    [self performSegueWithIdentifier:@"segReportSalesByMenuTypeWeeklyTable" sender:self];
                                    return;
                                }
                                break;
                                default:
                                break;
                            }
                        }
                        break;
                        case frequencyMonthly:
                        {
                            switch (reportView) {
                                case reportViewGraph:
                                {
                                    [self performSegueWithIdentifier:@"segReportSalesByMenuTypeMonthlyGraph" sender:self];
                                    return;
                                }
                                break;
                                case reportViewTable:
                                {
                                    [self performSegueWithIdentifier:@"segReportSalesByMenuTypeMonthlyTable" sender:self];
                                    return;
                                }
                                break;
                                default:
                                break;
                            }
                        }
                        break;
                        default:
                            break;
                    }
                }
                    break;
                case reportTypeSalesByMenu:
                {
                    switch (reportView) {
                        case reportViewGraph:
                        {

                        }
                            break;
                        case reportViewTable:
                        {
                            [self performSegueWithIdentifier:@"segReportSalesByMenuTable" sender:self];
                            return;
                        }
                            break;
                        default:
                            break;
                    }
                }
                    break;
                case reportTypeSalesByMember:
                {
                    switch (reportView) {
                        case reportViewGraph:
                        {
                            
                        }
                        break;
                        case reportViewTable:
                        {
                            [self performSegueWithIdentifier:@"segReportSalesByMemberTable" sender:self];
                            return;
                        }
                        break;
                        default:
                        break;
                    }
                }
                break;
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
    [self performSegueWithIdentifier:@"segReportBlank" sender:self];
}

- (IBAction)unwindToReportDetail:(UIStoryboardSegue *)segue
{
    CustomReportViewController *vc = segue.sourceViewController;
    reportGroup = vc.reportGroup;
    reportType = vc.reportType;
    frequency = vc.frequency;
    reportView = vc.reportView;
    startDate = vc.startDate;
    endDate = vc.endDate;

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CustomReportViewController *vc = segue.destinationViewController;
    vc.startDate = startDate;
    vc.endDate = endDate;
    vc.reportView = reportView;
    vc.frequency = frequency;
    vc.reportType = reportType;
    vc.reportGroup = reportGroup;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self segToVCWithReportGroup:reportGroup reportType:reportType frequency:frequency reportView:reportView];
}

- (void)loadView
{
    [super loadView];
    

    [self loadViewProcess];
    
}

- (void)loadViewProcess
{
    if(!startDate)
    {
        startDate = [Utility getPrevious14Days];
        endDate = [Utility currentDateTime];
        
        
        startDate = [Utility setStartOfTheDay:startDate];
        endDate = [Utility setEndOfTheDay:endDate];
        
        
        reportGroup = 0;
        reportType = 0;
        frequency = 0;
        reportView = 0;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tapGesture];
    [tapGesture setCancelsTouchesInView:NO];
}



@end
