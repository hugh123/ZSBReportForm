//
//  ZSBReportFormModel.m
//  ZSBReoprtFormDemo
//
//  Created by shibing zhang on 2017/11/10.
//  Copyright © 2017年 shibing zhang. All rights reserved.
//

#import "ZSBReportFormModel.h"

@implementation ZSBReportFormModel


/*
 * 计算内容的size
 */
- (void)calculateModelSize {
    
    UIFont *textFont = [UIFont systemFontOfSize:12];
    NSMutableArray *widths = [[NSMutableArray alloc] init];
    NSMutableArray *heights = [[NSMutableArray alloc] init];
    
    //计算宽度
    for (NSInteger i = 0; i < self.headerList.count; i++) {
        //设置默认宽度
        CGFloat maxWidth = RFDefaultWidth;
        
        //计算头部的尺寸
        ZSBReoprtFormSubModel *subModel = self.headerList[i];
        CGSize headerSize = [self sizeWithText:subModel.value font:textFont andMaxWidth:RFMaxWidth];
        
        //当宽度大于默认尺寸的时候重新赋值
        if (headerSize.width > RFDefaultWidth) {
            maxWidth = headerSize.width;
        }
        
        //计算内容的尺寸
        for (NSInteger j = 0; j < self.dataList.count; j++) {
            
            NSArray *rowList = self.dataList[j];
            if (rowList.count > i) {
                if ([rowList[i] isKindOfClass:[NSArray class]]) {
                    //当单元格中有多行数据的时候计算每一行数据的宽度，并找出最大的宽度
                    NSArray *subList = rowList[i];
                    for (ZSBReoprtFormSubModel *sub in subList) {
                        CGSize size = [self sizeWithText:sub.value font:textFont andMaxWidth:RFMaxWidth];
                        //当宽度大于默认尺寸的时候重新赋值
                        if (size.width > RFDefaultWidth) {
                            maxWidth = size.width;
                        }
                    }
                }else {
                    //当单元格中只有一行数据的时候计算宽度
                    ZSBReoprtFormSubModel *sub = rowList[i];
                    CGSize size = [self sizeWithText:sub.value font:textFont andMaxWidth:RFMaxWidth];
                    if (size.width > RFDefaultWidth) {
                        maxWidth = size.width;
                    }
                }
            }
        }
        //将每一列最大的宽度添加到列表中
        [widths addObject:@(maxWidth)];
    }
    
    //根据每一列最大的宽度计算高度
    for (NSInteger i = 0; i < self.dataList.count + 1; i++) {
        CGFloat maxHeight = RFDefaultHeight;
        
        NSArray *rowList = nil;
        if (i == 0) {
            //头部
            rowList = self.headerList;
        }else {
            //内容
            rowList = self.dataList[i-1];
        }
        
        //所有多行数据的单元格中每一行的最大高度
        NSMutableArray *maxSubHeightList = [[NSMutableArray alloc] init];

        for (NSInteger j = 0 ; j < rowList.count; j++) {
            
            if (rowList.count > j && widths.count > j) {
                
                //当前列的最大宽度
                CGFloat width = [widths[j] floatValue];
                
                if ([rowList[j] isKindOfClass:[NSArray class]]) {
                    //当单元格中有多行数据的时候
                    NSArray *subList = rowList[j];
                    
                    //计算每一行数据的高度总和
                    for (NSInteger k = 0; k < subList.count; k++) {
                        ZSBReoprtFormSubModel *sub = subList[k];
                        CGSize size = [self sizeWithText:sub.value font:textFont andMaxWidth:width];
                        sub.size = CGSizeMake(width,
                                              size.height > RFDefaultHeight ? size.height : RFDefaultHeight);
                        //多行单元格中当前行的最大高度
                        CGFloat maxSubHeight = RFDefaultHeight;
                        if (k < maxSubHeightList.count) {
                            maxSubHeight = [maxSubHeightList[k] floatValue];
                            if (maxSubHeight < sub.size.height) {
                                maxSubHeight = sub.size.height;
                                [maxSubHeightList replaceObjectAtIndex:k withObject:@(maxSubHeight)];
                            }
                        }else {
                            maxSubHeight = sub.size.height;
                            [maxSubHeightList addObject:@(maxSubHeight)];
                        }
                    }
                }else {
                    //当单元格中只有一行数据的时候
                    ZSBReoprtFormSubModel *sub = rowList[j];
                    CGSize size = [self sizeWithText:sub.value font:textFont andMaxWidth:width];
                    sub.size = CGSizeMake(width,
                                          size.height > RFDefaultHeight ? size.height : RFDefaultHeight);
                    if (size.height > maxHeight) {
                        maxHeight = size.height;
                    }
                }
            }
        }
        
        //计算多行单元格的最大高度
        CGFloat maxSubHeight = 0.0;
        for (NSNumber *height in maxSubHeightList) {
            maxSubHeight += [height floatValue];
        }
        if (maxSubHeightList.count > 0) {
            maxSubHeight += (RFItemInsert.top + RFItemInsert.bottom) * (maxSubHeightList.count - 1);
        }
        
        //重新比较最大高度
        if (maxSubHeight > maxHeight) {
            maxHeight = maxSubHeight;
        }
        
        [heights addObject:@(maxHeight+RFItemInsert.top + RFItemInsert.bottom)];
    }
    
    //计算完高度之后重新对宽度增加左右边距的长度
    NSMutableArray *addGapWidths = [[NSMutableArray alloc] init];
    for (NSNumber *width in widths) {
        [addGapWidths addObject: @([width floatValue]+RFItemInsert.left + RFItemInsert.right)];
    }
    
    //赋值高度和宽度列表
    self.maxWidths = addGapWidths;
    self.maxHeights = heights;

    //对每一空数据进行尺寸计算赋值
    for (NSInteger i = 0; i < self.dataList.count; i++) {
        NSArray *rowList = self.dataList[i];
        CGFloat maxHeight = [heights[i+1] floatValue];
        
        NSMutableArray *arrayList = [[NSMutableArray alloc] init];
        //每一行中每个多行单元格每条数据的最高高度
        NSMutableArray *maxSubHeights = [[NSMutableArray alloc] init];
        
        for (NSInteger j = 0; j < rowList.count; j++) {
            
            CGFloat maxWidth = [widths[j] floatValue];
            
            if ([rowList[j] isKindOfClass:[NSArray class]]) {
                NSArray *subList = rowList[j];
                [arrayList addObject:subList];
                
                for (NSInteger k = 0; k < subList.count; k++) {
                    ZSBReoprtFormSubModel *sub = subList[k];
                    CGFloat maxSubHeight = 0;
                    if (k < maxSubHeights.count) {
                        maxSubHeight = [maxSubHeights[k] floatValue];
                        if (maxSubHeight < sub.size.height) {
                            maxSubHeight = sub.size.height;
                            [maxSubHeights replaceObjectAtIndex:k withObject:@(maxSubHeight)];
                        }
                    }else {
                        maxSubHeight = sub.size.height;
                        [maxSubHeights addObject:@(maxSubHeight)];
                    }
                }
            }else {
                //单行数据单元格
                ZSBReoprtFormSubModel *sub = rowList[j];
                CGSize size = sub.size;
                size.width = maxWidth;
                size.height = maxHeight - RFItemInsert.top - RFItemInsert.bottom;
                sub.size = size;
            }
        }
        
        for (NSInteger j = 0; j < arrayList.count; j++) {
            NSArray *array = arrayList[j];
            for (NSInteger k = 0; k < array.count; k++) {
                ZSBReoprtFormSubModel *sub = array[k];
                
                CGSize size = sub.size;
                size.height = [maxSubHeights[k] floatValue];
                sub.size = size;
            }
        }
        
    }
}


/// 根据指定文本和字体计算尺寸
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font andMaxWidth:(CGFloat)maxWidth
{
    return [self sizeWithText:text font:font maxWidth:maxWidth];
}

/// 根据指定文本,字体和最大宽度计算尺寸
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxWidth:(CGFloat)width
{
    NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
    attrDict[NSFontAttributeName] = font;
    CGSize size = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrDict context:nil].size;
    return size;
}
@end
