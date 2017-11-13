//
//  ZSBReportFormLayout.h
//  ZSBReoprtFormDemo
//
//  Created by shibing zhang on 2017/11/12.
//  Copyright © 2017年 shibing zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSBReportFormLayout : UICollectionViewLayout

@property (nonatomic, assign) NSInteger lockRows;
@property (nonatomic, assign) NSInteger lockColumns;

- (void)setWidths:(NSArray *)widthList andHeights:(NSArray *)heightList;

@end
