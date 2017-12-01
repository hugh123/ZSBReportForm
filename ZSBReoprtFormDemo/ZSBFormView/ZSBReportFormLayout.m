//
//  ZSBReportFormLayout.m
//  ZSBReoprtFormDemo
//
//  Created by shibing zhang on 2017/11/12.
//  Copyright © 2017年 shibing zhang. All rights reserved.
//

#import "ZSBReportFormLayout.h"

@interface ZSBReportFormLayout()

@property (nonatomic, strong) NSArray *widths;

@property (nonatomic, strong) NSArray *heights;

@property(nonatomic,strong)NSMutableArray *itemAttributes;//所有item的布局

@property (nonatomic, assign) CGSize contentSize;//collectionView的contentSize大小

@end

@implementation ZSBReportFormLayout

- (void)setWidths:(NSArray *)widthList andHeights:(NSArray *)heightList {
    self.itemAttributes = nil;
    self.widths = widthList;
    self.heights = heightList;
}

//每一个滚动都会走这里，去确定每一个item的位置
-(void)prepareLayout{
    if ([self.collectionView numberOfSections] == 0) {
        return;
    }
    
    NSUInteger allColumn = self.widths.count;
    NSUInteger column = 0;//列
    CGFloat xOffset = 0.0;//X方向的偏移量
    CGFloat yOffset = 0.0;//Y方向的偏移量
    CGFloat contentWidth = 0.0;//collectionView.contentSize的宽度
    CGFloat contentHeight = 0.0;//collectionView.contentSize的高度
    
    if (self.itemAttributes.count > 0) {
        for (int section = 0; section < [self.collectionView numberOfSections]; section++) {
            NSUInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
            for (NSUInteger row = 0; row < numberOfItems; row++) {
                if (section != 0 && row >= self.lockColumns) {
                    continue;
                }
                UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:row inSection:section]];
                if (section == 0) {
                    CGRect frame = attributes.frame;
                    frame.origin.y = self.collectionView.contentOffset.y;
                    attributes.frame = frame;
                }
                //确定锁定列的位置
                if (row < self.lockColumns) {
                    CGRect frame = attributes.frame;
                    float offsetX = 0;
                    if (index > 0) {
                        for (int i = 0; i < row; i++) {
                            offsetX += [self.widths[i] floatValue];
                        }
                    }
                    
                    frame.origin.x = self.collectionView.contentOffset.x + offsetX;
                    attributes.frame = frame;
                }
            }
        }
        
        return;
    }
    
    self.itemAttributes = [@[] mutableCopy];
    
    
    for (int section = 0; section < [self.collectionView numberOfSections]; section ++) {
        NSMutableArray *sectionAttributes = [@[] mutableCopy];
        for (NSUInteger row = 0; row < allColumn; row++) {
            CGSize itemSize = CGSizeMake([self.widths[row] floatValue], [self.heights[section] floatValue]);
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:row inSection:section];
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attributes.frame = CGRectIntegral(CGRectMake(xOffset, yOffset, itemSize.width, itemSize.height));
            if (section == 0 && row < self.lockColumns) {
                attributes.zIndex = 2014; // 设置这个值是为了 让第一项(Sec0Row0)显示在第一列和第一行
            } else if (section == 0 || row < self.lockColumns) {
                attributes.zIndex = 2013; // 设置这个是为了 让第一行在上下滚动的时候固定和锁定的列在左右滚动的时候固定，这个值要比上面的小要比0大
            }
            if (section == 0) {
                CGRect frame = attributes.frame;
                frame.origin.y = self.collectionView.contentOffset.y;
                attributes.frame = frame;
            }
            
            if (row < self.lockColumns) {
                CGRect frame = attributes.frame;
                float offsetX = 0;
                if (index > 0) {
                    for (int i = 0; i < row; i++) {
                        offsetX += [self.widths[i] floatValue];
                    }
                }
                
                frame.origin.x = self.collectionView.contentOffset.x + offsetX;
                attributes.frame = frame;
            }
            
            [sectionAttributes addObject:attributes];
            
            xOffset = xOffset + itemSize.width;
            column ++;
            
            if (column == allColumn) {
                if (xOffset > contentWidth) {
                    contentWidth = xOffset;
                }
                
                // 重置基本变量
                column = 0;
                xOffset = 0;
                yOffset += itemSize.height;
            }
        }
        [self.itemAttributes addObject:sectionAttributes];
    }
    
    // 获取右下角最有一个item，确定collectionView的contentSize大小
    UICollectionViewLayoutAttributes *attributes = [[self.itemAttributes lastObject] lastObject];
    contentHeight = attributes.frame.origin.y + attributes.frame.size.height;
    _contentSize = CGSizeMake(contentWidth, contentHeight);
}

-(CGSize)collectionViewContentSize{
    return  _contentSize;
}

-(UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    //    UICollectionViewLayoutAttributes *cc = self.itemAttributes[indexPath.section][indexPath.row];
    //    NSLog(@"%ld,%ld,%@",(long)indexPath.section,(long)indexPath.row,NSStringFromCGRect(cc.frame));
    return self.itemAttributes[indexPath.section][indexPath.row];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributes = [@[] mutableCopy];
    for (NSArray *section in self.itemAttributes) {
        [attributes addObjectsFromArray:[section filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *evaluatedObject, NSDictionary *bindings) {
            CGRect frame = [evaluatedObject frame];
            return CGRectIntersectsRect(rect, frame);
        }]]];
    }
    
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

@end
