//
//  ViewController.m
//  广告栏collectionview
//
//  Created by 刘小椿 on 16/10/9.
//  Copyright © 2016年 刘小椿. All rights reserved.
//

#import "ViewController.h"
#import "XCADCollectionViewCell.h"
#import <UIImageView+WebCache.h>
#import "XCCollectionViewLayout.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong)XCCollectionViewLayout* layout;
@property (nonatomic, strong)NSArray* imageUrls;
@property (nonatomic, assign)CGFloat contentX;
@property (nonatomic, assign)NSInteger currentPage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateNormal;
    self.layout = [[XCCollectionViewLayout alloc] init];
    self.collectionView.collectionViewLayout = self.layout;
//    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.contentOffset = CGPointMake(self.view.bounds.size.width / 2 + 40, 0);
    self.imageUrls = @[@"http://g.hiphotos.baidu.com/image/pic/item/03087bf40ad162d9ec74553b14dfa9ec8a13cd7a.jpg",
                       @"http://e.hiphotos.baidu.com/image/pic/item/14ce36d3d539b600be63e95eed50352ac75cb7ae.jpg",
                       @"http://b.hiphotos.baidu.com/image/pic/item/f703738da9773912825f6388fc198618377ae2da.jpg",
                       @"http://pic1.win4000.com/pic/7/98/46ff752619.jpg",
                       @"http://pic1.win4000.com/pic/9/2c/5ade1167912.jpg",
                       @"http://g.hiphotos.baidu.com/image/pic/item/03087bf40ad162d9ec74553b14dfa9ec8a13cd7a.jpg",
                       @"http://e.hiphotos.baidu.com/image/pic/item/14ce36d3d539b600be63e95eed50352ac75cb7ae.jpg"];
}

#pragma mark -delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.contentX = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.currentPage = scrollView.contentOffset.x / 220;
    
    if (scrollView.contentOffset.x > self.contentX) {
        if (scrollView.contentOffset.x > ((self.imageUrls.count - 2) * 20 + self.imageUrls.count * 200 - self.view.bounds.size.width / 2) - 100) {
            [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
            //滚动到中间
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        }
    }else{
        if (scrollView.contentOffset.x < 120) {
            [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:self.imageUrls.count - 2 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
            //滚动到中间
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.imageUrls.count - 2 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        }
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageUrls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XCADCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.layer.doubleSided = NO;
    [cell.adImageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrls[indexPath.row]] placeholderImage:[UIImage imageNamed:@"1.jpg"]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    //滚动到中间
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

//FlowLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(200, collectionView.frame.size.height - 100);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    NSInteger itemCount = [self collectionView:collectionView numberOfItemsInSection:section];
    
    NSIndexPath *firstIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    CGSize firstSize = [self collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:firstIndexPath];
    
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:itemCount - 1 inSection:section];
    CGSize lastSize = [self collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:lastIndexPath];
    return UIEdgeInsetsMake(0, (collectionView.bounds.size.width - firstSize.width) / 2,
                            0, (collectionView.bounds.size.width - lastSize.width) / 2);
}

#pragma mark -responder
- (IBAction)goLeftAction:(id)sender {
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentPage - 1 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    //滚动到中间
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentPage - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (IBAction)goRightAction:(id)sender {
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentPage + 1 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    //滚动到中间
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentPage + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

@end

