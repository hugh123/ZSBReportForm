//
//  ZSBReportFormViewItemCell.h
//  ZSBReoprtFormDemo
//
//  Created by shibing zhang on 2017/11/10.
//  Copyright © 2017年 shibing zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSBReportFormModel.h"
#import "ZSBReoprtFormSubModel.h"
#import "ZSBReportFormButton.h"

@protocol ZSBReportFormCellDelegate <NSObject>

- (void)cell:(id)cell_ didClickOnButton:(ZSBReportFormButton *)clickButton;

@end

@interface ZSBReportFormViewItemCell : UICollectionViewCell

@property (nonatomic, strong) NSArray *rowDatas;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, assign) id <ZSBReportFormCellDelegate> delegate;

@end
