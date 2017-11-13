//
//  ZSBReoprtFormView.h
//  ZSBReoprtFormDemo
//
//  Created by shibing zhang on 2017/11/10.
//  Copyright © 2017年 shibing zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSBReportFormModel.h"
#import "ZSBReportFormLayout.h"
#import "ZSBReportFormButton.h"

typedef void(^ZSBReportFormButtonClick)(ZSBReportFormButton *clickButton);

@interface ZSBReoprtFormView : UIView

@property (nonatomic, strong) ZSBReportFormModel *formDataModel;

@property (nonatomic, copy) ZSBReportFormButtonClick formButtonClick;

@end
