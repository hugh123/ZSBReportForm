//
//  ZSBReportFormViewItemCell.m
//  ZSBReoprtFormDemo
//
//  Created by shibing zhang on 2017/11/10.
//  Copyright © 2017年 shibing zhang. All rights reserved.
//

#import "ZSBReportFormViewItemCell.h"
#import "ZSBReportFormButton.h"
#import "ZSBReportFormDefine.h"


@interface ZSBReportFormViewItemCell()

@property (nonatomic, strong) NSMutableArray *itemSubViews;
@property (nonatomic, strong) NSMutableArray <UILabel *> *itemLabels;
@property (nonatomic, strong) NSMutableArray <ZSBReportFormButton *> *itemButtons;
@property (nonatomic, strong) NSMutableArray <UIImageView *> *itemImageViews;
@property (nonatomic, strong) NSMutableArray <UIView *> *itemLineViews;

@property (nonatomic, strong) UIView *itemView;

@property (nonatomic, strong) UIView *rightLine;
@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation ZSBReportFormViewItemCell

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self setupView];
    }
    return self;
}

#pragma mark - initData

- (void)initData {
    self.itemSubViews = [[NSMutableArray alloc] init];
    self.itemLabels = [[NSMutableArray alloc] init];
    self.itemButtons = [[NSMutableArray alloc] init];
    self.itemImageViews = [[NSMutableArray alloc] init];
    self.itemLineViews = [[NSMutableArray alloc] init];
}

- (void)setRowDatas:(NSArray *)rowDatas {
    _rowDatas = rowDatas;
    
    //刷新视图
    [self reloadCell];
}

#pragma mark - setupViews

//初始化视图
- (void)setupView {
//    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    self.layer.borderWidth = 0.5f;
    
    self.itemView = [[UIView alloc] init];
    [self.contentView addSubview:self.itemView];
}

//刷新视图
- (void)reloadCell {
    
    [self.itemSubViews removeAllObjects];

    self.itemView.frame = CGRectMake(0,
                                     0,
                                     self.frame.size.width,
                                     self.frame.size.height);
    
    NSInteger textIndex = 0;
    NSInteger buttonIndex = 0;
    NSInteger imageIndex = 0;
    UIView *lastView = nil;

    for (NSInteger i = 0; i < self.rowDatas.count; i++) {
        ZSBReoprtFormSubModel *itemModel = self.rowDatas[i];
        if (itemModel.itemType == ZSBReoprtFormItemTypeText) {
            //绘制Label
            UILabel *label = nil;
            if (textIndex < self.itemLabels.count) {
                label = self.itemLabels[textIndex];
            }else {
                label = [self createLabel];
                [self.itemLabels addObject:label];
                [self.itemView addSubview:label];
            }
            label.hidden = NO;
            label.text = itemModel.value;
            textIndex++;
            [self.itemSubViews addObject:label];
            
            label.frame = CGRectMake(RFItemInsert.left,
                                     lastView.frame.origin.y+lastView.frame.size.height + RFItemInsert.top,
                                     self.itemView.frame.size.width - RFItemInsert.left - RFItemInsert.right,
                                     itemModel.size.height);
            lastView = label;
        }else if (itemModel.itemType == ZSBReoprtFormItemTypeButton) {
            //绘制Button
            ZSBReportFormButton *button = nil;
            if (textIndex < self.itemButtons.count) {
                button = self.itemButtons[textIndex];
            }else {
                button = [self createButton];
                [self.itemButtons addObject:button];
                [self.itemView addSubview:button];
            }
            button.hidden = NO;
            button.indexPath = self.indexPath;
            button.index = buttonIndex;
            button.subModel = itemModel;
            [button setTitle:itemModel.value forState:UIControlStateNormal];
            buttonIndex++;
            [self.itemSubViews addObject:button];
            
            button.frame = CGRectMake(RFItemInsert.left,
                                     lastView.frame.origin.y+lastView.frame.size.height + RFItemInsert.top,
                                     itemModel.size.width,
                                     itemModel.size.height);
            
            lastView = button;
        }
        
        //线条
        UIView *line = nil;
        if (i < self.itemLineViews.count) {
            line = self.itemLineViews[i];
        }else {
            line = [self createLine];
            [self.itemLineViews addObject:line];
            [self.itemView addSubview:line];
        }
        line.hidden = NO;
        line.frame = CGRectMake(0, lastView.frame.origin.y+lastView.frame.size.height+RFItemInsert.bottom-0.5, self.itemView.frame.size.width, 0.5);
        lastView = line;
    }

    for (NSInteger i = textIndex; i < self.itemLabels.count; i++) {
        UILabel *label = self.itemLabels[i];
        label.hidden = YES;
    }
    
    for (NSInteger i = buttonIndex; i < self.itemButtons.count; i++) {
        ZSBReportFormButton *button = self.itemButtons[i];
        button.hidden = YES;
    }
    
    for (NSInteger i = self.rowDatas.count-1; i < self.itemLineViews.count; i++) {
        UIView *line = self.itemLineViews[i];
        line.hidden = YES;
    }
}

//创建label
- (UILabel *)createLabel {
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 12;
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

//创建按钮
- (ZSBReportFormButton *)createButton {
    ZSBReportFormButton *button = [ZSBReportFormButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

//创建图片
- (UIImageView *)createImageView {
    UIImageView *imageView = [[UIImageView alloc] init];
    return imageView;
}

- (UIView *)createLine {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor lightGrayColor];
    return line;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

#pragma mark - action

- (void)buttonClick:(ZSBReportFormButton *)button {
    NSLog(@"key = %@ ,IndexPath = %@ , index = %li",button.subModel.key, button.indexPath,button.index);
    if ([self.delegate respondsToSelector:@selector(cell:didClickOnButton:)]) {
        [self.delegate cell:self didClickOnButton:button];
    }
}

@end
