//
//  GTAroundTagsTableCell.m
//  GTravel
//
//  Created by Raynay Yue on 6/5/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTAroundTagsTableCell.h"
#import "RYCommon.h"
#import "GTTagsCollectionCell.h"
#import "GTCategory.h"

@interface GTAroundTagsTableCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) id<GTAroundTagsTableCellDelegate> delegate;

@property (nonatomic, strong) NSArray *arrCategories;

- (IBAction)onFilterButton:(id)sender;
@end

@implementation GTAroundTagsTableCell
#pragma mark - IBAction Methods
- (IBAction)onFilterButton:(id)sender
{
    if (RYDelegateCanResponseToSelector(self.delegate, @selector(tagsTableCellFilterButtonDidClick:))) {
        [self.delegate tagsTableCellFilterButtonDidClick:self];
    }
}

#pragma mark - Non-Public Methods
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Public Methods
- (void)setCategories:(NSArray *)categories delegate:(id<GTAroundTagsTableCellDelegate>)delegate
{
    self.delegate = delegate;
    self.arrCategories = categories;
    [self.collectionView reloadData];
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
}

- (void)selectCategory:(GTCategory *)category
{
    NSInteger iIndex = 0;
    if (category != nil) {
        for (GTCategory *cate in self.arrCategories) {
            if ([category.categoryID integerValue] == [cate.categoryID integerValue]) {
                iIndex = [self.arrCategories indexOfObject:cate] + 1;
                break;
            }
        }
    }
    if (iIndex > 0) {
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:iIndex inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrCategories.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GTTagsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([GTTagsCollectionCell class]) forIndexPath:indexPath];
    if (cell.selectedBackgroundView == nil) {
        CGSize cellSize = [GTTagsCollectionCell sizeForTagsCollectionCell];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cellSize.width, cellSize.height)];
        view.backgroundColor = [UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1.0];
        cell.selectedBackgroundView = view;
    }

    if (indexPath.row > 0) {
        GTCategory *cate = self.arrCategories[indexPath.row - 1];
        [cell setNameOfCell:cate.title];
    }
    else {
        [cell setNameOfCell:@"全部"];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];

    GTCategory *cate = indexPath.row > 0 ? self.arrCategories[indexPath.row - 1] : nil;
    if (RYDelegateCanResponseToSelector(self.delegate, @selector(tagsTableCell:didClickCategory:))) {
        [self.delegate tagsTableCell:self didClickCategory:cate];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [GTTagsCollectionCell sizeForTagsCollectionCell];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 1, 0, 1);
}
@end
