//
//  ZSBReportFormButton.h
//  ZSBReoprtFormDemo
//
//  Created by shibing zhang on 2017/11/10.
//  Copyright © 2017年 shibing zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSBReoprtFormSubModel.h"

@interface ZSBReportFormButton : UIButton

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) ZSBReoprtFormSubModel *subModel;

@end
