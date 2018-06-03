//
//  BranchListViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 4/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "BranchListViewController.h"
#import "BranchAddViewController.h"
#import "CustomCollectionViewCellBranch.h"
#import "CustomCollectionViewCellBranchHeader.h"
#import "Branch.h"


@interface BranchListViewController ()
{
    NSMutableArray *_allBranchList;
    NSMutableArray *_branchList;
    Branch *_editBranch;
}
@property (nonatomic,strong) NSArray        *dataSource;
//@property (nonatomic,strong) NSMutableArray *dataSourceForSearchResult;
@property (nonatomic)        BOOL           searchBarActive;
@property (nonatomic)        float          searchBarBoundsY;
@property (nonatomic,strong) UISearchBar        *searchBar;
@end

@implementation BranchListViewController
static NSString * const reuseIdentifierBranch = @"CustomCollectionViewCellBranch";
static NSString * const reuseIdentifierBranchHeader = @"CustomCollectionViewCellBranchHeader";


@synthesize colVwBranch;
@synthesize sbText;

- (IBAction)unwindToBranchList:(UIStoryboardSegue *)segue
{
    [self loadingOverlayView];
    [self.homeModel downloadItems:dbBranch withData:[[NSUserDefaults standardUserDefaults] stringForKey:USERNAME]];
}

-(void)loadView
{
    [super loadView];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    colVwBranch.delegate = self;
    colVwBranch.dataSource = self;
    sbText.delegate = self;
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierBranch bundle:nil];
        [colVwBranch registerNib:nib forCellWithReuseIdentifier:reuseIdentifierBranch];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierBranchHeader bundle:nil];
        [colVwBranch registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifierBranchHeader];
    }
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tapGesture];

    
    [self loadingOverlayView];
    [self.homeModel downloadItems:dbBranch withData:[[NSUserDefaults standardUserDefaults] stringForKey:USERNAME]];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_branchList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger item = indexPath.item;
    
    CustomCollectionViewCellBranch *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierBranch forIndexPath:indexPath];
    cell.contentView.userInteractionEnabled = NO;
    cell.backgroundColor = item%2?mColVwBgColor:[UIColor whiteColor];
    
    
    Branch *branch = _branchList[item];
    cell.lblBranchNo.text = branch.branchNo;
    cell.lblBranchName.text = branch.name;
    
    NSString *strAddress = [Branch getAddress:branch];
    cell.lblAddress.text = strAddress;
    cell.lblPhoneNo.text = [Utility insertDashForPhoneNo:branch.phoneNo];
    cell.lblTableNum.text = [NSString stringWithFormat:@"%ld",branch.tableNum];
    cell.lblCustomerNum.text = [NSString stringWithFormat:@"%ld",branch.customerNumMax];
    cell.lblEmployeeNum.text = [NSString stringWithFormat:@"%ld",branch.employeePermanentNum];
    NSArray *statusImageList = @[@"green dot.png",@"yellow dot.png",@"red dot.png"];
    cell.imgVwStatus.image = [UIImage imageNamed:statusImageList[branch.status-1]];
    cell.btnEdit.tag = item;
    [cell.btnEdit addTarget:self action:@selector(editBranch:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    //lblBranchName
    {
        CGSize lblBranchNameSize = [self suggestedSizeWithFont:cell.lblBranchName.font size:CGSizeMake(70, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:cell.lblBranchName.text];
        CGRect frame = cell.lblBranchName.frame;
        frame.size.width = lblBranchNameSize.width;
        frame.size.height = lblBranchNameSize.height;
        cell.lblBranchName.frame = frame;
    }
    
    
    //address
    {
        CGSize lblAddressSize = [self suggestedSizeWithFont:cell.lblAddress.font size:CGSizeMake(colVwBranch.frame.size.width - 609, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:cell.lblAddress.text];
        CGRect frame = cell.lblAddress.frame;
        frame.size.width = lblAddressSize.width;
        frame.size.height = lblAddressSize.height;
        cell.lblAddress.frame = frame;
    }
    
    
    //phoneNo
    {
        CGSize lblPhoneNoSize = [self suggestedSizeWithFont:cell.lblPhoneNo.font size:CGSizeMake(70, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:cell.lblPhoneNo.text];
        CGRect frame = cell.lblPhoneNo.frame;
        frame.size.width = lblPhoneNoSize.width;
        frame.size.height = lblPhoneNoSize.height;
        cell.lblPhoneNo.frame = frame;
    }
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Branch *branch = _branchList[indexPath.item];
    UIFont *fontName = [UIFont systemFontOfSize:17.0];
    
    //lblBranchName
    CGSize lblBranchNameSize = [self suggestedSizeWithFont:fontName size:CGSizeMake(70, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:branch.name];
    
    
    //address
    NSString *strAddress = [Branch getAddress:branch];
    CGSize lblAddressSize = [self suggestedSizeWithFont:fontName size:CGSizeMake(colVwBranch.frame.size.width - 609, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:strAddress];
    
    
    //phoneNo
    CGSize lblPhoneNoSize = [self suggestedSizeWithFont:fontName size:CGSizeMake(70, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:branch.phoneNo];
    
    
    float height = 91;
    height = lblBranchNameSize.height>height?lblBranchNameSize.height:height;
    height = lblAddressSize.height>height?lblAddressSize.height:height;
    height = lblPhoneNoSize.height>height?lblPhoneNoSize.height:height;
    
    
    return CGSizeMake(collectionView.frame.size.width, height);
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    {
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)colVwBranch.collectionViewLayout;
        
        [layout invalidateLayout];
        [colVwBranch reloadData];
    }
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);//top, left, bottom, right
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        if([collectionView isEqual:colVwBranch])
        {
            CustomCollectionViewCellBranchHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifierBranchHeader forIndexPath:indexPath];
            headerView.backgroundColor = mLightBlueColor;
            reusableview = headerView;
        }
    }
    
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerPayment" forIndexPath:indexPath];
        
        reusableview = footerview;
    }
    
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
{
    CGSize headerSize = CGSizeMake(collectionView.bounds.size.width, 33);
    return headerSize;
}

- (IBAction)backToSetting:(id)sender
{
    [self.view endEditing:YES];
    [self performSegueWithIdentifier:@"segUnwindToSetting" sender:self];
}

-(void)editBranch:(id)sender
{
    UIButton *button = sender;
    _editBranch = _branchList[button.tag];
    [self performSegueWithIdentifier:@"segBranchAdd" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segBranchAdd"])
    {
        BranchAddViewController *vc = segue.destinationViewController;
        vc.editBranch = _editBranch;
    }
}


#pragma mark - search

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate   = [NSPredicate predicateWithFormat:@"(_branchNo contains[c] %@) or (_name contains[c] %@) or (_street contains[c] %@) or (_postCode contains[c] %@) or (_country contains[c] %@) or (_phoneNo contains[c] %@) or (_tableNum = %ld) or (_customerNumMax = %ld) or (_employeePermanentNum = %ld)", searchText, searchText, searchText, searchText, searchText, searchText, [searchText integerValue], [searchText integerValue], [searchText integerValue]];
    _branchList = [[_allBranchList filteredArrayUsingPredicate:resultPredicate] mutableCopy];
    _branchList = [Branch sortList:_branchList];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    // user did type something, check our datasource for text that looks the same
    if (searchText.length>0)
    {
        // search and reload data source
        self.searchBarActive = YES;
        [self filterContentForSearchText:searchText scope:@""];
        [colVwBranch reloadData];
        //set data to text
//        if([self.dataSourceForSearchResult count]>0)
//        {
//            [self setData:(PostCustomer*)self.dataSourceForSearchResult[_searchResultIndex]];
//            btnPreviousCustomer.enabled = _searchResultIndex>0;
//            btnNextCustomer.enabled = [self.dataSourceForSearchResult count]-1>_searchResultIndex;
//            _searchData = YES;
//        }
//        else
        {
//            [self showNotFoundSearchData];
//            btnPreviousCustomer.enabled = NO;
//            btnNextCustomer.enabled = NO;
//            _searchData = NO;
        }
    }
    else
    {
        // if text length == 0
        // we will consider the searchbar is not active
        self.searchBarActive = NO;
        [self cancelSearching];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self cancelSearching];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.searchBarActive = YES;
    [self.view endEditing:YES];
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // we used here to set self.searchBarActive = YES
    // but we'll not do that any more... it made problems
    // it's better to set self.searchBarActive = YES when user typed something
//    [self.searchBar setShowsCancelButton:YES animated:YES];
    [sbText setShowsCancelButton:YES animated:YES];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    // this method is being called when search btn in the keyboard tapped
    // we set searchBarActive = NO
    // but no need to reloadCollectionView
    //    self.searchBarActive = NO;
    
//    [self.searchBar setShowsCancelButton:NO animated:YES];
    [sbText setShowsCancelButton:NO animated:YES];
}
-(void)cancelSearching
{
    self.searchBarActive = NO;
    [self.searchBar resignFirstResponder];
    sbText.text  = @"";
}

- (IBAction)addBranch:(id)sender
{
    _editBranch = nil;
    [self performSegueWithIdentifier:@"segBranchAdd" sender:self];
}

-(void)itemsDownloaded:(NSArray *)items
{
    [self removeOverlayViews];
    _allBranchList = items[0];
    _branchList = _allBranchList;
    
    [colVwBranch reloadData];
}
@end
