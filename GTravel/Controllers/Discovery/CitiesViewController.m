//
//  CitiesViewController.m
//  GTravel
//
//  Created by Raynay Yue on 5/21/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "CitiesViewController.h"
#import "RYCommon.h"
#import "GTravelCityItem.h"
#import "GTCitiesCollectionCell.h"
#import "GTTablePartnerFoot.h"
#import "DTLogoViewController.h"

#define fCellSizeRatio (290.0 / 220.0)
#define fCellSpace 5
#define fLineSpace 10
#define fSectionTopInset 10
#define fSectionLeftInset 10
#define fSectionRightInset 10
#define fSectionBottomInset 10

#define iCityCountPerRequest 20
#define PaternerLogoHeight 120
#define FootSpace 30

@interface CitiesViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, GTTablePartnerFootDelegate> {
    NSInteger iIndex;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *cities;

@property (nonatomic, weak) GTTablePartnerFoot *footer;

- (CGSize)calculatedCollectionCellSize;
- (void)reloadCities;
- (void)loadCitiesAtIndex:(NSInteger)index count:(NSInteger)count;
@end

@implementation CitiesViewController

#pragma mark - Non-Public Methods
- (CGSize)calculatedCollectionCellSize
{
    CGFloat fWidth = (RYWinRect().size.width - fSectionLeftInset - fSectionRightInset - fCellSpace) * 0.5 - 4;
    CGFloat fHeight = fWidth / fCellSizeRatio;
    return CGSizeMake(fWidth, fHeight);
}

- (void)reloadCities
{
    iIndex = 0;
    [self loadCitiesAtIndex:iIndex count:iCityCountPerRequest];
}

- (void)loadCitiesAtIndex:(NSInteger)index count:(NSInteger)count
{
    [self.model requestCityListAtIndex:index
                                 count:count
                            completion:^(NSError *error, NSString *title, NSArray *cities) {
                              if (error) {
                                  RYCONDITIONLOG(DEBUG, @"%@", error);
                              }
                              else {
                                  self.title = title;
                                  NSMutableArray *indexesRemove = [NSMutableArray array];
                                  if (index == 0) {
                                      for (int i = 0; i < self.cities.count; i++) {
                                          [indexesRemove addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                                      }
                                      self.cities = [NSMutableArray array];
                                  }

                                  NSMutableArray *indexesInsert = [NSMutableArray array];
                                  for (int iRowIndex = 0; iRowIndex < cities.count; iRowIndex++) {
                                      [indexesInsert addObject:[NSIndexPath indexPathForRow:iRowIndex + self.cities.count inSection:0]];
                                  }
                                  [self.collectionView performBatchUpdates:^{
                                    [self.cities addObjectsFromArray:cities];
                                    [self.collectionView deleteItemsAtIndexPaths:indexesRemove];
                                    [self.collectionView insertItemsAtIndexPaths:indexesInsert];
                                  }
                                                                completion:NULL];
                              }
                              [self.refreshView endRefresh];
                            }];
}

#pragma mark - Public Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializedRefreshViewForView:self.collectionView];

    GTTablePartnerFoot *foot = [[GTTablePartnerFoot alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 64 + FootSpace, [UIScreen mainScreen].bounds.size.width, PaternerLogoHeight)];
    [self.view addSubview:foot];
    self.footer = foot;
    foot.delegate = self;
    self.footer.hidden = YES;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, FootSpace + PaternerLogoHeight, 0);

    [self reloadCities];
}

- (void)didReceiveMemoryWarning
{
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


#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self calculatedCollectionCellSize];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(fSectionTopInset, fSectionLeftInset, fSectionBottomInset, fSectionRightInset);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return fLineSpace;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return fCellSpace;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.cities.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"GTCitiesCollectionCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    GTCitiesCollectionCell *citiesCell = (GTCitiesCollectionCell *)cell;
    [citiesCell setCityItem:self.cities[indexPath.row]];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self openCityDetailOfCityItem:self.cities[indexPath.row]];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    GTCitiesCollectionCell *citiesCell = (GTCitiesCollectionCell *)cell;
    [citiesCell resetCell];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    if (self.collectionView.contentOffset.y + self.collectionView.frame.size.height >= self.collectionView.contentSize.height) {

        self.footer.hidden = NO;

        CGFloat content = self.collectionView.contentSize.height - self.collectionView.frame.size.height;
        CGFloat spacing = content - self.collectionView.contentOffset.y;

        self.footer.transform = CGAffineTransformMakeTranslation(0, spacing);
    }
    else {
        self.footer.hidden = YES;
    }

    NSLog(@"%f---%f---%f---%f", self.collectionView.contentOffset.y, self.collectionView.frame.size.height, self.collectionView.contentSize.height, self.collectionView.contentInset.bottom);
    //    NSLog(@"%f---%f --- %f",CGPointGetMaxY(self.collectionView.contentOffset),self.collectionView.contentSize.height);

    [self.refreshView scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.refreshView scrollViewDidEndDraging];
}

#pragma mark - SRRefreshViewDelegate
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    [self reloadCities];
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionReusableView *foot = nil;
//    if (kind == UICollectionElementKindSectionFooter){
//
//        GTTablePartnerFoot *footView = [[GTTablePartnerFoot alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 150)];
//
//        foot = footView;
//        UICollectionReusableView *footervsiew = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
//
//    }
//    return foot;
//}

#pragma mark--- DTPartnerLogoDelegate
- (void)showLogoDetail:(DTLogoButton *)button
{
    DTLogoViewController *vc = [[DTLogoViewController alloc] init];
    vc.url = button.linkURL;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showLogoDetailWithLeftButton:(DTLogoButton *)button
{
    DTLogoViewController *vc = [[DTLogoViewController alloc] init];
    vc.url = button.linkURL;
    vc.setBar = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
