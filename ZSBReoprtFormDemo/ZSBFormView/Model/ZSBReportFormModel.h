//
//  ZSBReportFormModel.h
//  ZSBReoprtFormDemo
//
//  Created by shibing zhang on 2017/11/10.
//  Copyright © 2017年 shibing zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZSBReoprtFormSubModel.h"

//每一项的默认宽度
#define RFDefaultWidth 50.0

//每一项的默认宽度
#define RFMaxWidth 100.0

//每一项的默认高度
#define RFDefaultHeight 35.0

//每一项的内边距
#define RFItemInsert UIEdgeInsetsMake(7, 7, 7, 7)

//图片默认尺寸
#define ZSBReportFormDefaultPictureSize CGSizeMake(RFMaxWidth,60)

//按钮默认尺寸
#define RFDefaultButtonSize CGSizeMake(RFDefaultWidth,RFDefaultHeight)

@interface ZSBReportFormModel : NSObject

/*
 *表头
 *包含 ZSBReoprtFormSubModel
 */
@property (nonatomic, strong) NSArray *headerList;

/*
 *内容
 *包含 ZSBReoprtFormSubModel、NSArray(ZSBReoprtFormSubModel)
 */
@property (nonatomic, strong) NSArray <NSArray *> *dataList;

/*
 *最大宽度集合
 */
@property (nonatomic, strong) NSArray *maxWidths;

/*
 *最大高度集合
 */
@property (nonatomic, strong) NSArray *maxHeights;

/*
 *锁定行数
 */
@property (nonatomic, assign) NSInteger lockRows;

/*
 *锁定列数
 */
@property (nonatomic, assign) NSInteger lockColumns;

/*
 * 计算内容的size
 */
- (void)calculateModelSize;



@end
