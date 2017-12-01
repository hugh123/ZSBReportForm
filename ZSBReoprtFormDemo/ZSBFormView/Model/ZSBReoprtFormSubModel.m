//
//  ZSBReoprtFormSubModel.m
//  ZSBReoprtFormDemo
//
//  Created by shibing zhang on 2017/11/10.
//  Copyright © 2017年 shibing zhang. All rights reserved.
//

#import "ZSBReoprtFormSubModel.h"
#import "ZSBReportFormDefine.h"

@implementation ZSBReoprtFormSubModel

+ (ZSBReoprtFormSubModel *)defaultTitleForKey:(NSString *)key andName:(NSString *)name {
    ZSBReoprtFormSubModel *subModel = [[ZSBReoprtFormSubModel alloc] init];
    subModel.key = key;
    subModel.value = name;
    subModel.itemType = ZSBReoprtFormItemTypeText;
    return subModel;
}

+ (ZSBReoprtFormSubModel *)defaultButtonForKey:(NSString *)key andName:(NSString *)name {
    ZSBReoprtFormSubModel *subModel = [[ZSBReoprtFormSubModel alloc] init];
    subModel.key = key;
    subModel.value = name;
    subModel.itemType = ZSBReoprtFormItemTypeButton;
    subModel.size = RFDefaultButtonSize;
    return subModel;
}

@end
