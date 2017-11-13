//
//  ZSBReoprtFormSubModel.h
//  ZSBReoprtFormDemo
//
//  Created by shibing zhang on 2017/11/10.
//  Copyright © 2017年 shibing zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ZSBReoprtFormItemTypeText,//文字
    ZSBReoprtFormItemTypeButton,//按钮
    ZSBReoprtFormItemTypeImage,//图片
} ZSBReoprtFormItemType;

@interface ZSBReoprtFormSubModel : NSObject

@property (nonatomic, strong) NSString *key;
//内容
@property (nonatomic, strong) NSString *value;
//尺寸
@property (nonatomic, assign) CGSize size;
//类型
@property (nonatomic, assign) ZSBReoprtFormItemType itemType;

+ (ZSBReoprtFormSubModel *)defaultTitleForKey:(NSString *)key andName:(NSString *)name;
+ (ZSBReoprtFormSubModel *)defaultButtonForKey:(NSString *)key andName:(NSString *)name;

@end
